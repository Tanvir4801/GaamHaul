import React, { useEffect, useState } from "react";
import { collection, getDocs, query, where, documentId } from "firebase/firestore";
import { db } from "../../lib/firebase";
import { Link } from "react-router-dom";
import { Eye } from "lucide-react";
import clsx from "clsx";


interface UserProfile {
  id: string;
  name: string;
  phone: string;
  village: string;
  taluka: string;
}

interface SaathiCombined {
  id: string;
  verificationStatus: string;
  vehicleCount: number;
  name: string;
  phone: string;
  village: string;
  taluka: string;
}

export const SaathiListScreen: React.FC = () => {
  const [saathis, setSaathis] = useState<SaathiCombined[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [filter, setFilter] = useState<string>("all");

  useEffect(() => {
    const fetchSaathis = async () => {
      setLoading(true);
      setError(null);
      
      try {
        // Fetch Vahan Saathi profiles
        let saathisQuery = collection(db, "vahan_saathis");
        const saathisSnapshot = await getDocs(saathisQuery);
        
        if (saathisSnapshot.empty) {
          setSaathis([]);
          setLoading(false);
          return;
        }

        const saathiProfiles = saathisSnapshot.docs.map(doc => ({
          id: doc.id,
          verificationStatus: doc.data().verificationStatus || "pending",
          vehicles: doc.data().vehicles || [],
        }));

        // Fetch corresponding user profiles to get name/village/taluka
        const saathiIds = saathiProfiles.map(s => s.id);
        
        // Firestore 'in' query supports up to 10 items.
        // For MVP we chunk them safely if > 10, or just do one by one if not too many.
        // Doing naive chunking:
        const userProfiles: UserProfile[] = [];
        
        for (let i = 0; i < saathiIds.length; i += 10) {
          const chunk = saathiIds.slice(i, i + 10);
          const usersQuery = query(collection(db, "users"), where(documentId(), "in", chunk));
          const usersSnapshot = await getDocs(usersQuery);
          
          usersSnapshot.forEach(doc => {
            const data = doc.data();
            userProfiles.push({
              id: doc.id,
              name: data.name || "Unknown",
              phone: data.phone || "Unknown",
              village: data.village || "Unknown",
              taluka: data.taluka || "Unknown",
            });
          });
        }

        // Combine
        const combined = saathiProfiles.map(s => {
          const u = userProfiles.find(user => user.id === s.id);
          return {
            id: s.id,
            verificationStatus: s.verificationStatus,
            vehicleCount: s.vehicles.length,
            name: u?.name || "Unknown",
            phone: u?.phone || "Unknown",
            village: u?.village || "Unknown",
            taluka: u?.taluka || "Unknown",
          };
        });

        setSaathis(combined);
      } catch (err: any) {
        console.error("Failed to fetch Saathis:", err);
        setError("Failed to load Saathis. Please check your connection or permissions.");
      } finally {
        setLoading(false);
      }
    };

    fetchSaathis();
  }, []);

  const filteredSaathis = filter === "all" 
    ? saathis 
    : saathis.filter(s => s.verificationStatus === filter);

  if (loading) {
    return <div className="py-12 text-center text-gray-500">Loading Saathis...</div>;
  }

  if (error) {
    return <div className="py-12 text-center text-red-500">{error}</div>;
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold text-gray-900">Vahan Saathis</h1>
        
        <div className="flex space-x-2">
          {["all", "pending", "approved", "rejected"].map((f) => (
            <button
              key={f}
              onClick={() => setFilter(f)}
              className={clsx(
                "px-3 py-1 text-sm font-medium rounded-md capitalize",
                filter === f 
                  ? "bg-indigo-100 text-indigo-700" 
                  : "text-gray-500 hover:bg-gray-100 hover:text-gray-700"
              )}
            >
              {f}
            </button>
          ))}
        </div>
      </div>

      <div className="overflow-hidden bg-white shadow sm:rounded-md">
        {filteredSaathis.length === 0 ? (
          <div className="p-8 text-center text-gray-500">
            No Saathis found matching the selected filter.
          </div>
        ) : (
          <ul role="list" className="divide-y divide-gray-200">
            {filteredSaathis.map((saathi) => (
              <li key={saathi.id}>
                <div className="flex items-center px-4 py-4 sm:px-6">
                  <div className="min-w-0 flex-1 sm:flex sm:items-center sm:justify-between">
                    <div className="truncate">
                      <div className="flex text-sm">
                        <p className="truncate font-medium text-indigo-600">{saathi.name}</p>
                        <p className="ml-1 flex-shrink-0 font-normal text-gray-500">
                          in {saathi.village}, {saathi.taluka}
                        </p>
                      </div>
                      <div className="mt-2 flex">
                        <div className="flex items-center text-sm text-gray-500">
                          <p>
                            Vehicles: <span className="font-medium text-gray-900">{saathi.vehicleCount}</span>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div className="mt-4 flex-shrink-0 sm:ml-5 sm:mt-0">
                      <div className="flex items-center space-x-4">
                        <span className={clsx(
                          "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium capitalize",
                          saathi.verificationStatus === "approved" ? "bg-green-100 text-green-800" :
                          saathi.verificationStatus === "rejected" ? "bg-red-100 text-red-800" :
                          "bg-yellow-100 text-yellow-800"
                        )}>
                          {saathi.verificationStatus}
                        </span>
                        
                        <Link
                          to={`/admin/saathis/${saathi.id}`}
                          className="flex items-center text-sm font-medium text-indigo-600 hover:text-indigo-500"
                        >
                          <Eye className="mr-1.5 h-4 w-4" />
                          Review
                        </Link>
                      </div>
                    </div>
                  </div>
                </div>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
};
