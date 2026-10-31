import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { FileText, Download, Printer, Filter, Calendar, BarChart3, CheckCircle } from 'lucide-react';
import toast from 'react-hot-toast';

export default function ReportsPage() {
  const [reportType, setReportType] = useState('ATTENDANCE'); // ATTENDANCE | TASKS | WARDS | ALERTS
  const [dateFrom, setDateFrom] = useState(new Date(Date.now() - 7 * 86400000).toISOString().slice(0, 10));
  const [dateTo, setDateTo] = useState(new Date().toISOString().slice(0, 10));
  const [department, setDepartment] = useState('ALL');
  const [reportData, setReportData] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    generateReport();
  }, [reportType, dateFrom, dateTo, department]);

  async function generateReport() {
    setLoading(true);
    try {
      if (reportType === 'ATTENDANCE') {
        let query = supabase
          .from('attendance_logs')
          .select('*, staff:staff_id(name, name_mr, employee_id, department)')
          .gte('date', dateFrom)
          .lte('date', dateTo)
          .order('date', { ascending: false });

        const { data } = await query;
        let filtered = data || [];
        if (department !== 'ALL') {
          filtered = filtered.filter(l => l.staff?.department === department);
        }
        setReportData(filtered);
      } else if (reportType === 'TASKS') {
        const { data } = await supabase
          .from('tasks')
          .select('*, assigned_staff:assigned_to(name, department)')
          .gte('created_at', `${dateFrom}T00:00:00Z`)
          .lte('created_at', `${dateTo}T23:59:59Z`)
          .order('created_at', { ascending: false });

        let filtered = data || [];
        if (department !== 'ALL') {
          filtered = filtered.filter(t => t.assigned_staff?.department === department);
        }
        setReportData(filtered);
      } else if (reportType === 'WARDS') {
        const { data } = await supabase
          .from('ward_scores')
          .select('*, wards(ward_name)')
          .order('score', { ascending: false });
        setReportData(data || []);
      } else if (reportType === 'ALERTS') {
        const { data } = await supabase
          .from('alerts')
          .select('*, staff(name, department)')
          .gte('created_at', `${dateFrom}T00:00:00Z`)
          .lte('created_at', `${dateTo}T23:59:59Z`)
          .order('created_at', { ascending: false });

        setReportData(data || []);
      }
    } catch (e) {
      toast.error('Failed to generate report');
    } finally {
      setLoading(false);
    }
  }

  function exportReportCSV() {
    if (reportData.length === 0) {
      toast.error('No data to export');
      return;
    }

    let headers = [];
    let rows = [];

    if (reportType === 'ATTENDANCE') {
      headers = ['Date', 'Employee ID', 'Name', 'Department', 'Status', 'Check-in', 'Check-out', 'In Zone', 'Face Match'];
      rows = reportData.map(r => [
        r.date,
        r.staff?.employee_id || '',
        r.staff?.name || '',
        r.staff?.department || '',
        r.status || '',
        r.checkin_time ? new Date(r.checkin_time).toLocaleTimeString() : '',
        r.checkout_time ? new Date(r.checkout_time).toLocaleTimeString() : '',
        r.checkin_within_geofence ? 'YES' : 'NO',
        r.checkin_face_score ? `${Math.round(r.checkin_face_score * 100)}%` : '',
      ]);
    } else if (reportType === 'TASKS') {
      headers = ['Task Title', 'Assigned To', 'Priority', 'Status', 'Location', 'Created At'];
      rows = reportData.map(r => [
        r.title,
        r.assigned_staff?.name || '',
        r.priority,
        r.status,
        r.location_label || '',
        new Date(r.created_at).toLocaleDateString(),
      ]);
    } else {
      headers = ['ID', 'Date', 'Type/Score'];
      rows = reportData.map(r => [r.id, r.date || r.created_at || '', r.score || r.alert_type || '']);
    }

    const csvContent = [headers, ...rows].map(e => e.join(',')).join('\n');
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.setAttribute('href', url);
    link.setAttribute('download', `SMKMC_${reportType}_Report.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    toast.success('Report downloaded!');
  }

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between flex-wrap gap-4">
        <div>
          <h1 className="text-xl font-bold text-gray-900 flex items-center gap-2">
            <FileText className="text-primary" size={24} />
            Reports & Compliance Audit
          </h1>
          <p className="text-sm text-gray-500 mt-0.5">Generate municipal performance audit reports & CSV downloads</p>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => window.print()}
            className="flex items-center gap-1.5 bg-white border border-gray-200 text-gray-700 px-3 py-2 rounded-xl text-xs font-semibold hover:bg-gray-50 transition-all"
          >
            <Printer size={14} /> Print
          </button>
          <button
            onClick={exportReportCSV}
            className="flex items-center gap-1.5 bg-primary hover:bg-primary-dark text-white px-4 py-2 rounded-xl text-xs font-semibold shadow-sm transition-all"
          >
            <Download size={14} /> Export CSV
          </button>
        </div>
      </div>

      {/* Filter Control Box */}
      <div className="card space-y-4">
        <div className="flex items-center gap-2 pb-3 border-b border-gray-100 flex-wrap">
          <span className="text-xs font-bold text-gray-500 uppercase tracking-wider mr-2">Report Type:</span>
          {[
            { id: 'ATTENDANCE', label: 'Attendance Audit' },
            { id: 'TASKS', label: 'Task Execution' },
            { id: 'WARDS', label: 'Ward Scores' },
            { id: 'ALERTS', label: 'Exception Alerts' },
          ].map(t => (
            <button
              key={t.id}
              onClick={() => setReportType(t.id)}
              className={`text-xs px-3.5 py-1.5 rounded-full font-semibold transition-all ${
                reportType === t.id
                  ? 'bg-primary text-white shadow-sm'
                  : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
              }`}
            >
              {t.label}
            </button>
          ))}
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
          <div>
            <label className="text-[11px] font-bold text-gray-500 uppercase">From Date</label>
            <input
              type="date"
              value={dateFrom}
              onChange={e => setDateFrom(e.target.value)}
              className="w-full mt-1 text-xs border border-gray-200 rounded-xl px-3 py-2 focus:border-primary focus:outline-none"
            />
          </div>
          <div>
            <label className="text-[11px] font-bold text-gray-500 uppercase">To Date</label>
            <input
              type="date"
              value={dateTo}
              onChange={e => setDateTo(e.target.value)}
              className="w-full mt-1 text-xs border border-gray-200 rounded-xl px-3 py-2 focus:border-primary focus:outline-none"
            />
          </div>
          <div>
            <label className="text-[11px] font-bold text-gray-500 uppercase">Department</label>
            <select
              value={department}
              onChange={e => setDepartment(e.target.value)}
              className="w-full mt-1 text-xs border border-gray-200 rounded-xl px-3 py-2 bg-white focus:border-primary focus:outline-none"
            >
              <option value="ALL">All Departments</option>
              <option value="SANITATION">Sanitation (स्वच्छता)</option>
              <option value="WATER">Water Supply (पाणी पुरवठा)</option>
              <option value="ROAD">Road Works (रस्ते)</option>
              <option value="GARDEN">Garden & Trees (उद्यान)</option>
              <option value="HEALTH">Health (आरोग्य)</option>
            </select>
          </div>
        </div>
      </div>

      {/* Generated Report Table */}
      <div className="card p-0 overflow-hidden">
        <div className="p-4 bg-gray-50/70 border-b border-gray-200 flex items-center justify-between">
          <p className="text-xs font-bold text-gray-700">
            Results ({reportData.length} records found)
          </p>
          <span className="text-[11px] text-gray-400">
            Filter: {dateFrom} to {dateTo} · {department}
          </span>
        </div>

        <div className="overflow-x-auto">
          {reportType === 'ATTENDANCE' && (
            <table className="w-full text-sm">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Date</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Staff</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Department</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Status</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Punch Times</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Zone Check</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Face Match</th>
                </tr>
              </thead>
              <tbody>
                {loading ? (
                  <tr><td colSpan={7} className="text-center py-10 text-xs text-gray-400">Generating report...</td></tr>
                ) : reportData.length === 0 ? (
                  <tr><td colSpan={7} className="text-center py-10 text-xs text-gray-400">No records found for date range</td></tr>
                ) : (
                  reportData.map(l => (
                    <tr key={l.id} className="border-b border-gray-100 hover:bg-gray-50">
                      <td className="px-4 py-2.5 text-xs text-gray-600">{l.date}</td>
                      <td className="px-4 py-2.5">
                        <p className="text-xs font-bold text-gray-900">{l.staff?.name}</p>
                        <p className="text-[10px] text-gray-400">#{l.staff?.employee_id}</p>
                      </td>
                      <td className="px-4 py-2.5 text-xs text-gray-600">{l.staff?.department}</td>
                      <td className="px-4 py-2.5">
                        <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                          l.status === 'PRESENT' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
                        }`}>
                          {l.status}
                        </span>
                      </td>
                      <td className="px-4 py-2.5 text-xs text-gray-600">
                        {l.checkin_time ? new Date(l.checkin_time).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : '—'}
                      </td>
                      <td className="px-4 py-2.5 text-xs">
                        {l.checkin_within_geofence ? (
                          <span className="text-green-600 font-semibold">✓ In Zone</span>
                        ) : (
                          <span className="text-red-600 font-semibold">⚠ Out of Zone</span>
                        )}
                      </td>
                      <td className="px-4 py-2.5 text-xs font-semibold text-primary">
                        {l.checkin_face_score ? `${Math.round(l.checkin_face_score * 100)}%` : '—'}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          )}

          {reportType === 'TASKS' && (
            <table className="w-full text-sm">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Task</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Assigned</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Priority</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Status</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Created Date</th>
                </tr>
              </thead>
              <tbody>
                {reportData.map(t => (
                  <tr key={t.id} className="border-b border-gray-100 hover:bg-gray-50">
                    <td className="px-4 py-2.5 text-xs font-semibold text-gray-900">{t.title}</td>
                    <td className="px-4 py-2.5 text-xs text-gray-600">{t.assigned_staff?.name || '—'}</td>
                    <td className="px-4 py-2.5 text-xs">{t.priority}</td>
                    <td className="px-4 py-2.5 text-xs font-bold text-primary">{t.status}</td>
                    <td className="px-4 py-2.5 text-xs text-gray-400">{new Date(t.created_at).toLocaleDateString()}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}

          {reportType === 'WARDS' && (
            <table className="w-full text-sm">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Ward</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Date</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Score</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Band</th>
                </tr>
              </thead>
              <tbody>
                {reportData.map(w => (
                  <tr key={w.id} className="border-b border-gray-100 hover:bg-gray-50">
                    <td className="px-4 py-2.5 text-xs font-bold text-gray-900">{w.wards?.ward_name || `Ward ${w.ward_id}`}</td>
                    <td className="px-4 py-2.5 text-xs text-gray-500">{w.date}</td>
                    <td className="px-4 py-2.5 text-sm font-bold text-primary">{w.score}/100</td>
                    <td className="px-4 py-2.5 text-xs">{w.color_band}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}

          {reportType === 'ALERTS' && (
            <table className="w-full text-sm">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Alert Type</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Staff</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Severity</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Message</th>
                  <th className="text-left px-4 py-2.5 text-xs font-semibold text-gray-500">Time</th>
                </tr>
              </thead>
              <tbody>
                {reportData.map(a => (
                  <tr key={a.id} className="border-b border-gray-100 hover:bg-gray-50">
                    <td className="px-4 py-2.5 text-xs font-bold text-gray-900">{a.alert_type}</td>
                    <td className="px-4 py-2.5 text-xs text-gray-600">{a.staff?.name}</td>
                    <td className="px-4 py-2.5 text-xs">{a.severity}</td>
                    <td className="px-4 py-2.5 text-xs text-gray-500">{a.message || '—'}</td>
                    <td className="px-4 py-2.5 text-xs text-gray-400">{new Date(a.created_at).toLocaleString()}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </div>
  );
}
