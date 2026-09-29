import { validateSelection } from "../utils/selectionLogic";

describe("selectionLogic", () => {
  const customerId = "customer_123";
  const saathiId = "saathi_456";
  const vehicleId = "vehicle_789";

  const validVehicleData = {
    ownerId: saathiId
  };

  const validRequestData = {
    customerId: customerId,
    status: "open",
    shortlistedVehicleIds: [vehicleId],
    interestedSaathis: [
      { saathiId, vehicleId }
    ],
    selectedSaathiId: null
  };

  it("fails if request does not exist", () => {
    expect(() => validateSelection(customerId, saathiId, vehicleId, null, validVehicleData))
      .toThrow("Request not found.");
  });

  it("fails if customer does not own request", () => {
    expect(() => validateSelection("wrong_customer", saathiId, vehicleId, validRequestData, validVehicleData))
      .toThrow("You do not own this request.");
  });

  it("returns idempotent success if request is already matched to the same saathi", () => {
    const result = validateSelection(customerId, saathiId, vehicleId, {
      ...validRequestData,
      status: "matched",
      selectedSaathiId: saathiId
    }, validVehicleData);
    expect(result.success).toBe(true);
    expect(result.idempotent).toBe(true);
  });

  it("fails if request is already matched to a different saathi (Race Condition protection)", () => {
    expect(() => validateSelection(customerId, saathiId, vehicleId, {
      ...validRequestData,
      status: "matched",
      selectedSaathiId: "other_saathi"
    }, validVehicleData)).toThrow("Request is already matched to a different Saathi.");
  });

  it("fails if request is cancelled", () => {
    expect(() => validateSelection(customerId, saathiId, vehicleId, {
      ...validRequestData,
      status: "cancelled"
    }, validVehicleData)).toThrow("Request is no longer open.");
  });

  it("fails if vehicle is not shortlisted", () => {
    expect(() => validateSelection(customerId, saathiId, vehicleId, {
      ...validRequestData,
      shortlistedVehicleIds: ["other_veh"]
    }, validVehicleData)).toThrow("Selected vehicle is not shortlisted.");
  });

  it("fails if Saathi has not expressed interest", () => {
    expect(() => validateSelection(customerId, saathiId, vehicleId, {
      ...validRequestData,
      interestedSaathis: [] // Empty
    }, validVehicleData)).toThrow("Selected Saathi has not expressed interest.");
  });

  it("fails if Saathi expressed interest with a different vehicle", () => {
    expect(() => validateSelection(customerId, saathiId, vehicleId, {
      ...validRequestData,
      interestedSaathis: [{ saathiId, vehicleId: "other_veh" }]
    }, validVehicleData)).toThrow("Selected Saathi has not expressed interest.");
  });

  it("fails if vehicle does not exist", () => {
    expect(() => validateSelection(customerId, saathiId, vehicleId, validRequestData, null))
      .toThrow("Vehicle not found.");
  });

  it("fails if vehicle belongs to a different saathi", () => {
    expect(() => validateSelection(customerId, saathiId, vehicleId, validRequestData, {
      ownerId: "other_owner"
    })).toThrow("Vehicle does not belong to the selected Saathi.");
  });

  it("returns success and correct update payload when valid", () => {
    const result = validateSelection(customerId, saathiId, vehicleId, validRequestData, validVehicleData);
    expect(result.success).toBe(true);
    expect(result.idempotent).toBe(false);
    expect(result.update).toEqual({
      status: "matched",
      selectedSaathiId: saathiId
    });
  });
});
