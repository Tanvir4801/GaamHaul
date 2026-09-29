import { validateCompletion } from "../utils/completionLogic";

describe("completionLogic", () => {
  const customerId = "customer_123";
  const saathiId = "saathi_456";

  const validRequestData = {
    customerId: customerId,
    selectedSaathiId: saathiId,
    status: "matched"
  };

  it("fails if request does not exist", () => {
    expect(() => validateCompletion(customerId, null))
      .toThrow("Request not found.");
  });

  it("fails if caller is neither customer nor selected saathi", () => {
    expect(() => validateCompletion("wrong_user", validRequestData))
      .toThrow("You are not authorized to complete this request.");
  });

  it("returns idempotent success if request is already completed and caller is authorized", () => {
    const result = validateCompletion(customerId, {
      ...validRequestData,
      status: "completed"
    });
    expect(result.success).toBe(true);
    expect(result.alreadyCompleted).toBe(true);
  });

  it("fails if request is open", () => {
    expect(() => validateCompletion(customerId, {
      ...validRequestData,
      status: "open"
    })).toThrow("Only a matched request can be completed.");
  });

  it("fails if request is cancelled", () => {
    expect(() => validateCompletion(customerId, {
      ...validRequestData,
      status: "cancelled"
    })).toThrow("Only a matched request can be completed.");
  });
  
  it("fails if request is in_progress", () => {
    expect(() => validateCompletion(customerId, {
      ...validRequestData,
      status: "in_progress"
    })).toThrow("Only a matched request can be completed.");
  });

  it("fails if selected saathi is empty/missing", () => {
    expect(() => validateCompletion(customerId, {
      ...validRequestData,
      selectedSaathiId: null
    })).toThrow("Cannot complete a request without a selected Saathi.");
  });

  it("returns success and correct update payload when customer completes", () => {
    const result = validateCompletion(customerId, validRequestData);
    expect(result.success).toBe(true);
    expect(result.alreadyCompleted).toBe(false);
    expect(result.update).toEqual({
      status: "completed"
    });
  });

  it("returns success and correct update payload when saathi completes", () => {
    const result = validateCompletion(saathiId, validRequestData);
    expect(result.success).toBe(true);
    expect(result.alreadyCompleted).toBe(false);
    expect(result.update).toEqual({
      status: "completed"
    });
  });
});
