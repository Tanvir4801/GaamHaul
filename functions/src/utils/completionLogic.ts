import { HttpsError } from "firebase-functions/v2/https";

export function validateCompletion(
  uid: string,
  requestData: any | null
): { success: boolean, alreadyCompleted: boolean, update?: any } {
  
  if (!requestData) {
    throw new HttpsError("not-found", "Request not found.");
  }

  // 1. Authorization
  const isCustomer = requestData.customerId === uid;
  const isSelectedSaathi = requestData.selectedSaathiId === uid;

  if (!isCustomer && !isSelectedSaathi) {
    throw new HttpsError("permission-denied", "You are not authorized to complete this request.");
  }

  // 2. Request State Validation and Idempotency Check
  if (requestData.status === "completed") {
    // Idempotent retry since authorization passed
    return { success: true, alreadyCompleted: true };
  }

  if (requestData.status !== "matched") {
    throw new HttpsError("failed-precondition", "Only a matched request can be completed.");
  }

  // 3. Selected Saathi Validation
  if (!requestData.selectedSaathiId || requestData.selectedSaathiId.trim() === "") {
    throw new HttpsError("failed-precondition", "Cannot complete a request without a selected Saathi.");
  }

  return {
    success: true,
    alreadyCompleted: false,
    update: {
      status: "completed"
      // completedAt will be set in the cloud function using admin.firestore.Timestamp.now()
    }
  };
}
