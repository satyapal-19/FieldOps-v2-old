import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../hooks/useAuth';
import { Users, CheckCircle, AlertTriangle, Clock, TrendingUp, Activity } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts';

export default function DashboardPage() {
  const { staff } = useAuth();
  const [stats,   setStats]   = useState({ present: 0, absent: 0, late: 0, total: 0 });
  const [alerts,  setAlerts]  = useState([]);
  const [weekData, setWeekData] = useState([]);
  const [wardScores, setWardScores] = useState([]);
  const today = new Date().toISOString().slice(0, 10);

  useEffect(() => {
    loadDashboard();
    // Realtime alerts subscription
    const channel = supabase.channel('alerts-live')
      .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'alerts' }, async payload => {
        let newAlert = payload.new;
        if (newAlert.staff_id) {
          const { data: st } = await supabase.from('staff').select('name').eq('id', newAlert.staff_id).maybeSingle();
          if (st) newAlert = { ...newAlert, staff: st };
        }
        setAlerts(prev => [newAlert, ...prev].slice(0, 10));
      })
      .subscribe();
    return () => channel.unsubscribe();
  }, []);

  async function loadDashboard() {
    // Today attendance stats
    const { data: logs } = await supabase.from('attendance_logs').select('status').eq('date', today);
    if (logs) {
      const present = logs.filter(l => l.status === 'PRESENT').length;
      const late    = logs.filter(l => l.status === 'LATE').length;
      const { count: total } = await supabase.from('staff').select('*', { count: 'exact', head: true }).eq('is_active', true);
      setStats({ present, late, absent: (total || 0) - present - late, total: total || 0 });
    }

    // Last 7 days chart data
    const days = Array.from({ length: 7 }, (_, i) => {
      const d = new Date(); d.setDate(d.getDate() - (6 - i));
      return d.toISOString().slice(0, 10);
    });
    const { data: weekLogs } = await supabase.from('attendance_logs').select('date,status').in('date', days);
    const chartData = days.map(d => ({
      date:    new Date(d).toLocaleDateString('en-IN', { weekday: 'short' }),
      present: (weekLogs || []).filter(l => l.date === d && (l.status === 'PRESENT' || l.status === 'LATE')).length,
      absent:  (weekLogs || []).filter(l => l.date === d && l.status === 'ABSENT').length,
    }));
    setWeekData(chartData);

    // Recent alerts
    const { data: alertData } = await supabase.from('alerts').select('*, staff(name)').order('created_at', { ascending: false }).limit(8);
    setAlerts(alertData || []);

    // Ward scores
    const { data: wards } = await supabase.from('ward_scores').select('*, wards(ward_name)').order('overall_score', { ascending: false }).limit(6);
    setWardScores(wards || []);
  }

  const attendance_pct = stats.total > 0 ? Math.round((stats.present + stats.late) / stats.total * 100) : 0;

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-bold text-gray-900">Dashboard</h1>
          <p className="text-sm text-gray-500 mt-0.5">
            {new Date().toLocaleDateString('mr-IN', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}
          </p>
        </div>
        <span className="text-xs bg-primary-surface text-primary px-3 py-1.5 rounded-full font-medium">
          {staff?.role || 'SUPERVISOR'}
        </span>
      </div>

      {/* Active Geofence Alert Banner */}
      {alerts.some(a => a.alert_type === 'OUT_OF_ZONE' && !(a.resolved || a.is_resolved)) && (
        <div className="bg-red-50 border-l-4 border-red-600 p-3.5 rounded-r-xl flex items-center justify-between shadow-sm">
          <div className="flex items-center gap-3">
            <span className="text-2xl animate-bounce">🚨</span>
            <div>
              <p className="text-xs font-bold text-red-900">ACTIVE GEOFENCE BREACH ALERT (प्रभाग उल्लंघन चेतावणी)</p>
              <p className="text-[11px] text-red-700">
                Staff member Ramesh Patil is OUTSIDE assigned Walchand College (WCE) Geofence!
              </p>
            </div>
          </div>
          <Link to="/alerts" className="text-xs font-semibold bg-red-600 text-white px-3 py-1.5 rounded-lg hover:bg-red-700 transition">
            View in Alerts
          </Link>
        </div>
      )}

      {/* KPI Cards */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <KpiCard icon={<Users size={20}/>}     label="Total Staff"  value={stats.total}        color="primary"  />
        <KpiCard icon={<CheckCircle size={20}/>} label="Present"    value={stats.present}       color="green"   />
        <KpiCard icon={<Clock size={20}/>}      label="Late"         value={stats.late}          color="amber"   />
        <KpiCard icon={<AlertTriangle size={20}/>} label="Absent"   value={stats.absent}        color="red"     />
      </div>

      {/* Attendance % bar */}
      <div className="card">
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <Activity size={16} className="text-primary" />
            <span className="text-sm font-semibold">Today's Attendance</span>
          </div>
          <span className="text-lg font-bold text-primary">{attendance_pct}%</span>
        </div>
        <div className="w-full bg-gray-100 rounded-full h-3">
          <div
            className="bg-primary h-3 rounded-full transition-all duration-700"
            style={{ width: `${attendance_pct}%` }}
          />
        </div>
        <p className="text-xs text-gray-400 mt-2">{stats.present + stats.late} out of {stats.total} staff marked present</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Weekly chart */}
        <div className="card lg:col-span-2">
          <div className="flex items-center gap-2 mb-4">
            <TrendingUp size={16} className="text-primary" />
            <span className="text-sm font-semibold">Weekly Attendance</span>
          </div>
          <ResponsiveContainer width="100%" height={180}>
            <BarChart data={weekData} barGap={2}>
              <XAxis dataKey="date" tick={{ fontSize: 11 }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 11 }} axisLine={false} tickLine={false} />
              <Tooltip
                contentStyle={{ borderRadius: 10, border: 'none', boxShadow: '0 4px 12px rgba(0,0,0,0.1)' }}
                cursor={{ fill: '#f0f0f0' }}
              />
              <Bar dataKey="present" fill="#2E7D32" radius={[4,4,0,0]} name="Present" />
              <Bar dataKey="absent"  fill="#FFCDD2" radius={[4,4,0,0]} name="Absent"  />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Recent Alerts */}
        <div className="card overflow-hidden">
          <div className="flex items-center justify-between mb-3">
            <span className="text-sm font-semibold">Recent Alerts</span>
            <span className="text-xs text-gray-400">{alerts.length} unresolved</span>
          </div>
          <div className="space-y-2 max-h-[200px] overflow-y-auto">
            {alerts.length === 0 && <p className="text-xs text-gray-400 py-4 text-center">No alerts 🎉</p>}
            {alerts.map(a => (
              <div key={a.id} className="flex items-start gap-2 p-2 rounded-lg bg-gray-50">
                <span className={`w-2 h-2 rounded-full mt-1.5 flex-shrink-0 ${
                  a.severity === 'HIGH' ? 'bg-red-500 animate-pulse' : a.severity === 'MEDIUM' ? 'bg-amber-400' : 'bg-green-400'
                }`}/>
                <div className="min-w-0 flex-1">
                  <div className="flex items-center justify-between gap-1">
                    <p className="text-xs font-semibold truncate text-gray-900">{a.alert_type?.replace(/_/g,' ')}</p>
                    {a.alert_type === 'OUT_OF_ZONE' && (
                      <span className="text-[9px] font-bold bg-red-100 text-red-700 px-1 rounded">Geofence</span>
                    )}
                  </div>
                  <p className="text-[10px] text-gray-500 truncate">{a.staff?.name || 'Staff'}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Ward Scores */}
      {wardScores.length > 0 && (
        <div className="card">
          <div className="flex items-center gap-2 mb-4">
            <TrendingUp size={16} className="text-primary" />
            <span className="text-sm font-semibold">Ward Performance Scores</span>
          </div>
          <div className="grid grid-cols-2 lg:grid-cols-3 gap-3">
            {wardScores.map(ws => (
              <div key={ws.id} className="bg-primary-surface rounded-xl p-3">
                <p className="text-xs text-gray-500 truncate">{ws.wards?.ward_name || `Ward ${ws.ward_id}`}</p>
                <p className="text-2xl font-bold text-primary mt-1">{ws.overall_score ?? ws.score ?? 0}<span className="text-sm font-normal text-gray-400">/100</span></p>
                <div className="w-full bg-white rounded-full h-1.5 mt-2">
                  <div className="bg-primary h-1.5 rounded-full" style={{ width: `${ws.overall_score ?? ws.score ?? 0}%` }} />
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

function KpiCard({ icon, label, value, color }) {
  const colorMap = {
    primary: 'bg-primary-surface text-primary',
    green:   'bg-green-50 text-green-700',
    amber:   'bg-amber-50 text-amber-700',
    red:     'bg-red-50 text-red-700',
  };
  return (
    <div className="card flex items-center gap-3">
      <div className={`w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 ${colorMap[color]}`}>
        {icon}
      </div>
      <div>
        <p className="text-2xl font-bold text-gray-900">{value}</p>
        <p className="text-xs text-gray-500">{label}</p>
      </div>
    </div>
  );
}
