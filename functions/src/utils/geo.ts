export const MAX_SHORTLIST_SIZE = 10;
export const MATCHING_MAX_RADIUS_KM = 50;
export const MAX_LOCATION_AGE_HOURS = 3;

/**
 * Calculates the Haversine distance between two coordinates in kilometers.
 */
export function calculateHaversineDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const toRadian = (angle: number) => (Math.PI / 180) * angle;
  
  const R = 6371; // Earth radius in km
  
  const dLat = toRadian(lat2 - lat1);
  const dLon = toRadian(lon2 - lon1);
  
  const a = 
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRadian(lat1)) * Math.cos(toRadian(lat2)) * 
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
    
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  
  return R * c;
}
