import { readFileSync } from "fs";
import { resolve } from "path";
import {
  initializeTestEnvironment,
  RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import { setLogLevel } from "firebase/firestore";

let testEnv: RulesTestEnvironment;

beforeAll(async () => {
  // Silence expected security error logs during testing
  setLogLevel("error");
  
  testEnv = await initializeTestEnvironment({
    projectId: "gaamhaul-test",
    firestore: {
      rules: readFileSync(resolve(__dirname, "../../../firestore.rules"), "utf8"),
    },
  });
});

beforeEach(async () => {
  await testEnv.clearFirestore();
});

afterAll(async () => {
  await testEnv.cleanup();
});

describe("GaamHaul Firestore Security Rules", () => {
  
  const setupBaseData = async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      const db = context.firestore();
      
      await db.collection("users").doc("admin_user").set({ role: "admin", banned: false });
      
      await db.collection("users").doc("saathi_A").set({ role: "vahan_saathi", banned: false });
      await db.collection("users").doc("saathi_B").set({ role: "vahan_saathi", banned: false });
      await db.collection("users").doc("malicious_saathi").set({ role: "vahan_saathi", banned: false });
      
      await db.collection("users").doc("customer_1").set({ role: "customer", banned: false });
      await db.collection("users").doc("customer_B").set({ role: "customer", banned: false });

      await db.collection("requests").doc("req1").set({
        customerId: "customer_1",
        status: "open",
        shortlistedVehicleIds: ["vehicleA"],
        shortlistedSaathiIds: ["saathi_A"],
        interestedSaathis: [],
      });
    });
  };

  describe("Saathi Request Access (MANDATORY TEST)", () => {
    beforeEach(async () => {
      await setupBaseData();
    });

    it("Saathi A is shortlisted and CAN read request R", async () => {
      const db = testEnv.authenticatedContext("saathi_A").firestore();
      const doc = db.collection("requests").doc("req1");
      await expect(doc.get()).resolves.toBeDefined();
    });

    it("Saathi B is NOT shortlisted and CANNOT read request R", async () => {
      const db = testEnv.authenticatedContext("saathi_B").firestore();
      const doc = db.collection("requests").doc("req1");
      await expect(doc.get()).rejects.toThrow();
    });

    it("Malicious Saathi tries to read despite knowing ID, CANNOT read request R", async () => {
      const db = testEnv.authenticatedContext("malicious_saathi").firestore();
      const doc = db.collection("requests").doc("req1");
      await expect(doc.get()).rejects.toThrow();
    });

    it("Customer B is NOT the owner and CANNOT read request R", async () => {
      const db = testEnv.authenticatedContext("customer_B").firestore();
      const doc = db.collection("requests").doc("req1");
      await expect(doc.get()).rejects.toThrow();
    });

    it("Customer 1 is the owner and CAN read own request R", async () => {
      const db = testEnv.authenticatedContext("customer_1").firestore();
      const doc = db.collection("requests").doc("req1");
      await expect(doc.get()).resolves.toBeDefined();
    });
  });

  describe("Client Attempts to Modify Protected Request Fields", () => {
    beforeEach(async () => {
      await setupBaseData();
    });

    const maliciousFields = [
      { shortlistedVehicleIds: ["vehicleA", "myVehicle"] },
      { shortlistedSaathiIds: ["saathi_A", "malicious_saathi"] },
      { selectedSaathiId: "malicious_saathi" },
      { interestedSaathis: ["malicious_saathi"] },
      { finalPrice: 5000 },
      { matchedAt: new Date() },
      { completedAt: new Date() },
      { status: "completed" },
    ];

    maliciousFields.forEach((field) => {
      it(`Customer CANNOT modify ${Object.keys(field)[0]}`, async () => {
        const db = testEnv.authenticatedContext("customer_1").firestore();
        const doc = db.collection("requests").doc("req1");
        await expect(doc.update(field)).rejects.toThrow();
      });

      it(`Saathi CANNOT modify ${Object.keys(field)[0]}`, async () => {
        const db = testEnv.authenticatedContext("saathi_A").firestore();
        const doc = db.collection("requests").doc("req1");
        await expect(doc.update(field)).rejects.toThrow();
      });
    });
  });

  describe("Query Test (MANDATORY TEST)", () => {
    beforeEach(async () => {
      await setupBaseData();
    });

    it("Production query with arrayContains: current_uid succeeds for shortlisted Saathi", async () => {
      const db = testEnv.authenticatedContext("saathi_A").firestore();
      const q = db.collection("requests")
                  .where("shortlistedSaathiIds", "array-contains", "saathi_A");
      
      const snap = await q.get();
      expect(snap.empty).toBe(false);
      expect(snap.docs[0].id).toBe("req1");
    });

    it("Production query for unshortlisted Saathi returns empty successfully", async () => {
      const db = testEnv.authenticatedContext("saathi_B").firestore();
      const q = db.collection("requests")
                  .where("shortlistedSaathiIds", "array-contains", "saathi_B");
      
      const snap = await q.get();
      expect(snap.empty).toBe(true);
    });
  });

  describe("User Profiles", () => {
    it("User CANNOT modify their own role to admin", async () => {
      await testEnv.withSecurityRulesDisabled(async (context) => {
         await context.firestore().collection("users").doc("user_X").set({ role: "customer" });
      });
      const db = testEnv.authenticatedContext("user_X").firestore();
      const doc = db.collection("users").doc("user_X");
      await expect(doc.update({ role: "admin" })).rejects.toThrow();
    });
    
    it("User CANNOT modify banned status", async () => {
      await testEnv.withSecurityRulesDisabled(async (context) => {
         await context.firestore().collection("users").doc("user_X").set({ role: "customer", banned: true });
      });
      const db = testEnv.authenticatedContext("user_X").firestore();
      const doc = db.collection("users").doc("user_X");
      await expect(doc.update({ banned: false })).rejects.toThrow();
    });
  });

  describe("Vahan Saathi Profile", () => {
    beforeEach(async () => {
      await setupBaseData();
    });

    it("Saathi CANNOT modify rating_avg", async () => {
      await testEnv.withSecurityRulesDisabled(async (context) => {
         await context.firestore().collection("vahan_saathis").doc("saathi_A").set({ verificationStatus: "approved", rating_avg: 4.5 });
      });
      const db = testEnv.authenticatedContext("saathi_A").firestore();
      const doc = db.collection("vahan_saathis").doc("saathi_A");
      await expect(doc.update({ rating_avg: 5.0 })).rejects.toThrow();
    });

    it("Saathi CANNOT modify verificationStatus", async () => {
      await testEnv.withSecurityRulesDisabled(async (context) => {
         await context.firestore().collection("vahan_saathis").doc("saathi_A").set({ verificationStatus: "pending" });
      });
      const db = testEnv.authenticatedContext("saathi_A").firestore();
      const doc = db.collection("vahan_saathis").doc("saathi_A");
      await expect(doc.update({ verificationStatus: "approved" })).rejects.toThrow();
    });
  });

  describe("Vehicles", () => {
    it("Cannot change vehicle ownerId", async () => {
      await testEnv.withSecurityRulesDisabled(async (context) => {
         await context.firestore().collection("vehicles").doc("veh1").set({ ownerId: "saathi_A", type: "Pickup", status: "on_duty" });
      });
      const db = testEnv.authenticatedContext("saathi_A").firestore();
      const doc = db.collection("vehicles").doc("veh1");
      await expect(doc.update({ ownerId: "malicious_saathi" })).rejects.toThrow();
    });

    it("Cannot create vehicle for another owner", async () => {
      const db = testEnv.authenticatedContext("malicious_saathi").firestore();
      const doc = db.collection("vehicles").doc("veh2");
      await expect(doc.set({ ownerId: "saathi_A", type: "Pickup", status: "on_duty" })).rejects.toThrow();
    });
  });

  describe("Ratings", () => {
    it("Client CANNOT create a rating directly", async () => {
      const db = testEnv.authenticatedContext("customer_1").firestore();
      const doc = db.collection("ratings").doc("rating1");
      await expect(doc.set({ fromUserId: "customer_1", toUserId: "saathi_A", stars: 5 })).rejects.toThrow();
    });
  });

});
