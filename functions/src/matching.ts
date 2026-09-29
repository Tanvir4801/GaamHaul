import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import { filterAndSortCandidates, CandidateVehicle } from "./utils/matchingLogic";
import { MATCHING_MAX_RADIUS_KM } from "./utils/geo";
import { sendFCM } from "./utils/fcmLogic";

const db = admin.firestore();

export const matchRequest = onDocumentCreated("requests/{requestId}", async (event) => {
  const snapshot = event.data;
  if (!snapshot) {
    logger.info("No data associated with the event");
    return;
  }

  const request = snapshot.data();
  const requestId = event.params.requestId;

  // 1. Basic Validation
  if (request.status !== "open") {
    logger.info(`Request ${requestId} is not open, exiting.`);
    return;
  }

  if (!request.vehicleTypeRequested || !request.pickupLocation || !request.customerId) {
    logger.error(`Request ${requestId} is missing required fields (vehicleTypeRequested, pickupLocation, customerId).`);
    return;
  }

  const pickup = request.pickupLocation as admin.firestore.GeoPoint;
  
  // 2. Location Validation
  if (
    !pickup ||
    typeof pickup.latitude !== "number" ||
    typeof pickup.longitude !== "number" ||
    pickup.latitude < -90 || pickup.latitude > 90 ||
    pickup.longitude < -180 || pickup.longitude > 180
  ) {
    logger.error(`Request ${requestId} has invalid pickupLocation: ${JSON.stringify(pickup)}`);
    return;
  }

  // 3. Query Vehicles
  const vehiclesRef = db.collection("vehicles");
  const vehiclesQuery = vehiclesRef
    .where("status", "==", "on_duty")
    .where("type", "==", request.vehicleTypeRequested);
  
  const vehiclesSnapshot = await vehiclesQuery.get();
  
  if (vehiclesSnapshot.empty) {
    logger.info(`No on-duty vehicles of type ${request.vehicleTypeRequested} found.`);
    await updateShortlist(requestId, [], []);
    return;
  }

  const candidateVehicles: CandidateVehicle[] = vehiclesSnapshot.docs.map(doc => {
    const data = doc.data();
    return {
      id: doc.id,
      ownerId: data.ownerId,
      lastKnownLocation: data.lastKnownLocation ? {
        latitude: data.lastKnownLocation.latitude,
        longitude: data.lastKnownLocation.longitude
      } : undefined,
      lastUpdatedAt: data.lastUpdatedAt ? {
        seconds: data.lastUpdatedAt.seconds
      } : undefined
    };
  });
  
  // Collect ownerIds to verify verificationStatus
  const ownerIds = new Set<string>();
  for (const v of candidateVehicles) {
    if (v.ownerId) ownerIds.add(v.ownerId);
  }

  // Fetch vahan_saathis for the ownerIds (chunked by 30 to respect Firestore limits)
  const ownerIdsArray = Array.from(ownerIds);
  const verifiedOwnerIds = new Set<string>();

  for (let i = 0; i < ownerIdsArray.length; i += 30) {
    const chunk = ownerIdsArray.slice(i, i + 30);
    const saathisSnapshot = await db
      .collection("vahan_saathis")
      .where(admin.firestore.FieldPath.documentId(), "in", chunk)
      .get();

    saathisSnapshot.docs.forEach(doc => {
      if (doc.data().verificationStatus === "approved") {
        verifiedOwnerIds.add(doc.id);
      }
    });
  }

  const nowSeconds = admin.firestore.Timestamp.now().seconds;
  
  const shortlist = filterAndSortCandidates(
    { latitude: pickup.latitude, longitude: pickup.longitude },
    candidateVehicles,
    verifiedOwnerIds,
    nowSeconds
  );

  const saathiIdsSet = new Set<string>();
  for (const vId of shortlist) {
    const vehicle = candidateVehicles.find(v => v.id === vId);
    if (vehicle?.ownerId) {
      saathiIdsSet.add(vehicle.ownerId);
    }
  }
  const shortlistedSaathiIds = Array.from(saathiIdsSet);

  logger.info(`Shortlisted ${shortlist.length} vehicles and ${shortlistedSaathiIds.length} saathis for request ${requestId}.`, {
    radius: MATCHING_MAX_RADIUS_KM
  });

  // Server-only Write
  await updateShortlist(requestId, shortlist, shortlistedSaathiIds);

  if (shortlistedSaathiIds.length > 0) {
    // Non-blocking fire-and-forget notification
    sendFCM(db, {
      notificationId: `matched_${requestId}`,
      targetUids: shortlistedSaathiIds,
      title: "New Request Nearby",
      body: "A customer needs your vehicle for a job.",
      data: { requestId, type: "matched" }
    }).catch(e => logger.error("Error triggering matched FCM", e));
  }
});

/**
 * Updates the shortlistedVehicleIds and shortlistedSaathiIds safely in a transaction.
 */
async function updateShortlist(requestId: string, shortlist: string[], shortlistedSaathiIds: string[]) {
  const requestRef = db.collection("requests").doc(requestId);
  
  try {
    await db.runTransaction(async (transaction) => {
      const doc = await transaction.get(requestRef);
      if (!doc.exists) {
        return;
      }
      
      const status = doc.data()?.status;
      if (status !== "open") {
        logger.info(`Request ${requestId} changed status to ${status} before shortlist was written.`);
        return;
      }
      
      transaction.update(requestRef, { 
        shortlistedVehicleIds: shortlist,
        shortlistedSaathiIds: shortlistedSaathiIds
      });
    });
  } catch (error) {
    logger.error(`Failed to update shortlist for request ${requestId}:`, error);
  }
}
