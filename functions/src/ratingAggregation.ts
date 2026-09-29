import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";
import { calculateAggregateRating } from "./utils/ratingAggregationLogic";
import * as logger from "firebase-functions/logger";

export const onRatingCreated = onDocumentCreated("ratings/{ratingId}", async (event) => {
  const snapshot = event.data;
  if (!snapshot) return;

  const ratingData = snapshot.data();
  const toUserId = ratingData.toUserId;

  if (!toUserId || typeof toUserId !== "string" || toUserId.trim() === "") {
    logger.error("Rating created with missing or invalid toUserId", {
      ratingId: event.params.ratingId,
      error_type: "invalid_toUserId"
    });
    return;
  }

  const db = admin.firestore();

  // Run everything in a transaction to ensure we only update existing saathi profiles
  // and handle potential concurrent rating creations safely.
  await db.runTransaction(async (transaction) => {
    const saathiRef = db.collection("vahan_saathis").doc(toUserId);
    const saathiDoc = await transaction.get(saathiRef);

    if (!saathiDoc.exists) {
      logger.error("Rating targeted a non-existent Saathi profile", {
        ratingId: event.params.ratingId,
        toUserId,
        error_type: "missing_saathi_profile"
      });
      // Do not invent a profile. Abort cleanly.
      return;
    }

    // Query all ratings targeting this Saathi
    // Since queries within transactions require all reads before writes, we execute the query here.
    // Note: In Firestore, it's generally safe to run queries in a transaction if you are reading a separate collection.
    const ratingsQuery = db.collection("ratings").where("toUserId", "==", toUserId);
    const ratingsSnapshot = await transaction.get(ratingsQuery);
    
    const allRatings = ratingsSnapshot.docs.map(doc => doc.data());

    // Compute the new aggregate statidstics idempotently based purely on the ratings collection
    const { rating_avg, rating_count } = calculateAggregateRating(allRatings);

    // Update ONLY the aggregate fields
    transaction.update(saathiRef, {
      rating_avg,
      rating_count
    });
  });
});
