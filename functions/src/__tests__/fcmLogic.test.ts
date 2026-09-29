import * as admin from "firebase-admin";
import { sendFCM } from "../utils/fcmLogic";

describe("FCM Logic (Idempotency)", () => {
  let db: admin.firestore.Firestore;

  beforeAll(async () => {
    // Initialize admin app for tests (ensure it connects to emulator)
    if (!admin.apps.length) {
      admin.initializeApp({ projectId: "demo-gaamhaul" });
    }
    db = admin.firestore();
  });

  beforeEach(async () => {
    // Clear notifications
    const docs = await db.collection("notifications").get();
    const batch = db.batch();
    docs.forEach(doc => batch.delete(doc.ref));
    await batch.commit();
  });

  it("should process FCM only once for a given notificationId", async () => {
    const notificationId = "test_notification_123";
    const targetUids = ["user_1"];
    
    const params = {
      notificationId,
      targetUids,
      title: "Test",
      body: "Testing",
      data: { type: "test", requestId: "req1" }
    };

    // First call (should create doc)
    // We mock admin.messaging() here if we were doing deep unit tests, 
    // but the actual idempotency relies on Firestore.
    // In emulator, sendEachForMulticast might throw if not mocked properly, 
    // but we can catch it or rely on the try-catch inside sendFCM.
    
    // Actually, sendFCM has a try/catch, so it won't throw even if messaging fails.
    await sendFCM(db, params);

    // Verify doc created
    const doc = await db.collection("notifications").doc(notificationId).get();
    expect(doc.exists).toBe(true);
    expect(doc.data()?.type).toBe("test");
    expect(doc.data()?.targetUids).toContain("user_1");

    // Second call with same ID
    const initialProcessedAt = doc.data()?.processedAt;
    
    // Wait a tick
    await new Promise(r => setTimeout(r, 10));
    
    await sendFCM(db, params);

    // Verify doc unchanged
    const doc2 = await db.collection("notifications").doc(notificationId).get();
    expect(doc2.data()?.processedAt?.toMillis()).toBe(initialProcessedAt.toMillis());
  });
});
