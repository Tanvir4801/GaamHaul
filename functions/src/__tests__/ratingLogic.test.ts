import { validateRating } from "../utils/ratingLogic";

describe("ratingLogic", () => {
  const customerId = "customer_123";
  const saathiId = "saathi_456";

  const validRequestData = {
    customerId: customerId,
    selectedSaathiId: saathiId,
    status: "completed"
  };

  it("fails if request does not exist", () => {
    expect(() => validateRating(customerId, 5, "Polite", null))
      .toThrow("Request not found.");
  });

  it("fails if request is open", () => {
    expect(() => validateRating(customerId, 5, "Polite", { ...validRequestData, status: "open" }))
      .toThrow("Only completed requests can be rated.");
  });

  it("fails if request is matched", () => {
    expect(() => validateRating(customerId, 5, "Polite", { ...validRequestData, status: "matched" }))
      .toThrow("Only completed requests can be rated.");
  });
  
  it("fails if request is cancelled", () => {
    expect(() => validateRating(customerId, 5, "Polite", { ...validRequestData, status: "cancelled" }))
      .toThrow("Only completed requests can be rated.");
  });

  it("fails if request is in_progress", () => {
    expect(() => validateRating(customerId, 5, "Polite", { ...validRequestData, status: "in_progress" }))
      .toThrow("Only completed requests can be rated.");
  });

  it("fails if customerId is missing", () => {
    expect(() => validateRating(customerId, 5, "Polite", { ...validRequestData, customerId: null }))
      .toThrow("Request is missing participant identities.");
  });

  it("fails if selectedSaathiId is missing", () => {
    expect(() => validateRating(customerId, 5, "Polite", { ...validRequestData, selectedSaathiId: null }))
      .toThrow("Request is missing participant identities.");
  });

  it("fails if caller is an unrelated user", () => {
    expect(() => validateRating("unrelated", 5, "Polite", validRequestData))
      .toThrow("You are not a participant of this request.");
  });

  it("fails if stars are missing/invalid type", () => {
    expect(() => validateRating(customerId, "5" as any, "Polite", validRequestData))
      .toThrow("Stars must be an integer between 1 and 5.");
  });

  it("fails if stars are below 1", () => {
    expect(() => validateRating(customerId, 0, "Polite", validRequestData))
      .toThrow("Stars must be an integer between 1 and 5.");
  });

  it("fails if stars are above 5", () => {
    expect(() => validateRating(customerId, 6, "Polite", validRequestData))
      .toThrow("Stars must be an integer between 1 and 5.");
  });

  it("fails if stars are decimal", () => {
    expect(() => validateRating(customerId, 4.5, "Polite", validRequestData))
      .toThrow("Stars must be an integer between 1 and 5.");
  });

  it("fails if tag is missing", () => {
    expect(() => validateRating(customerId, 5, null as any, validRequestData))
      .toThrow("Tag must be a string.");
  });

  it("fails if tag is empty", () => {
    expect(() => validateRating(customerId, 5, "   ", validRequestData))
      .toThrow("Tag is not in the allowed predefined list.");
  });

  it("fails if tag is invalid", () => {
    expect(() => validateRating(customerId, 5, "Bad Tag", validRequestData))
      .toThrow("Tag is not in the allowed predefined list.");
  });

  it("returns success with correct direction for Customer -> Saathi", () => {
    const result = validateRating(customerId, 5, " Polite ", validRequestData);
    expect(result.success).toBe(true);
    expect(result.update).toEqual({
      fromUserId: customerId,
      toUserId: saathiId,
      stars: 5,
      tag: "Polite"
    });
  });

  it("returns success with correct direction for Saathi -> Customer", () => {
    const result = validateRating(saathiId, 4, "On Time", validRequestData);
    expect(result.success).toBe(true);
    expect(result.update).toEqual({
      fromUserId: saathiId,
      toUserId: customerId,
      stars: 4,
      tag: "On Time"
    });
  });
});
