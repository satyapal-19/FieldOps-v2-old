import { useEffect, useState } from 'react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../hooks/useAuth';
import { 
  CheckSquare, Plus, Clock, MapPin, User, AlertCircle, 
  CheckCircle, XCircle, Search, Filter, RefreshCw, Eye
} from 'lucide-react';
import toast from 'react-hot-toast';

export default function TasksPage() {
  const { staff } = useAuth();
  const [tasks, setTasks] = useState([]);
  const [staffList, setStaffList] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('ALL');
  const [search, setSearch] = useState('');
  
  // Modals
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [selectedTask, setSelectedTask] = useState(null);
  
  // New task form state
  const [newTask, setNewTask] = useState({
    title: '',
    title_mr: '',
    description: '',
    priority: 'NORMAL',
    assigned_to: '',
    location_label: '',
    due_at: '',
  });

  useEffect(() => {
    loadTasks();
    loadStaffList();
  }, []);

  async function loadStaffList() {
    const { data } = await supabase
      .from('staff')
      .select('id, name, name_mr, department, employee_id')
      .eq('is_active', true)
      .order('name');
    setStaffList(data || []);
  }

  async function loadTasks() {
    setLoading(true);
    let query = supabase
      .from('tasks')
      .select(`
        *,
        assigned_staff:assigned_to(id, name, name_mr, employee_id),
        creator:created_by(id, name),
        wards(ward_name)
      `)
      .order('created_at', { ascending: false });

    const { data, error } = await query;
    if (!error && data) {
      setTasks(data);
    }
    setLoading(false);
  }

  async function handleCreateTask(e) {
    e.preventDefault();
    if (!newTask.title || !newTask.assigned_to) {
      toast.error('Title and assigned staff are required');
      return;
    }

    try {
      const { error } = await supabase.from('tasks').insert({
        title: newTask.title,
        title_mr: newTask.title_mr || newTask.title,
        description: newTask.description,
        priority: newTask.priority,
        status: 'OPEN',
        assigned_to: newTask.assigned_to,
        created_by: staff?.id,
        ward_id: staff?.ward_id,
        location_label: newTask.location_label,
        due_at: newTask.due_at ? new Date(newTask.due_at).toISOString() : null,
      });

      if (error) throw error;
      toast.success('Task created successfully!');
      setShowCreateModal(false);
      setNewTask({
        title: '',
        title_mr: '',
        description: '',
        priority: 'NORMAL',
        assigned_to: '',
        location_label: '',
        due_at: '',
      });
      loadTasks();
    } catch (err) {
      toast.error('Failed to create task: ' + err.message);
    }
  }

  async function handleReviewTask(taskId, status, reason = '') {
    try {
      const { error } = await supabase.from('tasks').update({
        status,
        rejection_reason: reason,
        completed_at: status === 'APPROVED' ? new Date().toISOString() : null,
      }).eq('id', taskId);

      if (error) throw error;
      toast.success(status === 'APPROVED' ? 'Task Approved ✓' : 'Task Rejected');
      setSelectedTask(null);
      loadTasks();
    } catch (err) {
      toast.error('Action failed: ' + err.message);
    }
  }

  const filteredTasks = tasks.filter(t => {
    const matchesFilter = filter === 'ALL' ? true : t.status === filter;
    const matchesSearch = !search || 
      t.title?.toLowerCase().includes(search.toLowerCase()) ||
      t.assigned_staff?.name?.toLowerCase().includes(search.toLowerCase()) ||
      t.location_label?.toLowerCase().includes(search.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  const getPriorityBadge = (p) => {
    switch (p) {
      case 'URGENT': return <span className="bg-red-100 text-red-700 text-xs font-bold px-2 py-0.5 rounded-full">🔴 Urgent</span>;
      case 'NORMAL': return <span className="bg-amber-100 text-amber-700 text-xs font-semibold px-2 py-0.5 rounded-full">🟡 Normal</span>;
      default: return <span className="bg-green-100 text-green-700 text-xs font-medium px-2 py-0.5 rounded-full">🟢 Low</span>;
    }
  };

  const getStatusBadge = (s) => {
    switch (s) {
      case 'OPEN': return <span className="bg-gray-100 text-gray-700 text-xs px-2.5 py-1 rounded-full font-medium">Open</span>;
      case 'IN_PROGRESS': return <span className="bg-blue-100 text-blue-700 text-xs px-2.5 py-1 rounded-full font-medium">In Progress</span>;
      case 'SUBMITTED': return <span className="bg-purple-100 text-purple-700 text-xs px-2.5 py-1 rounded-full font-bold">Needs Review</span>;
      case 'APPROVED': return <span className="bg-green-100 text-green-700 text-xs px-2.5 py-1 rounded-full font-medium">Approved ✓</span>;
      case 'REJECTED': return <span className="bg-red-100 text-red-700 text-xs px-2.5 py-1 rounded-full font-medium">Rejected ✗</span>;
      default: return <span className="bg-gray-100 text-gray-700 text-xs px-2.5 py-1 rounded-full">{s}</span>;
    }
  };

  return (
    <div className="p-6 space-y-6">
      {/* Top Header */}
      <div className="flex items-center justify-between flex-wrap gap-4">
        <div>
          <h1 className="text-xl font-bold text-gray-900 flex items-center gap-2">
            <CheckSquare className="text-primary" size={24} />
            Task Management
          </h1>
          <p className="text-sm text-gray-500 mt-0.5">Assign, track, and verify field work across wards</p>
        </div>
        <div className="flex items-center gap-3">
          <button 
            onClick={loadTasks} 
            className="p-2 border border-gray-200 rounded-xl hover:bg-gray-50 text-gray-600 transition-colors"
            title="Refresh"
          >
            <RefreshCw size={16} />
          </button>
          <button
            onClick={() => setShowCreateModal(true)}
            className="flex items-center gap-2 bg-primary hover:bg-primary-dark text-white px-4 py-2 rounded-xl text-sm font-semibold transition-all shadow-sm"
          >
            <Plus size={16} /> Create Task
          </button>
        </div>
      </div>

      {/* Filter Tabs & Search */}
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div className="flex items-center gap-2 overflow-x-auto pb-1">
          {['ALL', 'OPEN', 'IN_PROGRESS', 'SUBMITTED', 'APPROVED', 'REJECTED'].map(f => (
            <button
              key={f}
              onClick={() => setFilter(f)}
              className={`text-xs px-3.5 py-1.5 rounded-full font-medium transition-all ${
                filter === f 
                  ? 'bg-primary text-white shadow-sm' 
                  : 'bg-white border border-gray-200 text-gray-600 hover:border-primary'
              }`}
            >
              {f === 'ALL' ? `All (${tasks.length})` : f.replace('_', ' ')}
            </button>
          ))}
        </div>
        <div className="relative min-w-[240px]">
          <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search task or staff..."
            className="w-full pl-9 pr-3 py-1.5 text-xs border border-gray-200 rounded-xl focus:outline-none focus:border-primary"
          />
        </div>
      </div>

      {/* Tasks Table / Grid */}
      <div className="card p-0 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Priority</th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Task Title</th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Assigned To</th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Location</th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Due Time</th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Status</th>
                <th className="text-center px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">Actions</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={7} className="text-center py-12 text-gray-400 text-xs">Loading tasks...</td></tr>
              ) : filteredTasks.length === 0 ? (
                <tr><td colSpan={7} className="text-center py-12 text-gray-400 text-xs">No tasks found</td></tr>
              ) : (
                filteredTasks.map(t => (
                  <tr key={t.id} className="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3">{getPriorityBadge(t.priority)}</td>
                    <td className="px-4 py-3">
                      <div>
                        <p className="font-semibold text-gray-900">{t.title}</p>
                        {t.title_mr && t.title_mr !== t.title && (
                          <p className="text-xs text-gray-500 font-serif">{t.title_mr}</p>
                        )}
                        {t.description && (
                          <p className="text-xs text-gray-400 truncate max-w-xs">{t.description}</p>
                        )}
                      </div>
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-2">
                        <div className="w-6 h-6 rounded-full bg-primary-surface text-primary flex items-center justify-center text-xs font-bold">
                          {t.assigned_staff?.name?.charAt(0) || 'S'}
                        </div>
                        <span className="text-xs text-gray-700 font-medium">{t.assigned_staff?.name || 'Unassigned'}</span>
                      </div>
                    </td>
                    <td className="px-4 py-3 text-xs text-gray-600">
                      {t.location_label ? (
                        <span className="flex items-center gap-1"><MapPin size={12} className="text-gray-400" />{t.location_label}</span>
                      ) : '—'}
                    </td>
                    <td className="px-4 py-3 text-xs text-gray-600 whitespace-nowrap">
                      {t.due_at ? new Date(t.due_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: true }) : '—'}
                    </td>
                    <td className="px-4 py-3">{getStatusBadge(t.status)}</td>
                    <td className="px-4 py-3 text-center">
                      <button
                        onClick={() => setSelectedTask(t)}
                        className="inline-flex items-center gap-1 text-xs text-primary hover:text-primary-dark font-semibold bg-primary-surface px-2.5 py-1.5 rounded-lg transition-colors"
                      >
                        <Eye size={12} /> View
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Create Task Modal */}
      {showCreateModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="bg-white rounded-2xl max-w-lg w-full p-6 shadow-xl space-y-4">
            <h2 className="text-lg font-bold text-gray-900">Create New Field Task</h2>
            <form onSubmit={handleCreateTask} className="space-y-3">
              <div>
                <label className="text-xs font-semibold text-gray-700">Task Title (English)</label>
                <input
                  required
                  value={newTask.title}
                  onChange={e => setNewTask({ ...newTask, title: e.target.value })}
                  placeholder="e.g. Clear clogged storm drain near Datta Chowk"
                  className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                />
              </div>
              <div>
                <label className="text-xs font-semibold text-gray-700">Task Title (Marathi)</label>
                <input
                  value={newTask.title_mr}
                  onChange={e => setNewTask({ ...newTask, title_mr: e.target.value })}
                  placeholder="उदा. दत्त चौक जवळील गटार स्वच्छता"
                  className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-gray-700">Priority</label>
                  <select
                    value={newTask.priority}
                    onChange={e => setNewTask({ ...newTask, priority: e.target.value })}
                    className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                  >
                    <option value="LOW">Low</option>
                    <option value="NORMAL">Normal</option>
                    <option value="URGENT">Urgent 🔴</option>
                  </select>
                </div>
                <div>
                  <label className="text-xs font-semibold text-gray-700">Assign To Staff</label>
                  <select
                    required
                    value={newTask.assigned_to}
                    onChange={e => setNewTask({ ...newTask, assigned_to: e.target.value })}
                    className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                  >
                    <option value="">Select Staff</option>
                    {staffList.map(s => (
                      <option key={s.id} value={s.id}>{s.name} ({s.department})</option>
                    ))}
                  </select>
                </div>
              </div>
              <div>
                <label className="text-xs font-semibold text-gray-700">Location Label</label>
                <input
                  value={newTask.location_label}
                  onChange={e => setNewTask({ ...newTask, location_label: e.target.value })}
                  placeholder="e.g. Ward 12, Market Gate 2"
                  className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                />
              </div>
              <div>
                <label className="text-xs font-semibold text-gray-700">Due By (Date & Time)</label>
                <input
                  type="datetime-local"
                  value={newTask.due_at}
                  onChange={e => setNewTask({ ...newTask, due_at: e.target.value })}
                  className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                />
              </div>
              <div>
                <label className="text-xs font-semibold text-gray-700">Description / Instructions</label>
                <textarea
                  rows={3}
                  value={newTask.description}
                  onChange={e => setNewTask({ ...newTask, description: e.target.value })}
                  placeholder="Enter detailed instructions for field staff..."
                  className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                />
              </div>

              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setShowCreateModal(false)}
                  className="px-4 py-2 border border-gray-200 text-gray-600 rounded-xl text-sm hover:bg-gray-50"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 bg-primary text-white rounded-xl text-sm font-semibold hover:bg-primary-dark"
                >
                  Create Task
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Task Review / Detail Modal */}
      {selectedTask && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="bg-white rounded-2xl max-w-lg w-full p-6 shadow-xl space-y-4 max-h-[90vh] overflow-y-auto">
            <div className="flex items-start justify-between">
              <div>
                <div className="flex items-center gap-2">
                  <h2 className="text-lg font-bold text-gray-900">{selectedTask.title}</h2>
                  {getPriorityBadge(selectedTask.priority)}
                </div>
                {selectedTask.title_mr && <p className="text-xs text-gray-500 font-serif">{selectedTask.title_mr}</p>}
              </div>
              {getStatusBadge(selectedTask.status)}
            </div>

            <div className="p-3 bg-gray-50 rounded-xl space-y-1 text-xs text-gray-600">
              <p><strong>Assigned:</strong> {selectedTask.assigned_staff?.name}</p>
              <p><strong>Location:</strong> {selectedTask.location_label || '—'}</p>
              {selectedTask.description && <p><strong>Instructions:</strong> {selectedTask.description}</p>}
            </div>

            {/* Before & After Photo Comparison */}
            <div className="space-y-2">
              <p className="text-xs font-bold text-gray-700">Photo Proofs</p>
              <div className="grid grid-cols-2 gap-3">
                <div className="border border-gray-200 rounded-xl p-2 text-center">
                  <p className="text-[10px] font-bold text-gray-500 uppercase mb-1">Before Work</p>
                  {selectedTask.before_photo_url ? (
                    <img src={selectedTask.before_photo_url} alt="Before" className="w-full h-32 object-cover rounded-lg" />
                  ) : (
                    <div className="w-full h-32 bg-gray-100 rounded-lg flex items-center justify-center text-xs text-gray-400">
                      No Photo
                    </div>
                  )}
                </div>
                <div className="border border-gray-200 rounded-xl p-2 text-center">
                  <p className="text-[10px] font-bold text-gray-500 uppercase mb-1">After Work</p>
                  {selectedTask.after_photo_url ? (
                    <img src={selectedTask.after_photo_url} alt="After" className="w-full h-32 object-cover rounded-lg" />
                  ) : (
                    <div className="w-full h-32 bg-gray-100 rounded-lg flex items-center justify-center text-xs text-gray-400">
                      Pending
                    </div>
                  )}
                </div>
              </div>
            </div>

            {selectedTask.completion_note && (
              <div className="p-3 bg-green-50 text-green-900 rounded-xl text-xs">
                <strong>Completion Note:</strong> {selectedTask.completion_note}
              </div>
            )}

            {/* Supervisor Actions */}
            <div className="flex justify-end gap-2 pt-4 border-t border-gray-100">
              <button
                type="button"
                onClick={() => setSelectedTask(null)}
                className="px-4 py-2 border border-gray-200 text-gray-600 rounded-xl text-sm hover:bg-gray-50"
              >
                Close
              </button>
              {selectedTask.status === 'SUBMITTED' && (
                <>
                  <button
                    onClick={() => handleReviewTask(selectedTask.id, 'REJECTED', 'Need better photo proof')}
                    className="flex items-center gap-1.5 px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-xl text-sm font-semibold"
                  >
                    <XCircle size={14} /> Reject
                  </button>
                  <button
                    onClick={() => handleReviewTask(selectedTask.id, 'APPROVED')}
                    className="flex items-center gap-1.5 px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-xl text-sm font-semibold"
                  >
                    <CheckCircle size={14} /> Approve & Close
                  </button>
                </>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
