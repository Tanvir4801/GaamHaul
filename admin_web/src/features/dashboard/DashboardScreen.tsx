import React from "react";
import { Truck, ClipboardList, ShieldAlert } from "lucide-react";

export const DashboardScreen: React.FC = () => {
  // Phase 7.1 strictly prevents displaying fake data.
  // Showing empty state/placeholders until Phase 7.x Analytics is implemented.
  
  const stats = [
    { name: "Total Saathis", value: "—", icon: Truck },
    { name: "Active Vehicles", value: "—", icon: Truck },
    { name: "Open Requests", value: "—", icon: ClipboardList },
    { name: "Pending Verifications", value: "—", icon: ShieldAlert, alert: true },
  ];

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
        {stats.map((item) => (
          <div key={item.name} className="overflow-hidden rounded-lg bg-white px-4 py-5 shadow sm:p-6">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <item.icon className={`h-6 w-6 ${item.alert ? 'text-amber-500' : 'text-gray-400'}`} aria-hidden="true" />
              </div>
              <div className="ml-5 w-0 flex-1">
                <dl>
                  <dt className="truncate text-sm font-medium text-gray-500">{item.name}</dt>
                  <dd>
                    <div className="text-lg font-medium text-gray-900">{item.value}</div>
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="rounded-lg bg-white shadow">
        <div className="px-4 py-5 sm:p-6 text-center text-gray-500">
          <div className="py-12">
            <h3 className="mt-2 text-sm font-semibold text-gray-900">Dashboard functionality pending</h3>
            <p className="mt-1 text-sm text-gray-500">
              The live analytics and administrative operations will be available in upcoming Phase 7 deployments.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};
