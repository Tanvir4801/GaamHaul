import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import { validateSelection } from "./utils/selectionLogic";
import { sendFCM } from "./utils/fcmLogic";

export const selectSaathi = onCall(async (request) => {
  // 1. Auth Validation
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated to select a Saathi.");
  }
  const customerId = request.auth.uid;

  // 2. Input Validation
  const { requestId, saathiId, vehicleId } = request.data;
  
  if (!requestId || typeof requestId !== "string" || requestId.trim() === "") {
    throw new HttpsError("invalid-argument", "Missing or invalid requestId.");
  }
  if (!saathiId || typeof saathiId !== "string" || saathiId.trim() === "") {
    throw new HttpsError("invalid-argument", "Missing or invalid saathiId.");
  }
  if (!vehicleId || typeof vehicleId !== "string" || vehicleId.trim() === "") {
    throw new HttpsError("invalid-argument", "Missing or invalid vehicleId.");
  }

  const db = admin.firestore();

  // Run everything in a transaction to prevent race conditions
  const result = await db.runTransaction(async (transaction) => {
    // Read the request and vehicle documents
    const requestRef = db.collection("requests").doc(requestId);
    const vehicleRef = db.collection("vehicles").doc(vehicleId);

    const requestDoc = await transaction.get(requestRef);
    const vehicleDoc = await transaction.get(vehicleRef);

    const requestData = requestDoc.exists ? requestDoc.data() : null;
    const vehicleData = vehicleDoc.exists ? vehicleDoc.data() : null;

    const validationResult = validateSelection(customerId, saathiId, vehicleId, requestData, vehicleData);

    if (validationResult.idempotent) {
      return { 
        success: true, 
        requestId,
        selectedSaathiId: saathiId,
        status: "matched",
        idempotent: true
      };
    }

    // 3. Atomic Update
    const updatePayload = {
      ...validationResult.update,
      matchedAt: admin.firestore.Timestamp.now()
    };

    transaction.update(requestRef, updatePayload);

    return { 
      success: true, 
      requestId,
      selectedSaathiId: saathiId,
      status: "matched",
      idempotent: false
    };
  });

  // 4. Notifications
  if (result.success && !result.idempotent) {
    sendFCM(db, {
      notificationId: `selected_${requestId}_${saathiId}`,
      targetUids: [saathiId],
      title: "Job Selected",
      body: "You have been selected for a vehicle request.",
      data: { requestId, type: "selected" }
    }).catch(e => logger.error("Error triggering selected FCM", e));
  }

  return {
    success: result.success,
    requestId: result.requestId,
    selectedSaathiId: result.selectedSaathiId,
    status: result.status
  };
});
