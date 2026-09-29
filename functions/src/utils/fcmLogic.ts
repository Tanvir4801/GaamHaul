import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

interface FCMParams {
  notificationId: string;
  targetUids: string[];
  title: string;
  body: string;
  data: Record<string, string>;
}

/**
 * Sends FCM notifications idempotently.
 * Uses `notifications/{notificationId}` to prevent duplicate pushes.
 */
export async function sendFCM(db: admin.firestore.Firestore, params: FCMParams): Promise<void> {
  if (params.targetUids.length === 0) return;

  const notificationRef = db.collection("notifications").doc(params.notificationId);

  try {
    // 1. Idempotency Check
    const alreadyProcessed = await db.runTransaction(async (transaction) => {
      const doc = await transaction.get(notificationRef);
      if (doc.exists) {
        return true;
      }
      // Mark as processing/processed
      transaction.set(notificationRef, {
        processedAt: admin.firestore.FieldValue.serverTimestamp(),
        targetUids: params.targetUids,
        type: params.data.type || "unknown",
        requestId: params.data.requestId || "unknown"
      });
      return false;
    });

    if (alreadyProcessed) {
      logger.info(`Notification ${params.notificationId} already processed. Skipping.`);
      return;
    }

    // 2. Fetch Device Tokens
    const tokens: string[] = [];
    const tokenToDocPath: Record<string, string> = {};

    // Note: If targetUids is very large, this would need batching.
    // In GaamHaul, targetUids are small (1 customer, or ~5-10 shortlisted Saathis).
    for (const uid of params.targetUids) {
      const devicesSnapshot = await db.collection("users").doc(uid).collection("devices").where("enabled", "==", true).get();
      devicesSnapshot.forEach(doc => {
        const token = doc.data().token;
        if (token) {
          tokens.push(token);
          tokenToDocPath[token] = doc.ref.path;
        }
      });
    }

    if (tokens.length === 0) {
      logger.info(`No active devices found for notification ${params.notificationId}`);
      return;
    }

    // 3. Send Multicast Message
    const message: admin.messaging.MulticastMessage = {
      tokens,
      notification: {
        title: params.title,
        body: params.body,
      },
      data: params.data,
      android: {
        priority: "high"
      },
      apns: {
        payload: {
          aps: {
            contentAvailable: true,
          }
        }
      }
    };

    const response = await admin.messaging().sendEachForMulticast(message);
    
    logger.info(`FCM ${params.notificationId}: ${response.successCount} successes, ${response.failureCount} failures.`);

    // 4. Cleanup Invalid Tokens
    if (response.failureCount > 0) {
      const failedTokens: string[] = [];
      response.responses.forEach((resp, idx) => {
        if (!resp.success) {
          const errCode = resp.error?.code;
          if (
            errCode === "messaging/invalid-registration-token" ||
            errCode === "messaging/registration-token-not-registered"
          ) {
            failedTokens.push(tokens[idx]);
          }
        }
      });

      if (failedTokens.length > 0) {
        const batch = db.batch();
        failedTokens.forEach(token => {
          const docPath = tokenToDocPath[token];
          if (docPath) {
            batch.delete(db.doc(docPath));
          }
        });
        await batch.commit();
        logger.info(`Deleted ${failedTokens.length} invalid FCM tokens.`);
      }
    }

  } catch (error) {
    logger.error(`Error sending FCM for ${params.notificationId}:`, error);
    // We intentionally do not throw here so the core business transaction does not fail
    // if it awaits this function, though normally this is called without awaiting.
  }
}
