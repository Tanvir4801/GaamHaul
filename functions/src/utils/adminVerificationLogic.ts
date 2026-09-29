import { HttpsError } from "firebase-functions/v2/https";

export function validateVerificationMutation(
  adminRole: string | undefined | null,
  saathiId: string,
  saathiData: any | null,
  targetStatus: "approved" | "rejected"
): { success: boolean, idempotent: boolean, update?: any } {
  
  if (adminRole !== "admin") {
    throw new HttpsError("permission-denied", "Caller is not an authorized Admin.");
  }

  if (!saathiId || typeof saathiId !== "string" || saathiId.trim() === "") {
    throw new HttpsError("invalid-argument", "Missing or invalid saathiId.");
  }

  if (!saathiData) {
    throw new HttpsError("not-found", "Saathi document not found.");
  }

  const currentStatus = saathiData.verificationStatus;

  // Idempotency checks
  if (targetStatus === "approved" && currentStatus === "approved") {
    return { success: true, idempotent: true };
  }

  if (targetStatus === "rejected" && currentStatus === "rejected") {
    return { success: true, idempotent: true };
  }

  // Allow transitions from pending to approved/rejected.
  // The requirements also allow re-review if needed, but explicitly specify that 
  // approved->approved and rejected->rejected are idempotent.
  // The instructions explicitly say: "Do NOT automatically move approved -> pending unless requirements support it."
  // We will allow transitions from rejected to approved, or approved to rejected in case Admin made a mistake,
  // but the core is that it modifies ONLY the verificationStatus.

  return {
    success: true,
    idempotent: false,
    update: {
      verificationStatus: targetStatus
    }
  };
}
