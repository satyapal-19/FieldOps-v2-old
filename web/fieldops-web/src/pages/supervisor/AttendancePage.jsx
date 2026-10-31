import { useEffect, useState } from 'react';
import { supabase } from '../../lib/supabase';
import { Search, Download, ChevronLeft, ChevronRight, AlertTriangle, Camera, X, CheckCircle2 } from 'lucide-react';
import { format, subDays } from 'date-fns';

const STATUS_STYLES = {
  PRESENT:    'badge-present',
  LATE:       'badge-late',
  ABSENT:     'badge-absent',
  CHECKED_OUT:'badge-present',
};

export default function AttendancePage() {
  const [logs,          setLogs]          = useState([]);
  const [loading,       setLoading]       = useState(true);
  const [date,          setDate]          = useState(new Date().toISOString().slice(0,10));
  const [search,        setSearch]        = useState('');
  const [page,          setPage]          = useState(0);
  const [selectedPhoto, setSelectedPhoto] = useState(null);
  const PAGE_SIZE = 20;

  useEffect(() => { loadLogs(); }, [date]);

  async function loadLogs() {
    setLoading(true);
    const { data } = await supabase
      .from('attendance_logs')
      .select(`
        *,
        staff:staff_id(id, name, name_mr, department, employee_id, shift),
        wards:staff_id(wards(ward_name))
      `)
      .eq('date', date)
      .order('checkin_time', { ascending: true, nullsFirst: false });
    setLogs(data || []);
    setLoading(false);
  }

  const filtered = logs.filter(l =>
    !search ||
    l.staff?.name?.toLowerCase().includes(search.toLowerCase()) ||
    l.staff?.employee_id?.toLowerCase().includes(search.toLowerCase())
  );

  const paginated = filtered.slice(page * PAGE_SIZE, (page + 1) * PAGE_SIZE);
  const totalPages = Math.ceil(filtered.length / PAGE_SIZE);

  function exportCSV() {
    const rows = [
      ['Employee ID','Name','Department','Status','Check-in','Check-out','Late (min)','In Zone','Face Match'],
      ...filtered.map(l => [
        l.staff?.employee_id || '',
        l.staff?.name || '',
        l.staff?.department || '',
        l.status || '',
        l.checkin_time ? format(new Date(l.checkin_time), 'HH:mm:ss') : '',
        l.checkout_time ? format(new Date(l.checkout_time), 'HH:mm:ss') : '',
        l.late_minutes || 0,
        l.checkin_within_geofence ? 'Yes' : 'No',
        l.checkin_face_score ? `${Math.round(l.checkin_face_score * 100)}%` : '',
      ])
    ];
    const csv = rows.map(r => r.join(',')).join('\n');
    const blob = new Blob([csv], { type: 'text/csv' });
    const a = document.createElement('a'); a.href = URL.createObjectURL(blob);
    a.download = `attendance_${date}.csv`; a.click();
  }

  return (
    <div className="p-6 space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between flex-wrap gap-3">
        <h1 className="text-xl font-bold text-gray-900">Attendance</h1>
        <div className="flex items-center gap-2">
          <input type="date" value={date} max={new Date().toISOString().slice(0,10)}
            onChange={e => { setDate(e.target.value); setPage(0); }}
            className="text-sm border border-gray-200 rounded-xl px-3 py-2 focus:outline-none focus:border-primary"
          />
          <button onClick={exportCSV}
            className="flex items-center gap-1.5 text-sm bg-white border border-gray-200 rounded-xl px-3 py-2 hover:bg-gray-50 transition-colors">
            <Download size={14}/> Export
          </button>
        </div>
      </div>

      {/* Summary pills */}
      {!loading && (
        <div className="flex gap-3 flex-wrap">
          {[
            { label: 'Present', count: logs.filter(l=>l.status==='PRESENT').length, cls: 'bg-green-50 text-green-700' },
            { label: 'Late',    count: logs.filter(l=>l.status==='LATE').length,    cls: 'bg-amber-50 text-amber-700' },
            { label: 'Absent',  count: logs.filter(l=>l.status==='ABSENT').length,  cls: 'bg-red-50 text-red-700' },
            { label: 'Suspicious', count: logs.filter(l=>l.is_suspicious).length,   cls: 'bg-orange-50 text-orange-700' },
          ].map(s => (
            <div key={s.label} className={`text-xs font-semibold px-3 py-1.5 rounded-full ${s.cls}`}>
              {s.label}: {s.count}
            </div>
          ))}
        </div>
      )}

      {/* Search */}
      <div className="relative">
        <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"/>
        <input
          value={search} onChange={e => { setSearch(e.target.value); setPage(0); }}
          placeholder="Search by name or employee ID..."
          className="w-full pl-9 pr-4 py-2.5 text-sm border border-gray-200 rounded-xl focus:outline-none focus:border-primary"
        />
      </div>

      {/* Table */}
      <div className="card p-0 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                {['Employee','Department','Status','Check-in','Check-out','Late','Zone','Face','Selfie Proof'].map(h => (
                  <th key={h} className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider whitespace-nowrap">{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={9} className="text-center py-10 text-gray-400 text-xs">Loading...</td></tr>
              ) : paginated.length === 0 ? (
                <tr><td colSpan={9} className="text-center py-10 text-gray-400 text-xs">No records for {date}</td></tr>
              ) : paginated.map(l => (
                <tr key={l.id} className={`border-b border-gray-100 hover:bg-gray-50 transition-colors ${l.is_suspicious ? 'bg-red-50/40' : ''}`}>
                  <td className="px-4 py-3">
                    <div className="flex items-center gap-2">
                      {l.is_suspicious && <AlertTriangle size={12} className="text-orange-500 flex-shrink-0"/>}
                      <div>
                        <p className="font-medium text-gray-900">{l.staff?.name_mr || l.staff?.name}</p>
                        <p className="text-[10px] text-gray-400">{l.staff?.employee_id}</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-4 py-3 text-xs text-gray-500">{l.staff?.department}</td>
                  <td className="px-4 py-3">
                    <span className={STATUS_STYLES[l.status] || 'text-xs text-gray-400'}>{l.status || '—'}</span>
                  </td>
                  <td className="px-4 py-3 text-xs text-gray-700 whitespace-nowrap">
                    {l.checkin_time ? format(new Date(l.checkin_time), 'hh:mm a') : '—'}
                  </td>
                  <td className="px-4 py-3 text-xs text-gray-700 whitespace-nowrap">
                    {l.checkout_time ? format(new Date(l.checkout_time), 'hh:mm a') : '—'}
                  </td>
                  <td className="px-4 py-3 text-xs">
                    {l.late_minutes > 0 ? <span className="text-amber-600 font-medium">+{l.late_minutes}m</span> : <span className="text-green-600">On time</span>}
                  </td>
                  <td className="px-4 py-3">
                    <span className={`text-xs font-medium ${l.checkin_within_geofence ? 'text-green-600' : 'text-red-600'}`}>
                      {l.checkin_within_geofence === null ? '—' : l.checkin_within_geofence ? '✓' : '✗ Out'}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-xs">
                    {l.checkin_face_score != null
                      ? <span className={`font-medium ${l.checkin_face_passed ? 'text-green-600' : 'text-red-600'}`}>
                          {Math.round(l.checkin_face_score * 100)}%
                        </span>
                      : '—'}
                  </td>
                  <td className="px-4 py-3">
                    {l.checkin_photo_url ? (
                      <button
                        onClick={() => setSelectedPhoto(l)}
                        className="group flex items-center gap-1.5 p-1 bg-white border border-gray-200 rounded-lg hover:border-primary hover:shadow-sm transition-all"
                        title="Click to view verified selfie"
                      >
                        <img
                          src={l.checkin_photo_url}
                          alt="Selfie"
                          className="w-8 h-8 rounded-md object-cover"
                        />
                        <span className="text-[10px] font-semibold text-primary group-hover:underline pr-1">View</span>
                      </button>
                    ) : (
                      <span className="text-[10px] text-gray-400 italic">No photo</span>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        {totalPages > 1 && (
          <div className="flex items-center justify-between px-4 py-3 border-t border-gray-100">
            <p className="text-xs text-gray-400">{filtered.length} records</p>
            <div className="flex items-center gap-2">
              <button onClick={() => setPage(p => Math.max(0, p-1))} disabled={page === 0}
                className="p-1 rounded-lg hover:bg-gray-100 disabled:opacity-40 transition-colors">
                <ChevronLeft size={14}/>
              </button>
              <span className="text-xs">{page+1}/{totalPages}</span>
              <button onClick={() => setPage(p => Math.min(totalPages-1, p+1))} disabled={page >= totalPages-1}
                className="p-1 rounded-lg hover:bg-gray-100 disabled:opacity-40 transition-colors">
                <ChevronRight size={14}/>
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Selfie Preview Modal */}
      {selectedPhoto && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-fade-in">
          <div className="bg-white rounded-2xl max-w-sm w-full overflow-hidden shadow-2xl border border-gray-200">
            <div className="flex items-center justify-between p-4 border-b border-gray-100">
              <div className="flex items-center gap-2">
                <Camera size={16} className="text-primary" />
                <h3 className="font-bold text-gray-900 text-sm">Attendance Selfie Proof</h3>
              </div>
              <button
                onClick={() => setSelectedPhoto(null)}
                className="p-1 text-gray-400 hover:text-gray-600 rounded-lg hover:bg-gray-100 transition-colors"
              >
                <X size={16} />
              </button>
            </div>

            <div className="p-4 space-y-4">
              <div className="relative rounded-xl overflow-hidden border border-gray-200 aspect-square bg-gray-100 shadow-inner">
                <img
                  src={selectedPhoto.checkin_photo_url}
                  alt="Verified Selfie"
                  className="w-full h-full object-cover"
                />
                <div className="absolute bottom-2 left-2 right-2 bg-black/75 backdrop-blur-md rounded-lg p-2 text-white text-[11px] flex justify-between items-center">
                  <span>GPS: {selectedPhoto.checkin_lat?.toFixed(4)}, {selectedPhoto.checkin_lng?.toFixed(4)}</span>
                  <span className="flex items-center gap-1 text-green-400 font-semibold">
                    <CheckCircle2 size={12} /> ML Verified
                  </span>
                </div>
              </div>

              <div className="space-y-2 text-xs bg-gray-50 p-3 rounded-xl border border-gray-100">
                <div className="flex justify-between">
                  <span className="text-gray-500">Employee:</span>
                  <span className="font-bold text-gray-900">{selectedPhoto.staff?.name_mr || selectedPhoto.staff?.name}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-500">Employee ID:</span>
                  <span className="font-mono text-gray-700">#{selectedPhoto.staff?.employee_id}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-500">Check-in Time:</span>
                  <span className="text-gray-900 font-medium">
                    {selectedPhoto.checkin_time ? format(new Date(selectedPhoto.checkin_time), 'hh:mm:ss a, dd MMM') : '—'}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-500">Face Match Score:</span>
                  <span className="text-green-700 font-bold">
                    {selectedPhoto.checkin_face_score ? `${Math.round(selectedPhoto.checkin_face_score * 100)}%` : 'N/A'}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-500">Geo-fence:</span>
                  <span className={selectedPhoto.checkin_within_geofence ? 'text-green-700 font-semibold' : 'text-red-700 font-semibold'}>
                    {selectedPhoto.checkin_within_geofence ? '✓ Inside Ward Boundary' : '✗ Outside Boundary'}
                  </span>
                </div>
              </div>
            </div>

            <div className="p-3 bg-gray-50 border-t border-gray-100 flex justify-end">
              <button
                onClick={() => setSelectedPhoto(null)}
                className="px-4 py-2 bg-primary text-white text-xs font-semibold rounded-xl hover:bg-primary-hover transition-colors"
              >
                Done
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
