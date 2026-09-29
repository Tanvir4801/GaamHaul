import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { validateVerificationMutation } from "./utils/adminVerificationLogic";
import * as logger from "firebase-functions/logger";

async function performVerificationMutation(request: any, targetStatus: "approved" | "rejected") {
  // 1. Auth Validation
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated to perform admin operations.");
  }
  const uid = request.auth.uid;

  // 2. Input Validation
  const { saathiId } = request.data;
  
  const db = admin.firestore();

  // Run in a transaction for safe concurrent access
  return await db.runTransaction(async (transaction) => {
    // Check admin authorization
    const callerRef = db.collection("users").doc(uid);
    const callerDoc = await transaction.get(callerRef);
    const callerRole = callerDoc.exists ? callerDoc.data()?.role : null;

    // Check saathi document
    const saathiRef = db.collection("vahan_saathis").doc(saathiId);
    const saathiDoc = await transaction.get(saathiRef);
    const saathiData = saathiDoc.exists ? saathiDoc.data() : null;

    const result = validateVerificationMutation(callerRole, saathiId, saathiData, targetStatus);

    if (result.idempotent) {
      return {
        success: true,
        saathiId,
        verificationStatus: targetStatus
      };
    }

    // Atomic update ONLY to verificationStatus
    transaction.update(saathiRef, result.update);

    // Audit Logging
    logger.info("Admin Saathi Verification Mutation", {
      action: targetStatus === "approved" ? "approveSaathi" : "rejectSaathi",
      adminUid: uid,
      saathiId: saathiId,
      result: "success"
    });

    return {
      success: true,
      saathiId,
      verificationStatus: targetStatus
    };
  });
}

export const approveSaathi = onCall((request) => performVerificationMutation(request, "approved"));
export const rejectSaathi = onCall((request) => performVerificationMutation(request, "rejected"));
