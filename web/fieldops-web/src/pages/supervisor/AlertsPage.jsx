import { useEffect, useState } from 'react';
import { supabase } from '../../lib/supabase';
import { Bell, CheckCircle, AlertTriangle, RefreshCw } from 'lucide-react';
import { formatDistanceToNow } from 'date-fns';

const SEVERITY_STYLES = {
  HIGH:   { cls: 'border-l-red-500 bg-red-50/60',     badge: 'badge-critical', icon: <AlertTriangle size={14} className="text-red-600"/> },
  MEDIUM: { cls: 'border-l-amber-400 bg-amber-50/60', badge: 'badge-late',     icon: <Bell size={14} className="text-amber-500"/> },
  LOW:    { cls: 'border-l-green-400 bg-gray-50',      badge: 'badge-present',  icon: <Bell size={14} className="text-green-600"/> },
};

export default function AlertsPage() {
  const [alerts,  setAlerts]  = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter,  setFilter]  = useState('ALL'); // ALL | HIGH | MEDIUM | LOW | RESOLVED

  useEffect(() => {
    loadAlerts();
    const channel = supabase.channel('alerts-realtime')
      .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'alerts' }, async payload => {
        let newAlert = payload.new;
        if (newAlert.staff_id) {
          const { data: st } = await supabase.from('staff').select('id, name, name_mr, employee_id, department').eq('id', newAlert.staff_id).maybeSingle();
          if (st) newAlert = { ...newAlert, staff: st };
        }
        setAlerts(prev => [newAlert, ...prev]);
      })
      .subscribe();
    return () => channel.unsubscribe();
  }, []);

  async function loadAlerts() {
    setLoading(true);
    const { data } = await supabase
      .from('alerts')
      .select('*, staff:staff_id(id, name, name_mr, employee_id, department)')
      .order('created_at', { ascending: false })
      .limit(100);
    setAlerts(data || []);
    setLoading(false);
  }

  const isAlertResolved = (a) => a.resolved === true || a.is_resolved === true;

  async function resolveAlert(id) {
    await supabase.from('alerts').update({
      resolved: true,
      is_resolved: true,
      resolved_at: new Date().toISOString(),
    }).eq('id', id);
    setAlerts(prev => prev.map(a => a.id === id ? { ...a, resolved: true, is_resolved: true } : a));
  }

  const displayed = alerts.filter(a => {
    const res = isAlertResolved(a);
    if (filter === 'RESOLVED') return res;
    if (filter === 'ALL') return !res;
    return !res && a.severity === filter;
  });

  const unresolved = alerts.filter(a => !isAlertResolved(a)).length;

  return (
    <div className="p-6 space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div className="flex items-center gap-3">
          <h1 className="text-xl font-bold text-gray-900">Alerts</h1>
          {unresolved > 0 && (
            <span className="bg-red-500 text-white text-xs font-bold px-2.5 py-0.5 rounded-full">
              {unresolved} unresolved
            </span>
          )}
        </div>
        <button onClick={loadAlerts} className="flex items-center gap-1.5 text-sm text-gray-500 hover:text-primary transition-colors">
          <RefreshCw size={14}/> Refresh
        </button>
      </div>

      {/* Filter tabs */}
      <div className="flex gap-2 flex-wrap">
        {['ALL','HIGH','MEDIUM','LOW','RESOLVED'].map(f => (
          <button key={f} onClick={() => setFilter(f)}
            className={`text-xs px-3 py-1.5 rounded-full font-medium transition-colors ${
              filter === f
                ? 'bg-primary text-white'
                : 'bg-white border border-gray-200 text-gray-600 hover:border-primary hover:text-primary'
            }`}>
            {f === 'ALL' ? `All (${alerts.filter(a=>!a.resolved).length})` : f}
          </button>
        ))}
      </div>

      {/* Alerts list */}
      {loading ? (
        <div className="flex justify-center py-12">
          <div className="w-6 h-6 border-2 border-primary border-t-transparent rounded-full animate-spin"/>
        </div>
      ) : displayed.length === 0 ? (
        <div className="card text-center py-12">
          <CheckCircle size={40} className="text-green-400 mx-auto mb-3"/>
          <p className="text-sm text-gray-500">No alerts in this category 🎉</p>
        </div>
      ) : (
        <div className="space-y-3">
          {displayed.map(alert => {
            const sev  = SEVERITY_STYLES[alert.severity] || SEVERITY_STYLES.LOW;
            const staff = alert.staff;
            return (
              <div key={alert.id}
                className={`card p-4 border-l-4 ${sev.cls} ${alert.resolved ? 'opacity-60' : ''}`}>
                <div className="flex items-start justify-between gap-4">
                  <div className="flex items-start gap-3 min-w-0">
                    <div className="mt-0.5 flex-shrink-0">{sev.icon}</div>
                    <div className="min-w-0">
                      <div className="flex items-center gap-2 flex-wrap">
                        <p className="text-sm font-semibold text-gray-900">
                          {alert.alert_type?.replace(/_/g,' ')}
                        </p>
                        {alert.alert_type === 'OUT_OF_ZONE' && (
                          <span className="bg-red-600 text-white text-[10px] font-bold px-2 py-0.5 rounded-full">
                            🚨 GEOFENCE BREACH
                          </span>
                        )}
                        <span className={sev.badge}>{alert.severity}</span>
                        {alert.resolved && <span className="badge-present">Resolved</span>}
                      </div>
                      {staff && (
                        <p className="text-xs text-gray-500 mt-0.5">
                          {staff.name_mr || staff.name} · {staff.department} · #{staff.employee_id}
                        </p>
                      )}
                      {alert.message && (
                        <p className="text-xs text-gray-600 mt-1">{alert.message}</p>
                      )}
                      <p className="text-[10px] text-gray-400 mt-1">
                        {formatDistanceToNow(new Date(alert.created_at), { addSuffix: true })}
                      </p>
                    </div>
                  </div>
                  {!alert.resolved && (
                    <button onClick={() => resolveAlert(alert.id)}
                      className="flex-shrink-0 text-xs bg-white border border-gray-200 text-gray-600 hover:bg-primary hover:text-white hover:border-primary px-3 py-1.5 rounded-lg transition-colors font-medium">
                      Resolve
                    </button>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
