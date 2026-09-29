import { HttpsError } from "firebase-functions/v2/https";
import { MAX_INTERESTED_SAATHIS } from "../interest";

export function validateInterest(
  uid: string,
  vehicleId: string,
  vehicleData: any | null,
  requestData: any | null
): { success: boolean, alreadyInterested: boolean, newInterest?: any } {
  
  if (!vehicleData) {
    throw new HttpsError("not-found", "Vehicle not found.");
  }

  // 3. Vehicle Ownership Validation
  if (vehicleData.ownerId !== uid) {
    throw new HttpsError("permission-denied", "You do not own this vehicle.");
  }

  // 4. Vehicle Status Validation
  if (vehicleData.status !== "on_duty") {
    throw new HttpsError("failed-precondition", "Vehicle is not on duty.");
  }

  if (!requestData) {
    throw new HttpsError("not-found", "Request not found.");
  }

  // 5. Request Status Validation
  if (requestData.status !== "open") {
    throw new HttpsError("failed-precondition", "Request is no longer open.");
  }

  // 6. Shortlist Validation
  const shortlist: string[] = requestData.shortlistedVehicleIds || [];
  if (!shortlist.includes(vehicleId)) {
    throw new HttpsError("permission-denied", "Vehicle is not shortlisted for this request.");
  }

  // 7. Duplicate / Idempotency check
  const interestedSaathis: any[] = requestData.interestedSaathis || [];
  
  const existingInterest = interestedSaathis.find(
    (interest) => interest.saathiId === uid && interest.vehicleId === vehicleId
  );

  if (existingInterest) {
    return { success: true, alreadyInterested: true };
  }

  // 8. Limit check
  if (interestedSaathis.length >= MAX_INTERESTED_SAATHIS) {
    throw new HttpsError("failed-precondition", "Maximum number of interested Saathis reached.");
  }

  // Success path
  return { 
    success: true, 
    alreadyInterested: false,
    newInterest: { saathiId: uid, vehicleId: vehicleId } 
  };
}
