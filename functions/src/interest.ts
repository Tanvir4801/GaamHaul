import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import { validateInterest } from "./utils/interestLogic";
import { sendFCM } from "./utils/fcmLogic";

export const MAX_INTERESTED_SAATHIS = 10;

export const markInterested = onCall(async (request) => {
  // 1. Auth Validation
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated to express interest.");
  }
  const uid = request.auth.uid;

  // 2. Input Validation
  const { requestId, vehicleId } = request.data;
  if (!requestId || typeof requestId !== "string" || requestId.trim() === "") {
    throw new HttpsError("invalid-argument", "Missing or invalid requestId.");
  }
  if (!vehicleId || typeof vehicleId !== "string" || vehicleId.trim() === "") {
    throw new HttpsError("invalid-argument", "Missing or invalid vehicleId.");
  }

  const db = admin.firestore();

  // Run everything in a transaction to prevent race conditions
  const txResult = await db.runTransaction(async (transaction) => {
    // Read the vehicle and request documents
    const vehicleRef = db.collection("vehicles").doc(vehicleId);
    const requestRef = db.collection("requests").doc(requestId);

    const vehicleDoc = await transaction.get(vehicleRef);
    if (!vehicleDoc.exists) {
      throw new HttpsError("not-found", "Vehicle not found.");
    }

    const requestDoc = await transaction.get(requestRef);

    const vehicleData = vehicleDoc.exists ? vehicleDoc.data() : null;
    const requestData = requestDoc.exists ? requestDoc.data() : null;

    const result = validateInterest(uid, vehicleId, vehicleData, requestData);

    if (result.alreadyInterested) {
      return { success: true, alreadyInterested: true, customerId: requestData?.customerId };
    }

    // 9. Atomic Update
    const newInterest = {
      ...result.newInterest,
      markedAt: admin.firestore.Timestamp.now()
    };

    const interestedSaathis: any[] = requestData?.interestedSaathis || [];
    const newInterestedSaathis = [...interestedSaathis, newInterest];

    transaction.update(requestRef, {
      interestedSaathis: newInterestedSaathis
    });

    return { success: true, alreadyInterested: false, customerId: requestData?.customerId };
  });

  // Post-transaction non-blocking notification
  if (txResult.success && !txResult.alreadyInterested && txResult.customerId) {
    sendFCM(db, {
      notificationId: `interested_${requestId}_${uid}`,
      targetUids: [txResult.customerId],
      title: "Saathi Interested",
      body: "A Vahan Saathi is interested in your request.",
      data: { requestId, type: "interested" }
    }).catch(e => logger.error("Error triggering interested FCM", e));
  }

  return { success: txResult.success, alreadyInterested: txResult.alreadyInterested };
});
