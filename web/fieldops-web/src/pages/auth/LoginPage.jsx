import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../hooks/useAuth';
import toast from 'react-hot-toast';
import { Building2, ArrowRight, ShieldCheck, UserCheck, KeyRound } from 'lucide-react';

const FALLBACK_PERSONAS = [
  {
    id: '22222222-0000-0000-0000-000000000002',
    name: 'Sanjay Vitthal Pawar',
    name_mr: 'संजय विठ्ठल पवार',
    phone: '+919822055555',
    role: 'SUPERVISOR',
    department: 'SOLID_WASTE',
    employee_id: 'SMK-2024-002',
  },
  {
    id: '22222222-0000-0000-0000-000000000001',
    name: 'Vikas Dattatray More',
    name_mr: 'विकास दत्तात्रय मोरे',
    phone: '+919822066666',
    role: 'ADMIN',
    department: 'ADMINISTRATION',
    employee_id: 'SMK-2024-001',
  },
  {
    id: '22222222-0000-0000-0000-000000000005',
    name: 'Ramesh Shankar Patil',
    name_mr: 'रमेश शंकर पाटील',
    phone: '+919822011111',
    role: 'STAFF',
    department: 'SOLID_WASTE',
    employee_id: 'SMK-2024-005',
  },
];

export default function LoginPage() {
  const [phone, setPhone] = useState('');
  const [otp, setOtp] = useState('');
  const [otpSent, setOtpSent] = useState(false);
  const [loading, setLoading] = useState(false);
  const [demoStaffList, setDemoStaffList] = useState(FALLBACK_PERSONAS);
  const [simulatedStaff, setSimulatedStaff] = useState(null);

  const { loginAsDemo } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    loadDemoPersonas();
  }, []);

  async function loadDemoPersonas() {
    try {
      const { data } = await supabase
        .from('staff')
        .select('*, wards(*)')
        .order('role', { ascending: false });
      if (data && data.length > 0) {
        setDemoStaffList(data);
      }
    } catch (_) {}
  }

  const handleSendOtp = async () => {
    if (phone.length !== 10) return toast.error('Enter valid 10-digit number');
    setLoading(true);

    const fullPhone = `+91${phone}`;

    // 1. Try standard Supabase OTP
    const { error } = await supabase.auth.signInWithOtp({ phone: fullPhone });

    if (error) {
      // If phone provider is disabled in Supabase, check if phone exists in staff table
      const { data: staffData } = await supabase
        .from('staff')
        .select('*, wards(*)')
        .eq('phone', fullPhone)
        .maybeSingle();

      if (staffData) {
        setSimulatedStaff(staffData);
        setOtpSent(true);
        setOtp('123456'); // pre-fill demo OTP for convenience
        toast.success(`Demo mode: Use OTP 123456 (SMS provider disabled in Supabase)`);
      } else {
        toast.error(`Phone ${fullPhone} not found in staff roster. Try demo numbers below.`);
      }
    } else {
      setOtpSent(true);
      toast.success(`OTP sent to ${fullPhone}`);
    }
    setLoading(false);
  };

  const handleVerifyOtp = async () => {
    if (otp.length !== 6) return toast.error('Enter 6-digit OTP');
    setLoading(true);

    // If simulated demo mode
    if (simulatedStaff) {
      if (otp === '123456') {
        await loginAsDemo(simulatedStaff);
        toast.success(`Welcome ${simulatedStaff.name}!`);
        navigate('/dashboard');
        return;
      } else {
        setLoading(false);
        return toast.error('Invalid OTP. Use demo OTP: 123456');
      }
    }

    // Standard Supabase verify
    const { data, error } = await supabase.auth.verifyOtp({
      phone: `+91${phone}`,
      token: otp,
      type: 'sms',
    });

    setLoading(false);
    if (error) {
      // Fallback check in staff table
      const { data: staffData } = await supabase
        .from('staff')
        .select('*, wards(*)')
        .eq('phone', `+91${phone}`)
        .maybeSingle();

      if (staffData && otp === '123456') {
        await loginAsDemo(staffData);
        toast.success(`Welcome ${staffData.name}!`);
        navigate('/dashboard');
        return;
      }
      return toast.error('Invalid OTP code');
    }

    navigate('/dashboard');
  };

  const handleOneClickLogin = async (staffMember) => {
    setLoading(true);
    await loginAsDemo(staffMember);
    toast.success(`Logged in as ${staffMember.name} (${staffMember.role})`);
    navigate('/dashboard');
  };

  return (
    <div className="min-h-screen bg-primary-surface flex items-center justify-center p-4">
      <div className="w-full max-w-md space-y-6">
        {/* Header */}
        <div className="text-center">
          <div className="w-16 h-16 bg-primary rounded-2xl flex items-center justify-center mx-auto mb-3 shadow-md">
            <Building2 className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-2xl font-black text-primary tracking-tight">FieldOps SMKMC</h1>
          <p className="text-gray-500 text-xs mt-1">सांगली मिरज कुपवाड महानगरपालिका · अधिकृत लॉगिन</p>
        </div>

        {/* Card */}
        <div className="card p-6 space-y-4 shadow-lg border border-primary/10">
          <div>
            <label className="text-xs font-bold text-gray-700 uppercase tracking-wide">
              {otpSent ? 'Enter 6-Digit OTP' : 'Mobile Number'}
            </label>

            {/* Phone input */}
            <div className="mt-2 flex gap-2">
              <span className="flex items-center px-3 bg-gray-50 border border-gray-200 rounded-xl text-sm font-semibold text-gray-600">+91</span>
              <input
                type="tel"
                maxLength={10}
                value={phone}
                onChange={e => setPhone(e.target.value.replace(/\D/g, ''))}
                disabled={otpSent}
                placeholder="9822055555"
                className="flex-1 px-3 py-2.5 border border-gray-200 rounded-xl text-sm font-semibold focus:outline-none focus:border-primary disabled:bg-gray-50 disabled:text-gray-400"
              />
              {otpSent && (
                <button
                  onClick={() => { setOtpSent(false); setSimulatedStaff(null); }}
                  className="text-xs text-primary font-bold px-2 hover:underline"
                >
                  Edit
                </button>
              )}
            </div>

            {/* OTP input */}
            {otpSent && (
              <div className="mt-3 space-y-2">
                <input
                  type="tel"
                  maxLength={6}
                  value={otp}
                  onChange={e => setOtp(e.target.value.replace(/\D/g, ''))}
                  placeholder="123456"
                  className="w-full px-3 py-3 border-2 border-primary/30 rounded-xl text-center text-xl font-mono font-bold tracking-widest focus:outline-none focus:border-primary"
                />
                {simulatedStaff && (
                  <p className="text-[11px] text-amber-700 bg-amber-50 p-2 rounded-lg text-center font-medium">
                    ⚡ Demo Mode: Pre-filled with demo OTP <strong>123456</strong>
                  </p>
                )}
              </div>
            )}
          </div>

          <button
            onClick={otpSent ? handleVerifyOtp : handleSendOtp}
            disabled={loading}
            className="btn-primary w-full flex items-center justify-center gap-2 py-3 shadow-sm"
          >
            {loading ? (
              <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
            ) : (
              <>
                <span className="font-bold text-sm">{otpSent ? 'Verify & Access Dashboard' : 'Get OTP'}</span>
                <ArrowRight className="w-4 h-4" />
              </>
            )}
          </button>

          {otpSent && (
            <button onClick={handleSendOtp} className="w-full text-xs text-gray-400 hover:text-primary text-center font-medium">
              Resend OTP
            </button>
          )}

          {/* Quick Demo Login Personas */}
          <div className="pt-4 border-t border-gray-100 space-y-2">
            <p className="text-[11px] font-bold text-gray-500 uppercase tracking-wider text-center">
              — Quick Demo Login (1-Click) —
            </p>

            <div className="grid grid-cols-1 gap-2 pt-1">
              {demoStaffList.length > 0 ? (
                demoStaffList.slice(0, 3).map(s => (
                  <button
                    key={s.id}
                    type="button"
                    onClick={() => handleOneClickLogin(s)}
                    className="w-full text-left p-2.5 rounded-xl border border-gray-200 hover:border-primary hover:bg-primary-surface transition-all flex items-center justify-between text-xs group"
                  >
                    <div className="flex items-center gap-2.5">
                      <div className="w-7 h-7 rounded-lg bg-primary-surface text-primary group-hover:bg-primary group-hover:text-white transition-colors flex items-center justify-center font-bold">
                        {s.role === 'ADMIN' ? '👑' : s.role === 'SUPERVISOR' ? '🏢' : '👷'}
                      </div>
                      <div>
                        <p className="font-bold text-gray-900 group-hover:text-primary transition-colors">{s.name}</p>
                        <p className="text-[10px] text-gray-400">{s.role} · {s.department}</p>
                      </div>
                    </div>
                    <span className="text-[10px] font-semibold text-primary group-hover:underline">
                      Login →
                    </span>
                  </button>
                ))
              ) : (
                <div className="text-center text-xs text-gray-400 py-2">Loading demo staff...</div>
              )}
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="text-center space-y-1">
          <p className="text-xs text-gray-400">
            For Sangli Miraj Kupwad Municipal Corporation
          </p>
          <a href="/citizen" className="text-xs font-semibold text-primary hover:underline block">
            ← Go to Public Citizen Grievance Portal
          </a>
        </div>
      </div>
    </div>
  );
}
