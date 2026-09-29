import { HttpsError } from "firebase-functions/v2/https";

export const ALLOWED_TAGS = ['Polite', 'On Time', 'Safe Driving', 'Helpful'];

export function validateRating(
  uid: string,
  stars: number,
  tag: string,
  requestData: any | null
): { success: boolean, alreadyRated: boolean, update?: any } {
  
  if (!requestData) {
    throw new HttpsError("not-found", "Request not found.");
  }

  // 1. Request State Validation
  if (requestData.status !== "completed") {
    throw new HttpsError("failed-precondition", "Only completed requests can be rated.");
  }

  // 2. Participant Authorization
  const customerId = requestData.customerId;
  const selectedSaathiId = requestData.selectedSaathiId;

  if (!customerId || !selectedSaathiId) {
    throw new HttpsError("failed-precondition", "Request is missing participant identities.");
  }

  let fromUserId = "";
  let toUserId = "";

  if (uid === customerId) {
    fromUserId = customerId;
    toUserId = selectedSaathiId;
  } else if (uid === selectedSaathiId) {
    fromUserId = selectedSaathiId;
    toUserId = customerId;
  } else {
    throw new HttpsError("permission-denied", "You are not a participant of this request.");
  }

  // 3. Input Validation
  if (typeof stars !== "number" || !Number.isInteger(stars) || stars < 1 || stars > 5) {
    throw new HttpsError("invalid-argument", "Stars must be an integer between 1 and 5.");
  }

  if (typeof tag !== "string") {
    throw new HttpsError("invalid-argument", "Tag must be a string.");
  }

  const trimmedTag = tag.trim();

  if (!ALLOWED_TAGS.includes(trimmedTag)) {
    throw new HttpsError("invalid-argument", "Tag is not in the allowed predefined list.");
  }

  return {
    success: true,
    alreadyRated: false,
    update: {
      fromUserId,
      toUserId,
      stars,
      tag: trimmedTag
      // createdAt and requestId will be set in the cloud function
    }
  };
}
