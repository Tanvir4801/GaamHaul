import { validateInterest } from "../utils/interestLogic";

describe("interestLogic", () => {
  const uid = "saathi_123";
  const vehicleId = "vehicle_123";
  
  const validVehicleData = {
    ownerId: uid,
    status: "on_duty"
  };

  const validRequestData = {
    status: "open",
    shortlistedVehicleIds: [vehicleId],
    interestedSaathis: []
  };

  it("fails if vehicle does not exist", () => {
    expect(() => validateInterest(uid, vehicleId, null, validRequestData))
      .toThrow("Vehicle not found.");
  });

  it("fails if user does not own vehicle", () => {
    expect(() => validateInterest(uid, vehicleId, { ...validVehicleData, ownerId: "other" }, validRequestData))
      .toThrow("You do not own this vehicle.");
  });

  it("fails if vehicle is off_duty", () => {
    expect(() => validateInterest(uid, vehicleId, { ...validVehicleData, status: "off_duty" }, validRequestData))
      .toThrow("Vehicle is not on duty.");
  });

  it("fails if request does not exist", () => {
    expect(() => validateInterest(uid, vehicleId, validVehicleData, null))
      .toThrow("Request not found.");
  });

  it("fails if request is not open (cancelled)", () => {
    expect(() => validateInterest(uid, vehicleId, validVehicleData, { ...validRequestData, status: "cancelled" }))
      .toThrow("Request is no longer open.");
  });

  it("fails if request is not open (matched)", () => {
    expect(() => validateInterest(uid, vehicleId, validVehicleData, { ...validRequestData, status: "matched" }))
      .toThrow("Request is no longer open.");
  });

  it("fails if request is not open (completed)", () => {
    expect(() => validateInterest(uid, vehicleId, validVehicleData, { ...validRequestData, status: "completed" }))
      .toThrow("Request is no longer open.");
  });

  it("fails if vehicle is not shortlisted", () => {
    expect(() => validateInterest(uid, vehicleId, validVehicleData, { ...validRequestData, shortlistedVehicleIds: ["other_veh"] }))
      .toThrow("Vehicle is not shortlisted for this request.");
  });

  it("fails if maximum interested saathis reached", () => {
    const interestedSaathis = Array(10).fill({ saathiId: "other", vehicleId: "other_veh" });
    expect(() => validateInterest(uid, vehicleId, validVehicleData, { ...validRequestData, interestedSaathis }))
      .toThrow("Maximum number of interested Saathis reached.");
  });

  it("returns idempotent success if already interested (same saathiId + vehicleId)", () => {
    const result = validateInterest(uid, vehicleId, validVehicleData, {
      ...validRequestData,
      interestedSaathis: [{ saathiId: uid, vehicleId }]
    });
    expect(result.success).toBe(true);
    expect(result.alreadyInterested).toBe(true);
  });

  it("returns success if same saathi uses a different shortlisted vehicle", () => {
    const result = validateInterest(uid, vehicleId, validVehicleData, {
      ...validRequestData,
      shortlistedVehicleIds: ["other_veh", vehicleId],
      interestedSaathis: [{ saathiId: uid, vehicleId: "other_veh" }]
    });
    expect(result.success).toBe(true);
    expect(result.alreadyInterested).toBe(false);
    expect(result.newInterest).toEqual({ saathiId: uid, vehicleId });
  });

  it("returns success with new interest data when valid", () => {
    const result = validateInterest(uid, vehicleId, validVehicleData, validRequestData);
    expect(result.success).toBe(true);
    expect(result.alreadyInterested).toBe(false);
    expect(result.newInterest).toEqual({ saathiId: uid, vehicleId });
  });
});
