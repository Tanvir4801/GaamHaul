import { calculateHaversineDistance, MATCHING_MAX_RADIUS_KM } from "../utils/geo";

describe("geo utils", () => {
  it("calculates distance correctly for same location (0 km)", () => {
    const lat = 23.0;
    const lon = 72.0;
    const distance = calculateHaversineDistance(lat, lon, lat, lon);
    expect(distance).toBe(0);
  });

  it("calculates distance between known coordinates accurately", () => {
    // Delhi (28.7041, 77.1025) to Mumbai (19.0760, 72.8777) is ~1148 km
    const d1 = calculateHaversineDistance(28.7041, 77.1025, 19.0760, 72.8777);
    expect(Math.abs(d1 - 1148)).toBeLessThan(10); // allow slight variance due to Earth's shape approximations
  });

  it("identifies nearby locations within radius", () => {
    // e.g. 1 degree of latitude is ~111 km
    // 0.1 degree is ~11 km
    const distance = calculateHaversineDistance(23.0, 72.0, 23.1, 72.0);
    expect(distance).toBeLessThan(MATCHING_MAX_RADIUS_KM);
    expect(distance).toBeGreaterThan(10);
  });

  it("identifies distant locations outside radius", () => {
    const distance = calculateHaversineDistance(23.0, 72.0, 24.0, 72.0); // ~111 km
    expect(distance).toBeGreaterThan(MATCHING_MAX_RADIUS_KM);
  });
});
