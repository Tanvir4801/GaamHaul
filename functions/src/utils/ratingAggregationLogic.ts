export function calculateAggregateRating(ratings: any[]): { rating_avg: number, rating_count: number } {
  let validCount = 0;
  let totalStars = 0;

  for (const rating of ratings) {
    if (!rating) continue;
    
    const stars = rating.stars;
    
    // Validate stars: must be an integer between 1 and 5
    if (typeof stars === 'number' && Number.isInteger(stars) && stars >= 1 && stars <= 5) {
      validCount++;
      totalStars += stars;
    }
  }

  if (validCount === 0) {
    return { rating_avg: 0, rating_count: 0 };
  }

  const rawAvg = totalStars / validCount;
  const rating_avg = Math.round(rawAvg * 100) / 100;

  return {
    rating_avg,
    rating_count: validCount
  };
}
