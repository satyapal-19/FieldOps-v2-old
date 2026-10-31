import { useState, useEffect } from 'react';
import { Outlet, NavLink, useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import { supabase } from '../../lib/supabase';
import {
  LayoutDashboard, Map, ClipboardList, Bell, FileText,
  Users, CheckSquare, MessageSquare, Calendar, CreditCard,
  BarChart2, LogOut, Building2,
} from 'lucide-react';

const navItems = [
  { to: '/dashboard',  icon: LayoutDashboard, label: 'Dashboard' },
  { to: '/live-map',   icon: Map,             label: 'Live Map' },
  { to: '/attendance', icon: ClipboardList,   label: 'Attendance' },
  { to: '/alerts',     icon: Bell,            label: 'Alerts',    badge: true },
  { to: '/tasks',      icon: CheckSquare,     label: 'Tasks' },
  { to: '/chat',       icon: MessageSquare,   label: 'Chat' },
  { to: '/leave',      icon: Calendar,        label: 'Leave' },
  { to: '/payroll',    icon: CreditCard,      label: 'Payroll' },
  { to: '/reports',    icon: FileText,        label: 'Reports' },
  { to: '/staff',      icon: Users,           label: 'Staff' },
];

const adminItems = [
  { to: '/analytics', icon: BarChart2, label: 'Analytics' },
];

export default function AppLayout() {
  const { staff, logout } = useAuth();
  const navigate  = useNavigate();
  const [unresolvedAlerts, setUnresolvedAlerts] = useState(0);

  useEffect(() => {
    async function fetchAlertCount() {
      const { data } = await supabase.from('alerts').select('id, resolved, is_resolved');
      if (data) {
        setUnresolvedAlerts(data.filter(a => !(a.resolved || a.is_resolved)).length);
      }
    }
    fetchAlertCount();
    const ch = supabase.channel('sidebar-alerts')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'alerts' }, () => {
        fetchAlertCount();
      })
      .subscribe();
    return () => ch.unsubscribe();
  }, []);

  const handleLogout = async () => {
    if (logout) await logout();
    else await supabase.auth.signOut();
    navigate('/login');
  };

  const isAdmin = staff?.role === 'ADMIN';

  return (
    <div className="flex h-screen bg-primary-surface overflow-hidden">
      {/* Sidebar */}
      <aside className="w-60 bg-white border-r border-gray-200 flex flex-col flex-shrink-0">
        {/* Logo */}
        <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
          <div className="w-9 h-9 bg-primary rounded-xl flex items-center justify-center">
            <Building2 className="w-5 h-5 text-white" />
          </div>
          <div>
            <p className="text-sm font-bold text-primary leading-none">FieldOps</p>
            <p className="text-[10px] text-gray-400 leading-none mt-0.5">SMKMC</p>
          </div>
        </div>

        {/* Nav */}
        <nav className="flex-1 px-3 py-4 space-y-0.5 overflow-y-auto">
          {navItems.map(({ to, icon: Icon, label, badge }) => (
            <NavLink key={to} to={to} className={({ isActive }) =>
              `sidebar-link ${isActive ? 'active' : ''}`
            }>
              <Icon className="w-4 h-4 flex-shrink-0" />
              <span className="flex-1">{label}</span>
              {badge && unresolvedAlerts > 0 && (
                <span className="bg-red-500 text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full">
                  {unresolvedAlerts}
                </span>
              )}
            </NavLink>
          ))}

          {isAdmin && (
            <>
              <div className="pt-3 pb-1 px-1">
                <p className="text-[10px] font-semibold text-gray-400 uppercase tracking-wider">Admin</p>
              </div>
              {adminItems.map(({ to, icon: Icon, label }) => (
                <NavLink key={to} to={to} className={({ isActive }) =>
                  `sidebar-link ${isActive ? 'active' : ''}`
                }>
                  <Icon className="w-4 h-4 flex-shrink-0" />
                  <span>{label}</span>
                </NavLink>
              ))}
            </>
          )}
        </nav>

        {/* User footer */}
        <div className="border-t border-gray-100 px-4 py-3">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 bg-primary-surface rounded-full flex items-center justify-center">
              <span className="text-primary font-semibold text-sm">
                {staff?.name?.charAt(0) ?? 'S'}
              </span>
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-sm font-medium text-gray-800 truncate">{staff?.name ?? 'Supervisor'}</p>
              <p className="text-[11px] text-gray-400 truncate">{staff?.role}</p>
            </div>
            <button onClick={handleLogout} className="text-gray-400 hover:text-red-500 transition-colors">
              <LogOut className="w-4 h-4" />
            </button>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <main className="flex-1 overflow-y-auto">
        <Outlet />
      </main>
    </div>
  );
}
