import { calculateHaversineDistance, MATCHING_MAX_RADIUS_KM, MAX_SHORTLIST_SIZE, MAX_LOCATION_AGE_HOURS } from "./geo";

export interface CandidateVehicle {
  id: string;
  ownerId: string;
  lastKnownLocation?: { latitude: number, longitude: number };
  lastUpdatedAt?: { seconds: number };
}

export function filterAndSortCandidates(
  requestPickupLocation: { latitude: number, longitude: number },
  candidates: CandidateVehicle[],
  verifiedOwnerIds: Set<string>,
  nowSeconds: number
): string[] {
  const validCandidates: CandidateVehicle[] = [];
  const maxAgeSeconds = MAX_LOCATION_AGE_HOURS * 3600;

  for (const vehicle of candidates) {
    if (!vehicle.lastKnownLocation || !vehicle.lastUpdatedAt || !vehicle.ownerId) {
      continue;
    }
    
    const loc = vehicle.lastKnownLocation;
    if (loc.latitude < -90 || loc.latitude > 90 || loc.longitude < -180 || loc.longitude > 180) {
      continue;
    }

    const ageSeconds = nowSeconds - vehicle.lastUpdatedAt.seconds;
    if (ageSeconds > maxAgeSeconds) {
      continue; // Stale location
    }

    if (!verifiedOwnerIds.has(vehicle.ownerId)) {
      continue; // Not approved
    }

    validCandidates.push(vehicle);
  }

  const candidatesWithDistance: { id: string; distance: number }[] = [];
  for (const vehicle of validCandidates) {
    const loc = vehicle.lastKnownLocation!;
    const distance = calculateHaversineDistance(
      requestPickupLocation.latitude, requestPickupLocation.longitude,
      loc.latitude, loc.longitude
    );
    
    if (distance <= MATCHING_MAX_RADIUS_KM) {
      candidatesWithDistance.push({ id: vehicle.id, distance });
    }
  }

  candidatesWithDistance.sort((a, b) => {
    if (a.distance === b.distance) {
      return a.id.localeCompare(b.id);
    }
    return a.distance - b.distance;
  });

  return candidatesWithDistance
    .slice(0, MAX_SHORTLIST_SIZE)
    .map(c => c.id);
}
