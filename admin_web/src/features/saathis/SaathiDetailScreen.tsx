import React, { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { doc, getDoc, collection, query, where, documentId, getDocs } from "firebase/firestore";
import { getFunctions, httpsCallable } from "firebase/functions";
import { db } from "../../lib/firebase";
import { ArrowLeft, CheckCircle, XCircle } from "lucide-react";
import clsx from "clsx";

interface Vehicle {
  id: string;
  type: string;
  registrationNumber: string;
  status: string;
  photoUrl: string;
  rcPhotoUrl: string;
}

interface SaathiDetail {
  id: string;
  verificationStatus: string;
  name: string;
  phone: string;
  village: string;
  taluka: string;
  vehicles: Vehicle[];
}

export const SaathiDetailScreen: React.FC = () => {
  const { id } = useParams<{ id: string }>();

  
  const [saathi, setSaathi] = useState<SaathiDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [mutating, setMutating] = useState(false);

  useEffect(() => {
    const fetchDetail = async () => {
      if (!id) return;
      setLoading(true);
      setError(null);
      
      try {
        const saathiDoc = await getDoc(doc(db, "vahan_saathis", id));
        if (!saathiDoc.exists()) {
          setError("Saathi profile not found.");
          setLoading(false);
          return;
        }

        const userDoc = await getDoc(doc(db, "users", id));
        const userData = userDoc.exists() ? userDoc.data() : {};
        const saathiData = saathiDoc.data();

        const vehicleIds: string[] = saathiData.vehicles || [];
        const vehicles: Vehicle[] = [];

        if (vehicleIds.length > 0) {
          // Fetch vehicles
          // We can use an 'in' query safely assuming a Saathi has < 10 vehicles
          const vQuery = query(collection(db, "vehicles"), where(documentId(), "in", vehicleIds));
          const vSnap = await getDocs(vQuery);
          vSnap.forEach(vDoc => {
            const vData = vDoc.data();
            vehicles.push({
              id: vDoc.id,
              type: vData.type || "Unknown",
              registrationNumber: vData.registrationNumber || "Unknown",
              status: vData.status || "Unknown",
              photoUrl: vData.photoUrl || "",
              rcPhotoUrl: vData.rcPhotoUrl || "",
            });
          });
        }

        setSaathi({
          id,
          verificationStatus: saathiData.verificationStatus || "pending",
          name: userData.name || "Unknown",
          phone: userData.phone || "Unknown",
          village: userData.village || "Unknown",
          taluka: userData.taluka || "Unknown",
          vehicles,
        });

      } catch (err: any) {
        console.error("Failed to fetch Saathi details:", err);
        setError("Failed to load details. Please check your connection or permissions.");
      } finally {
        setLoading(false);
      }
    };

    fetchDetail();
  }, [id]);

  const handleAction = async (action: "approve" | "reject") => {
    if (!saathi) return;
    
    const confirmMessage = action === "approve" 
      ? `Approve Vahan Saathi ${saathi.name}?` 
      : `Reject Vahan Saathi ${saathi.name}?`;
      
    if (!window.confirm(confirmMessage)) return;

    setMutating(true);
    setError(null);

    try {
      const functions = getFunctions();
      const callableName = action === "approve" ? "approveSaathi" : "rejectSaathi";
      const mutationFn = httpsCallable(functions, callableName);
      
      const result = await mutationFn({ saathiId: saathi.id });
      const data = result.data as any;
      
      if (data.success) {
        setSaathi({
          ...saathi,
          verificationStatus: data.verificationStatus
        });
        alert(`Successfully ${data.verificationStatus} Saathi.`);
      } else {
        setError("Operation did not return success.");
      }
    } catch (err: any) {
      console.error(`Failed to ${action} Saathi:`, err);
      setError(`Failed to ${action} Saathi. ${err.message || "Unknown error"}`);
    } finally {
      setMutating(false);
    }
  };

  if (loading) {
    return <div className="py-12 text-center text-gray-500">Loading details...</div>;
  }

  if (error || !saathi) {
    return (
      <div className="space-y-4">
        <Link to="/admin/saathis" className="flex items-center text-sm font-medium text-indigo-600 hover:text-indigo-500">
          <ArrowLeft className="mr-1 h-4 w-4" /> Back to List
        </Link>
        <div className="py-12 text-center text-red-500">{error || "Not found"}</div>
      </div>
    );
  }

  return (
    <div className="space-y-6 max-w-5xl mx-auto">
      <div className="flex items-center justify-between">
        <Link to="/admin/saathis" className="flex items-center text-sm font-medium text-indigo-600 hover:text-indigo-500">
          <ArrowLeft className="mr-1 h-4 w-4" /> Back to List
        </Link>
        
        <div className="flex items-center space-x-4">
          <span className={clsx(
            "inline-flex items-center rounded-full px-3 py-1 text-sm font-medium capitalize",
            saathi.verificationStatus === "approved" ? "bg-green-100 text-green-800" :
            saathi.verificationStatus === "rejected" ? "bg-red-100 text-red-800" :
            "bg-yellow-100 text-yellow-800"
          )}>
            Status: {saathi.verificationStatus}
          </span>
          
          {saathi.verificationStatus === "pending" && (
            <div className="flex space-x-2">
              <button
                onClick={() => handleAction("reject")}
                disabled={mutating}
                className="flex items-center px-4 py-2 bg-white border border-red-300 rounded-md shadow-sm text-sm font-medium text-red-700 hover:bg-red-50 disabled:opacity-50"
              >
                <XCircle className="h-4 w-4 mr-1.5" />
                Reject
              </button>
              <button
                onClick={() => handleAction("approve")}
                disabled={mutating}
                className="flex items-center px-4 py-2 bg-indigo-600 border border-transparent rounded-md shadow-sm text-sm font-medium text-white hover:bg-indigo-700 disabled:opacity-50"
              >
                <CheckCircle className="h-4 w-4 mr-1.5" />
                Approve
              </button>
            </div>
          )}
        </div>
      </div>

      <div className="bg-white shadow overflow-hidden sm:rounded-lg">
        <div className="px-4 py-5 sm:px-6">
          <h3 className="text-lg leading-6 font-medium text-gray-900">Saathi Profile</h3>
          <p className="mt-1 max-w-2xl text-sm text-gray-500">Personal details and application status.</p>
        </div>
        <div className="border-t border-gray-200 px-4 py-5 sm:p-0">
          <dl className="sm:divide-y sm:divide-gray-200">
            <div className="py-4 sm:py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
              <dt className="text-sm font-medium text-gray-500">Full name</dt>
              <dd className="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">{saathi.name}</dd>
            </div>
            <div className="py-4 sm:py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
              <dt className="text-sm font-medium text-gray-500">Phone</dt>
              <dd className="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">{saathi.phone}</dd>
            </div>
            <div className="py-4 sm:py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
              <dt className="text-sm font-medium text-gray-500">Location</dt>
              <dd className="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">{saathi.village}, {saathi.taluka}</dd>
            </div>
          </dl>
        </div>
      </div>

      <h3 className="text-lg font-medium text-gray-900 mt-8 mb-4">Registered Vehicles ({saathi.vehicles.length})</h3>
      
      {saathi.vehicles.length === 0 ? (
        <div className="bg-white shadow sm:rounded-lg p-6 text-center text-gray-500">
          No vehicles registered.
        </div>
      ) : (
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {saathi.vehicles.map((vehicle) => (
            <div key={vehicle.id} className="bg-white shadow overflow-hidden sm:rounded-lg border border-gray-200">
              <div className="px-4 py-5 sm:px-6 bg-gray-50 border-b border-gray-200">
                <h4 className="text-md font-medium text-gray-900 uppercase">{vehicle.registrationNumber}</h4>
                <p className="text-sm text-gray-500 capitalize">{vehicle.type.replace('_', ' ')}</p>
                <p className="text-xs text-gray-400 mt-1 uppercase">Status: {vehicle.status}</p>
              </div>
              <div className="px-4 py-4 space-y-4">
                <div>
                  <h5 className="text-xs font-medium text-gray-500 uppercase tracking-wider mb-2">Vehicle Photo</h5>
                  {vehicle.photoUrl ? (
                    <a href={vehicle.photoUrl} target="_blank" rel="noopener noreferrer" className="block w-full h-32 bg-gray-100 rounded-md overflow-hidden border border-gray-200 hover:opacity-75">
                      <img src={vehicle.photoUrl} alt="Vehicle" className="w-full h-full object-cover" />
                    </a>
                  ) : (
                    <div className="w-full h-32 bg-gray-100 rounded-md flex items-center justify-center text-sm text-gray-400 border border-gray-200">
                      No Photo
                    </div>
                  )}
                </div>
                
                <div>
                  <h5 className="text-xs font-medium text-gray-500 uppercase tracking-wider mb-2">RC Document</h5>
                  {vehicle.rcPhotoUrl ? (
                    <a href={vehicle.rcPhotoUrl} target="_blank" rel="noopener noreferrer" className="block w-full h-32 bg-gray-100 rounded-md overflow-hidden border border-gray-200 hover:opacity-75">
                      <img src={vehicle.rcPhotoUrl} alt="RC Document" className="w-full h-full object-cover" />
                    </a>
                  ) : (
                    <div className="w-full h-32 bg-gray-100 rounded-md flex items-center justify-center text-sm text-gray-400 border border-gray-200">
                      No RC Photo
                    </div>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};
