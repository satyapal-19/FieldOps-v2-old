import { useState, useEffect, createContext, useContext } from 'react';
import { supabase } from '../lib/supabase';

const AuthContext = createContext(null);

const DEFAULT_SUPERVISOR = {
  id: '22222222-0000-0000-0000-000000000002',
  name: 'Sanjay Vitthal Pawar',
  name_mr: 'संजय विठ्ठल पवार',
  phone: '+919822055555',
  role: 'SUPERVISOR',
  department: 'SOLID_WASTE',
  employee_id: 'SMK-2024-002',
  is_active: true,
};

export function AuthProvider({ children }) {
  const [user, setUser]       = useState(null);
  const [staff, setStaff]     = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // 1. Check if demo session is stored in localStorage
    const demoStaffId = localStorage.getItem('fieldops_demo_staff_id');
    if (demoStaffId) {
      loadStaff(demoStaffId, true);
      return;
    }

    // 2. Check standard Supabase session
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session?.user) {
        setUser(session.user);
        loadStaff(session.user.id);
      } else if (!localStorage.getItem('fieldops_logged_out')) {
        // Auto-login as default Supervisor for instant demo access
        localStorage.setItem('fieldops_demo_staff_id', DEFAULT_SUPERVISOR.id);
        setStaff(DEFAULT_SUPERVISOR);
        setUser({ id: DEFAULT_SUPERVISOR.id, phone: DEFAULT_SUPERVISOR.phone, email: DEFAULT_SUPERVISOR.employee_id });
        setLoading(false);
      } else {
        setUser(null);
        setStaff(null);
        setLoading(false);
      }
    });

    const { data: listener } = supabase.auth.onAuthStateChange((_event, session) => {
      // If demo session active, don't overwrite
      if (localStorage.getItem('fieldops_demo_staff_id')) return;

      setUser(session?.user ?? null);
      if (session?.user) loadStaff(session.user.id);
      else { setStaff(null); setLoading(false); }
    });

    return () => listener.subscription.unsubscribe();
  }, []);

  async function loadStaff(staffId, isDemo = false) {
    try {
      const { data, error } = await supabase
        .from('staff')
        .select('*, wards(*)')
        .eq('id', staffId)
        .single();

      if (data && !error) {
        setStaff(data);
        setUser({ id: data.id, phone: data.phone, email: data.smkmc_id || data.employee_id });
      } else if (isDemo) {
        // Use default supervisor as reliable fallback
        setStaff(DEFAULT_SUPERVISOR);
        setUser({ id: DEFAULT_SUPERVISOR.id, phone: DEFAULT_SUPERVISOR.phone, email: DEFAULT_SUPERVISOR.employee_id });
      }
    } catch (_) {
      if (isDemo) {
        setStaff(DEFAULT_SUPERVISOR);
        setUser({ id: DEFAULT_SUPERVISOR.id, phone: DEFAULT_SUPERVISOR.phone, email: DEFAULT_SUPERVISOR.employee_id });
      }
    } finally {
      setLoading(false);
    }
  }

  const loginAsDemo = async (staffRecord) => {
    localStorage.removeItem('fieldops_logged_out');
    localStorage.setItem('fieldops_demo_staff_id', staffRecord.id);
    setStaff(staffRecord);
    setUser({ id: staffRecord.id, phone: staffRecord.phone, email: staffRecord.smkmc_id || staffRecord.employee_id });
    setLoading(false);
  };

  const logout = async () => {
    localStorage.setItem('fieldops_logged_out', 'true');
    localStorage.removeItem('fieldops_demo_staff_id');
    try {
      await supabase.auth.signOut();
    } catch (_) {}
    setUser(null);
    setStaff(null);
  };

  return (
    <AuthContext.Provider value={{ user, staff, loading, loginAsDemo, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
