import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import { validateCompletion } from "./utils/completionLogic";
import { sendFCM } from "./utils/fcmLogic";

export const markJobCompleted = onCall(async (request) => {
  // 1. Auth Validation
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated to complete a request.");
  }
  const uid = request.auth.uid;

  // 2. Input Validation
  const { requestId } = request.data;
  
  if (!requestId || typeof requestId !== "string" || requestId.trim() === "") {
    throw new HttpsError("invalid-argument", "Missing or invalid requestId.");
  }

  const db = admin.firestore();

  // Run everything in a transaction to prevent race conditions
  const result = await db.runTransaction(async (transaction) => {
    // Read the request document
    const requestRef = db.collection("requests").doc(requestId);
    const requestDoc = await transaction.get(requestRef);
    const requestData = requestDoc.exists ? requestDoc.data() : null;

    const validationResult = validateCompletion(uid, requestData);

    if (validationResult.alreadyCompleted) {
      return { 
        success: true, 
        alreadyCompleted: true,
        requestId,
        status: "completed"
      };
    }

    // 3. Atomic Update
    const updatePayload = {
      ...validationResult.update,
      completedAt: admin.firestore.Timestamp.now()
    };

    transaction.update(requestRef, updatePayload);

    // Identify other participant
    const otherParticipantId = uid === requestData?.customerId ? requestData?.selectedSaathiId : requestData?.customerId;

    return { 
      success: true, 
      alreadyCompleted: false,
      requestId,
      status: "completed",
      otherParticipantId
    };
  });

  // 4. Notifications
  if (result.success && !result.alreadyCompleted && result.otherParticipantId) {
    sendFCM(db, {
      notificationId: `completed_${requestId}_${result.otherParticipantId}`,
      targetUids: [result.otherParticipantId],
      title: "Job Completed",
      body: "Your GaamHaul job has been completed.",
      data: { requestId, type: "completed" }
    }).catch(e => logger.error("Error triggering completed FCM", e));
  }

  return {
    success: result.success,
    alreadyCompleted: result.alreadyCompleted,
    requestId: result.requestId,
    status: result.status
  };
});
