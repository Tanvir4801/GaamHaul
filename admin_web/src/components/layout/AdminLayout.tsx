import React from "react";
import { Navigate, Outlet, Link, useLocation } from "react-router-dom";
import { useAuth } from "../../contexts/AuthContext";
import { signOut } from "firebase/auth";
import { auth } from "../../lib/firebase";
import { 
  LayoutDashboard, 
  Users, 
  Truck, 
  ClipboardList, 
  Star, 
  Settings,
  LogOut
} from "lucide-react";
import clsx from "clsx";

export const AdminLayout: React.FC = () => {
  const { authState, user } = useAuth();
  const location = useLocation();

  if (authState === "loading") {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gray-50">
        <div className="text-gray-500">Checking authorization...</div>
      </div>
    );
  }

  if (authState !== "authorized-admin") {
    return <Navigate to="/login" replace />;
  }

  const handleSignOut = async () => {
    await signOut(auth);
  };

  const navItems = [
    { name: "Dashboard", href: "/admin", icon: LayoutDashboard, isReady: true },
    { name: "Saathis", href: "/admin/saathis", icon: Truck, isReady: true },
    { name: "Users", href: "/admin/users", icon: Users, isReady: false },
    { name: "Requests", href: "/admin/requests", icon: ClipboardList, isReady: false },
    { name: "Ratings", href: "/admin/ratings", icon: Star, isReady: false },
    { name: "Settings", href: "/admin/settings", icon: Settings, isReady: false },
  ];

  return (
    <div className="flex min-h-screen bg-gray-100">
      {/* Sidebar */}
      <div className="w-64 bg-white shadow-sm flex flex-col">
        <div className="h-16 flex items-center px-6 border-b border-gray-200">
          <h1 className="text-xl font-bold text-gray-900">GaamHaul Admin</h1>
        </div>
        
        <div className="flex-1 overflow-y-auto py-4">
          <nav className="space-y-1 px-3">
            {navItems.map((item) => {
              const Icon = item.icon;
              const isActive = location.pathname === item.href;
              
              return (
                <div key={item.name}>
                  {item.isReady ? (
                    <Link
                      to={item.href}
                      className={clsx(
                        isActive ? "bg-indigo-50 text-indigo-600" : "text-gray-700 hover:bg-gray-50 hover:text-indigo-600",
                        "group flex items-center px-3 py-2 text-sm font-medium rounded-md"
                      )}
                    >
                      <Icon className={clsx(
                        isActive ? "text-indigo-600" : "text-gray-400 group-hover:text-indigo-600",
                        "flex-shrink-0 -ml-1 mr-3 h-5 w-5"
                      )} />
                      <span className="truncate">{item.name}</span>
                    </Link>
                  ) : (
                    <div className="group flex items-center px-3 py-2 text-sm font-medium rounded-md text-gray-400 cursor-not-allowed" title="Coming soon">
                      <Icon className="flex-shrink-0 -ml-1 mr-3 h-5 w-5 text-gray-300" />
                      <span className="truncate">{item.name}</span>
                      <span className="ml-auto text-[10px] uppercase tracking-wider font-semibold text-gray-300">Soon</span>
                    </div>
                  )}
                </div>
              );
            })}
          </nav>
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Header */}
        <header className="bg-white shadow-sm h-16 flex items-center justify-between px-8 z-10">
          <h2 className="text-lg font-medium text-gray-900">
            {navItems.find(i => i.href === location.pathname)?.name || "Dashboard"}
          </h2>
          
          <div className="flex items-center space-x-4">
            <span className="text-sm text-gray-500">{user?.email}</span>
            <button
              onClick={handleSignOut}
              className="flex items-center text-sm font-medium text-gray-500 hover:text-gray-700"
            >
              <LogOut className="h-4 w-4 mr-1" />
              Sign out
            </button>
          </div>
        </header>

        {/* Main Area */}
        <main className="flex-1 overflow-y-auto p-8">
          <Outlet />
        </main>
      </div>
    </div>
  );
};
