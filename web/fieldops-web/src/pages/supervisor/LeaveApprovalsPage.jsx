import { useEffect, useState } from 'react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../hooks/useAuth';
import { Calendar, CheckCircle2, XCircle, Clock, Search, RefreshCw, User } from 'lucide-react';
import toast from 'react-hot-toast';

export default function LeaveApprovalsPage() {
  const { staff } = useAuth();
  const [leaves, setLeaves] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('PENDING'); // PENDING | ALL | APPROVED | REJECTED
  const [search, setSearch] = useState('');

  useEffect(() => {
    loadLeaves();
  }, []);

  async function loadLeaves() {
    setLoading(true);
    const { data, error } = await supabase
      .from('leave_requests')
      .select('*, staff:staff_id(id, name, name_mr, department, employee_id, role)')
      .order('created_at', { ascending: false });

    if (!error && data) {
      setLeaves(data);
    }
    setLoading(false);
  }

  async function handleAction(leaveId, status, rejectionReason = '') {
    try {
      const { error } = await supabase
        .from('leave_requests')
        .update({
          status,
          approved_by: staff?.id,
          approved_at: new Date().toISOString(),
          rejection_reason: rejectionReason || null,
        })
        .eq('id', leaveId);

      if (error) throw error;
      toast.success(status === 'APPROVED' ? 'Leave Approved ✓' : 'Leave Rejected');
      loadLeaves();
    } catch (err) {
      toast.error('Failed to update leave: ' + err.message);
    }
  }

  const filteredLeaves = leaves.filter(l => {
    const matchesFilter = filter === 'ALL' ? true : l.status === filter;
    const matchesSearch = !search ||
      l.staff?.name?.toLowerCase().includes(search.toLowerCase()) ||
      l.staff?.employee_id?.toLowerCase().includes(search.toLowerCase()) ||
      l.reason?.toLowerCase().includes(search.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  const getStatusBadge = (s) => {
    switch (s) {
      case 'PENDING':
        return <span className="bg-amber-100 text-amber-700 text-xs px-2.5 py-1 rounded-full font-bold">Pending ⏳</span>;
      case 'APPROVED':
        return <span className="bg-green-100 text-green-700 text-xs px-2.5 py-1 rounded-full font-bold">Approved ✓</span>;
      case 'REJECTED':
        return <span className="bg-red-100 text-red-700 text-xs px-2.5 py-1 rounded-full font-bold">Rejected ✗</span>;
      default:
        return <span className="bg-gray-100 text-gray-700 text-xs px-2.5 py-1 rounded-full">{s}</span>;
    }
  };

  const getLeaveTypeBadge = (t) => {
    switch (t) {
      case 'CASUAL': return <span className="bg-blue-50 text-blue-700 px-2 py-0.5 rounded text-xs font-semibold">Casual (CL)</span>;
      case 'SICK': return <span className="bg-orange-50 text-orange-700 px-2 py-0.5 rounded text-xs font-semibold">Sick (SL)</span>;
      case 'EARNED': return <span className="bg-emerald-50 text-emerald-700 px-2 py-0.5 rounded text-xs font-semibold">Earned (EL)</span>;
      default: return <span className="bg-gray-100 text-gray-700 px-2 py-0.5 rounded text-xs">{t}</span>;
    }
  };

  const pendingCount = leaves.filter(l => l.status === 'PENDING').length;

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between flex-wrap gap-4">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-xl font-bold text-gray-900 flex items-center gap-2">
              <Calendar className="text-primary" size={24} />
              Leave Approvals
            </h1>
            {pendingCount > 0 && (
              <span className="bg-amber-500 text-white text-xs font-bold px-2.5 py-0.5 rounded-full">
                {pendingCount} Pending
              </span>
            )}
          </div>
          <p className="text-sm text-gray-500 mt-0.5">Review and manage field staff leave applications</p>
        </div>
        <button
          onClick={loadLeaves}
          className="flex items-center gap-1.5 text-xs text-gray-600 bg-white border border-gray-200 px-3 py-2 rounded-xl hover:bg-gray-50 transition-colors"
        >
          <RefreshCw size={14} /> Refresh
        </button>
      </div>

      {/* Filter Tabs & Search */}
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div className="flex items-center gap-2">
          {['PENDING', 'ALL', 'APPROVED', 'REJECTED'].map(f => (
            <button
              key={f}
              onClick={() => setFilter(f)}
              className={`text-xs px-3.5 py-1.5 rounded-full font-medium transition-all ${
                filter === f
                  ? 'bg-primary text-white shadow-sm'
                  : 'bg-white border border-gray-200 text-gray-600 hover:border-primary'
              }`}
            >
              {f === 'PENDING' ? `Pending (${pendingCount})` : f}
            </button>
          ))}
        </div>
        <div className="relative min-w-[240px]">
          <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
          <input
            value={search}
            onChange={e => setSearch(e.target.value)}
            placeholder="Search staff or reason..."
            className="w-full pl-9 pr-3 py-1.5 text-xs border border-gray-200 rounded-xl focus:outline-none focus:border-primary"
          />
        </div>
      </div>

      {/* Leave Requests Table */}
      <div className="card p-0 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Staff Member</th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Leave Type</th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Duration</th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Days</th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Reason</th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Status</th>
                <th className="text-center px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Actions</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={7} className="text-center py-12 text-gray-400 text-xs">Loading leave requests...</td></tr>
              ) : filteredLeaves.length === 0 ? (
                <tr><td colSpan={7} className="text-center py-12 text-gray-400 text-xs">No leave requests found</td></tr>
              ) : (
                filteredLeaves.map(l => (
                  <tr key={l.id} className="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3">
                      <div>
                        <p className="font-semibold text-gray-900">{l.staff?.name_mr || l.staff?.name}</p>
                        <p className="text-[11px] text-gray-400">#{l.staff?.employee_id} · {l.staff?.department}</p>
                      </div>
                    </td>
                    <td className="px-4 py-3">{getLeaveTypeBadge(l.leave_type)}</td>
                    <td className="px-4 py-3 text-xs text-gray-600 whitespace-nowrap">
                      {l.from_date} to {l.to_date}
                    </td>
                    <td className="px-4 py-3">
                      <span className="font-bold text-xs text-gray-800">{l.days_count} d</span>
                    </td>
                    <td className="px-4 py-3 text-xs text-gray-600 max-w-xs truncate">
                      {l.reason || '—'}
                    </td>
                    <td className="px-4 py-3">{getStatusBadge(l.status)}</td>
                    <td className="px-4 py-3 text-center">
                      {l.status === 'PENDING' ? (
                        <div className="flex items-center justify-center gap-1.5">
                          <button
                            onClick={() => handleAction(l.id, 'APPROVED')}
                            className="inline-flex items-center gap-1 bg-green-600 hover:bg-green-700 text-white text-xs font-semibold px-2.5 py-1.5 rounded-lg transition-colors"
                          >
                            <CheckCircle2 size={13} /> Approve
                          </button>
                          <button
                            onClick={() => handleAction(l.id, 'REJECTED', 'Duty requirements')}
                            className="inline-flex items-center gap-1 bg-red-600 hover:bg-red-700 text-white text-xs font-semibold px-2.5 py-1.5 rounded-lg transition-colors"
                          >
                            <XCircle size={13} /> Reject
                          </button>
                        </div>
                      ) : (
                        <span className="text-xs text-gray-400">Processed</span>
                      )}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
