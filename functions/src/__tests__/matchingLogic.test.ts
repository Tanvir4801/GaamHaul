import { filterAndSortCandidates, CandidateVehicle } from "../utils/matchingLogic";

describe("matchingLogic", () => {
  const pickup = { latitude: 23.0, longitude: 72.0 };
  const now = 100000;
  const verifiedOwnerIds = new Set(["owner1", "owner2", "owner3"]);

  it("filters out stale locations", () => {
    const candidates: CandidateVehicle[] = [
      {
        id: "veh1",
        ownerId: "owner1",
        lastKnownLocation: { latitude: 23.01, longitude: 72.01 },
        lastUpdatedAt: { seconds: now - 100 } // fresh
      },
      {
        id: "veh2",
        ownerId: "owner1",
        lastKnownLocation: { latitude: 23.01, longitude: 72.01 },
        lastUpdatedAt: { seconds: now - 4 * 3600 } // stale (> 3 hours)
      }
    ];

    const shortlist = filterAndSortCandidates(pickup, candidates, verifiedOwnerIds, now);
    expect(shortlist).toEqual(["veh1"]);
  });

  it("filters out unverified saathi vehicles", () => {
    const candidates: CandidateVehicle[] = [
      {
        id: "veh1",
        ownerId: "unverified_owner",
        lastKnownLocation: { latitude: 23.01, longitude: 72.01 },
        lastUpdatedAt: { seconds: now - 100 }
      }
    ];

    const shortlist = filterAndSortCandidates(pickup, candidates, verifiedOwnerIds, now);
    expect(shortlist).toEqual([]);
  });

  it("filters out vehicles missing location or timestamp", () => {
    const candidates: CandidateVehicle[] = [
      {
        id: "veh1",
        ownerId: "owner1",
        // missing location
        lastUpdatedAt: { seconds: now - 100 }
      },
      {
        id: "veh2",
        ownerId: "owner1",
        lastKnownLocation: { latitude: 23.01, longitude: 72.01 },
        // missing timestamp
      }
    ];

    const shortlist = filterAndSortCandidates(pickup, candidates, verifiedOwnerIds, now);
    expect(shortlist).toEqual([]);
  });

  it("sorts by closest distance and breaks ties by vehicle id", () => {
    const candidates: CandidateVehicle[] = [
      {
        id: "veh_far",
        ownerId: "owner1",
        lastKnownLocation: { latitude: 23.2, longitude: 72.2 }, // further
        lastUpdatedAt: { seconds: now - 100 }
      },
      {
        id: "veh_close2",
        ownerId: "owner2",
        lastKnownLocation: { latitude: 23.01, longitude: 72.01 }, // close
        lastUpdatedAt: { seconds: now - 100 }
      },
      {
        id: "veh_close1", // Should be before close2 because of id tiebreaker
        ownerId: "owner3",
        lastKnownLocation: { latitude: 23.01, longitude: 72.01 }, // same close distance
        lastUpdatedAt: { seconds: now - 100 }
      }
    ];

    const shortlist = filterAndSortCandidates(pickup, candidates, verifiedOwnerIds, now);
    expect(shortlist).toEqual(["veh_close1", "veh_close2", "veh_far"]);
  });

  it("limits shortlist to 10 vehicles", () => {
    const candidates: CandidateVehicle[] = [];
    for (let i = 0; i < 15; i++) {
      candidates.push({
        id: `veh_${i.toString().padStart(2, '0')}`,
        ownerId: "owner1",
        lastKnownLocation: { latitude: 23.01, longitude: 72.01 },
        lastUpdatedAt: { seconds: now - 100 }
      });
    }

    const shortlist = filterAndSortCandidates(pickup, candidates, verifiedOwnerIds, now);
    expect(shortlist.length).toBe(10);
    // Since IDs are padded 00, 01, 02... they will sort alphanumerically correctly
    expect(shortlist[0]).toBe("veh_00");
    expect(shortlist[9]).toBe("veh_09");
  });
});
