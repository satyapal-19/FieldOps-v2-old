import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { Toaster } from 'react-hot-toast';
import { useAuth } from './hooks/useAuth';
import LoginPage        from './pages/auth/LoginPage';
import DashboardPage    from './pages/supervisor/DashboardPage';
import LiveMapPage      from './pages/supervisor/LiveMapPage';
import AttendancePage   from './pages/supervisor/AttendancePage';
import AlertsPage       from './pages/supervisor/AlertsPage';
import ReportsPage      from './pages/supervisor/ReportsPage';
import StaffPage        from './pages/supervisor/StaffPage';
import TasksPage        from './pages/supervisor/TasksPage';
import ChatPage         from './pages/supervisor/ChatPage';
import LeaveApprovalsPage from './pages/supervisor/LeaveApprovalsPage';
import PayrollPage      from './pages/supervisor/PayrollPage';
import AnalyticsPage    from './pages/admin/AnalyticsPage';
import CitizenHome      from './pages/citizen/CitizenHome';
import CitizenWardPage  from './pages/citizen/CitizenWardPage';
import AppLayout        from './components/layout/AppLayout';

function ProtectedRoute({ children }) {
  const { user, loading } = useAuth();
  if (loading) return <div className="h-screen flex items-center justify-center">
    <div className="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin" />
  </div>;
  return user ? children : <Navigate to="/login" replace />;
}

export default function App() {
  return (
    <BrowserRouter>
      <Toaster position="top-right" />
      <Routes>
        {/* Auth */}
        <Route path="/login" element={<LoginPage />} />

        {/* Citizen Portal — public */}
        <Route path="/citizen"          element={<CitizenHome />} />
        <Route path="/citizen/ward/:id" element={<CitizenWardPage />} />

        {/* Protected supervisor/admin routes */}
        <Route path="/" element={
          <ProtectedRoute><AppLayout /></ProtectedRoute>
        }>
          <Route index                element={<Navigate to="/dashboard" replace />} />
          <Route path="dashboard"     element={<DashboardPage />} />
          <Route path="live-map"      element={<LiveMapPage />} />
          <Route path="attendance"    element={<AttendancePage />} />
          <Route path="alerts"        element={<AlertsPage />} />
          <Route path="tasks"         element={<TasksPage />} />
          <Route path="chat"          element={<ChatPage />} />
          <Route path="leave"         element={<LeaveApprovalsPage />} />
          <Route path="payroll"       element={<PayrollPage />} />
          <Route path="reports"       element={<ReportsPage />} />
          <Route path="staff"         element={<StaffPage />} />
          <Route path="analytics"     element={<AnalyticsPage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
