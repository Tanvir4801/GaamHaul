import { HttpsError } from "firebase-functions/v2/https";

export function validateSelection(
  customerId: string,
  saathiId: string,
  vehicleId: string,
  requestData: any | null,
  vehicleData: any | null
): { success: boolean, idempotent: boolean, update?: any } {
  
  if (!requestData) {
    throw new HttpsError("not-found", "Request not found.");
  }

  // 1. Request Ownership Validation
  if (requestData.customerId !== customerId) {
    throw new HttpsError("permission-denied", "You do not own this request.");
  }

  // 2. Request State Validation and Idempotency Check
  if (requestData.status === "matched") {
    if (requestData.selectedSaathiId === saathiId) {
      // Idempotent retry
      return { success: true, idempotent: true };
    } else {
      throw new HttpsError("failed-precondition", "Request is already matched to a different Saathi.");
    }
  }

  if (requestData.status !== "open") {
    throw new HttpsError("failed-precondition", "Request is no longer open.");
  }

  // 3. Shortlist Validation
  const shortlist: string[] = requestData.shortlistedVehicleIds || [];
  if (!shortlist.includes(vehicleId)) {
    throw new HttpsError("failed-precondition", "Selected vehicle is not shortlisted.");
  }

  // 4. Interest Validation
  const interestedSaathis: any[] = requestData.interestedSaathis || [];
  const hasInterest = interestedSaathis.some(
    (interest) => interest.saathiId === saathiId && interest.vehicleId === vehicleId
  );
  if (!hasInterest) {
    throw new HttpsError("failed-precondition", "Selected Saathi has not expressed interest.");
  }

  if (!vehicleData) {
    throw new HttpsError("not-found", "Vehicle not found.");
  }

  // 5. Vehicle Ownership Validation
  if (vehicleData.ownerId !== saathiId) {
    throw new HttpsError("permission-denied", "Vehicle does not belong to the selected Saathi.");
  }

  return {
    success: true,
    idempotent: false,
    update: {
      status: "matched",
      selectedSaathiId: saathiId
      // matchedAt will be set in the cloud function using admin.firestore.Timestamp.now()
    }
  };
}
