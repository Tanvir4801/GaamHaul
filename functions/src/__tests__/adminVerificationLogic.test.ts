import { validateVerificationMutation } from "../utils/adminVerificationLogic";

describe("adminVerificationLogic", () => {

  const validSaathiId = "saathi_123";
  const validSaathiData = {
    verificationStatus: "pending",
    rating_avg: 4.5,
    rating_count: 10
  };

  it("fails if caller is not an admin", () => {
    expect(() => validateVerificationMutation("user", validSaathiId, validSaathiData, "approved"))
      .toThrow("Caller is not an authorized Admin.");
    
    expect(() => validateVerificationMutation(null, validSaathiId, validSaathiData, "approved"))
      .toThrow("Caller is not an authorized Admin.");
  });

  it("fails if saathiId is missing or empty", () => {
    expect(() => validateVerificationMutation("admin", "", validSaathiData, "approved"))
      .toThrow("Missing or invalid saathiId.");
      
    expect(() => validateVerificationMutation("admin", null as any, validSaathiData, "approved"))
      .toThrow("Missing or invalid saathiId.");
  });

  it("fails if saathi document does not exist", () => {
    expect(() => validateVerificationMutation("admin", validSaathiId, null, "approved"))
      .toThrow("Saathi document not found.");
  });

  it("returns idempotent success if already approved and target is approved", () => {
    const result = validateVerificationMutation(
      "admin", 
      validSaathiId, 
      { ...validSaathiData, verificationStatus: "approved" }, 
      "approved"
    );
    expect(result.success).toBe(true);
    expect(result.idempotent).toBe(true);
    expect(result.update).toBeUndefined();
  });

  it("returns idempotent success if already rejected and target is rejected", () => {
    const result = validateVerificationMutation(
      "admin", 
      validSaathiId, 
      { ...validSaathiData, verificationStatus: "rejected" }, 
      "rejected"
    );
    expect(result.success).toBe(true);
    expect(result.idempotent).toBe(true);
    expect(result.update).toBeUndefined();
  });

  it("returns successful update for pending -> approved", () => {
    const result = validateVerificationMutation("admin", validSaathiId, validSaathiData, "approved");
    expect(result.success).toBe(true);
    expect(result.idempotent).toBe(false);
    expect(result.update).toEqual({ verificationStatus: "approved" });
  });

  it("returns successful update for pending -> rejected", () => {
    const result = validateVerificationMutation("admin", validSaathiId, validSaathiData, "rejected");
    expect(result.success).toBe(true);
    expect(result.idempotent).toBe(false);
    expect(result.update).toEqual({ verificationStatus: "rejected" });
  });

});
