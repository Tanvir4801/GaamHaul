import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { validateRating } from "./utils/ratingLogic";

export const submitRating = onCall(async (request) => {
  // 1. Auth Validation
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated to submit a rating.");
  }
  const uid = request.auth.uid;

  // 2. Input Validation
  const { requestId, stars, tag } = request.data;
  
  if (!requestId || typeof requestId !== "string" || requestId.trim() === "") {
    throw new HttpsError("invalid-argument", "Missing or invalid requestId.");
  }

  const db = admin.firestore();

  // Run everything in a transaction to prevent race conditions
  return await db.runTransaction(async (transaction) => {
    // Read the request document
    const requestRef = db.collection("requests").doc(requestId);
    const requestDoc = await transaction.get(requestRef);
    const requestData = requestDoc.exists ? requestDoc.data() : null;

    const result = validateRating(uid, stars, tag, requestData);

    // Construct deterministic rating ID
    const ratingId = `${requestId}_${result.update.fromUserId}`;
    const ratingRef = db.collection("ratings").doc(ratingId);
    const ratingDoc = await transaction.get(ratingRef);

    if (ratingDoc.exists) {
      // Idempotent retry
      return { 
        success: true, 
        alreadyRated: true,
        requestId
      };
    }

    // 3. Atomic Write
    const newRating = {
      ...result.update,
      requestId,
      createdAt: admin.firestore.Timestamp.now()
    };

    transaction.set(ratingRef, newRating);

    return { 
      success: true, 
      alreadyRated: false,
      requestId
    };
  });
});
