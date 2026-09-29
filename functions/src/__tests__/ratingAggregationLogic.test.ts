import { calculateAggregateRating } from "../utils/ratingAggregationLogic";

describe("ratingAggregationLogic", () => {

  it("handles empty ratings", () => {
    const result = calculateAggregateRating([]);
    expect(result.rating_count).toBe(0);
    expect(result.rating_avg).toBe(0);
  });

  it("handles one valid rating", () => {
    const result = calculateAggregateRating([{ stars: 5 }]);
    expect(result.rating_count).toBe(1);
    expect(result.rating_avg).toBe(5);
  });

  it("handles multiple valid ratings", () => {
    const result = calculateAggregateRating([{ stars: 5 }, { stars: 4 }, { stars: 3 }]);
    expect(result.rating_count).toBe(3);
    expect(result.rating_avg).toBe(4);
  });

  it("handles decimal average and rounds to 2 decimal places", () => {
    const result = calculateAggregateRating([{ stars: 5 }, { stars: 5 }, { stars: 4 }]);
    expect(result.rating_count).toBe(3);
    expect(result.rating_avg).toBe(4.67);
  });

  it("handles all valid integer star values 1 to 5", () => {
    const result = calculateAggregateRating([
      { stars: 1 }, 
      { stars: 2 }, 
      { stars: 3 }, 
      { stars: 4 }, 
      { stars: 5 }
    ]);
    expect(result.rating_count).toBe(5);
    expect(result.rating_avg).toBe(3); // 15 / 5
  });

  it("ignores invalid ratings (below 1)", () => {
    const result = calculateAggregateRating([{ stars: 5 }, { stars: 0 }, { stars: -2 }]);
    expect(result.rating_count).toBe(1);
    expect(result.rating_avg).toBe(5);
  });

  it("ignores invalid ratings (above 5)", () => {
    const result = calculateAggregateRating([{ stars: 4 }, { stars: 6 }, { stars: 10 }]);
    expect(result.rating_count).toBe(1);
    expect(result.rating_avg).toBe(4);
  });

  it("ignores invalid ratings (decimal stars)", () => {
    const result = calculateAggregateRating([{ stars: 4 }, { stars: 4.5 }]);
    expect(result.rating_count).toBe(1);
    expect(result.rating_avg).toBe(4);
  });

  it("ignores invalid ratings (missing/wrong type stars)", () => {
    const result = calculateAggregateRating([
      { stars: 3 }, 
      { stars: "5" }, 
      { no_stars: true },
      null,
      undefined
    ]);
    expect(result.rating_count).toBe(1);
    expect(result.rating_avg).toBe(3);
  });

  it("is idempotent for event retries (calculates exact same result for same set)", () => {
    const ratings = [{ stars: 4 }, { stars: 5 }];
    const firstRun = calculateAggregateRating(ratings);
    const secondRun = calculateAggregateRating(ratings);
    expect(firstRun).toEqual(secondRun);
  });
});
