import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider } from "./contexts/AuthContext";
import { LoginScreen } from "./features/auth/LoginScreen";
import { AdminLayout } from "./components/layout/AdminLayout";
import { DashboardScreen } from "./features/dashboard/DashboardScreen";
import { SaathiListScreen } from "./features/saathis/SaathiListScreen";
import { SaathiDetailScreen } from "./features/saathis/SaathiDetailScreen";

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<LoginScreen />} />
          <Route path="/admin" element={<AdminLayout />}>
            <Route index element={<DashboardScreen />} />
            <Route path="saathis" element={<SaathiListScreen />} />
            <Route path="saathis/:id" element={<SaathiDetailScreen />} />
            {/* Future routes will go here */}
            <Route path="*" element={
              <div className="py-12 text-center text-gray-500">
                Screen not found or under construction.
              </div>
            } />
          </Route>
          <Route path="/" element={<Navigate to="/admin" replace />} />
          <Route path="*" element={<Navigate to="/admin" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;
