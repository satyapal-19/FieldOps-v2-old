import { useEffect, useState } from 'react';
import { supabase } from '../../lib/supabase';
import { Users, Plus, Search, Filter, Phone, MapPin, Building, ShieldCheck, RefreshCw } from 'lucide-react';
import toast from 'react-hot-toast';

export default function StaffPage() {
  const [staffList, setStaffList] = useState([]);
  const [wards, setWards] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [deptFilter, setDeptFilter] = useState('ALL');
  const [showAddModal, setShowAddModal] = useState(false);

  // New staff form state
  const [newStaff, setNewStaff] = useState({
    name: '',
    name_mr: '',
    phone: '',
    employee_id: '',
    department: 'SANITATION',
    role: 'STAFF',
    ward_id: '',
    shift: 'MORNING',
    shift_start: '06:00:00',
    shift_end: '14:00:00',
  });

  useEffect(() => {
    loadStaff();
    loadWards();
  }, []);

  async function loadWards() {
    const { data } = await supabase.from('wards').select('id, ward_name, ward_number').order('ward_number');
    setWards(data || []);
  }

  async function loadStaff() {
    setLoading(true);
    const { data, error } = await supabase
      .from('staff')
      .select('*, wards(ward_name, ward_number)')
      .order('name');
    if (!error && data) {
      setStaffList(data);
    }
    setLoading(false);
  }

  async function handleAddStaff(e) {
    e.preventDefault();
    if (!newStaff.name || !newStaff.phone || !newStaff.employee_id) {
      toast.error('Name, phone, and employee ID are required');
      return;
    }

    try {
      const normalizedPhone = newStaff.phone.startsWith('+91') ? newStaff.phone : `+91${newStaff.phone}`;
      const { error } = await supabase.from('staff').insert({
        name: newStaff.name,
        name_mr: newStaff.name_mr || newStaff.name,
        phone: normalizedPhone,
        employee_id: newStaff.employee_id,
        department: newStaff.department,
        role: newStaff.role,
        ward_id: newStaff.ward_id || null,
        shift: newStaff.shift,
        shift_start: newStaff.shift_start,
        shift_end: newStaff.shift_end,
        is_active: true,
      });

      if (error) throw error;
      toast.success('Staff added successfully!');
      setShowAddModal(false);
      setNewStaff({
        name: '',
        name_mr: '',
        phone: '',
        employee_id: '',
        department: 'SANITATION',
        role: 'STAFF',
        ward_id: '',
        shift: 'MORNING',
        shift_start: '06:00:00',
        shift_end: '14:00:00',
      });
      loadStaff();
    } catch (err) {
      toast.error('Failed to add staff: ' + err.message);
    }
  }

  const filteredStaff = staffList.filter(s => {
    const matchesDept = deptFilter === 'ALL' || s.department === deptFilter;
    const matchesSearch = !search ||
      s.name?.toLowerCase().includes(search.toLowerCase()) ||
      s.name_mr?.includes(search) ||
      s.employee_id?.toLowerCase().includes(search.toLowerCase()) ||
      s.phone?.includes(search);
    return matchesDept && matchesSearch;
  });

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between flex-wrap gap-4">
        <div>
          <h1 className="text-xl font-bold text-gray-900 flex items-center gap-2">
            <Users className="text-primary" size={24} />
            Field Staff Directory
          </h1>
          <p className="text-sm text-gray-500 mt-0.5">Manage personnel profiles, shift rosters, and ward assignments</p>
        </div>
        <div className="flex items-center gap-3">
          <button
            onClick={loadStaff}
            className="p-2 border border-gray-200 rounded-xl hover:bg-gray-50 text-gray-600 transition-colors"
          >
            <RefreshCw size={16} />
          </button>
          <button
            onClick={() => setShowAddModal(true)}
            className="flex items-center gap-2 bg-primary hover:bg-primary-dark text-white px-4 py-2 rounded-xl text-sm font-semibold shadow-sm transition-all"
          >
            <Plus size={16} /> Add Personnel
          </button>
        </div>
      </div>

      {/* Filters */}
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div className="flex items-center gap-2 overflow-x-auto pb-1">
          {['ALL', 'SANITATION', 'WATER', 'ROAD', 'GARDEN', 'HEALTH'].map(d => (
            <button
              key={d}
              onClick={() => setDeptFilter(d)}
              className={`text-xs px-3.5 py-1.5 rounded-full font-medium transition-all ${
                deptFilter === d
                  ? 'bg-primary text-white shadow-sm'
                  : 'bg-white border border-gray-200 text-gray-600 hover:border-primary'
              }`}
            >
              {d === 'ALL' ? `All Staff (${staffList.length})` : d}
            </button>
          ))}
        </div>
        <div className="relative min-w-[240px]">
          <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
          <input
            value={search}
            onChange={e => setSearch(e.target.value)}
            placeholder="Search by name, ID or phone..."
            className="w-full pl-9 pr-3 py-1.5 text-xs border border-gray-200 rounded-xl focus:outline-none focus:border-primary"
          />
        </div>
      </div>

      {/* Staff Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {loading ? (
          <div className="col-span-full py-16 text-center text-xs text-gray-400">Loading personnel list...</div>
        ) : filteredStaff.length === 0 ? (
          <div className="col-span-full py-16 text-center text-xs text-gray-400">No personnel found</div>
        ) : (
          filteredStaff.map(s => (
            <div key={s.id} className="card hover:shadow-md transition-shadow space-y-3">
              <div className="flex items-start justify-between">
                <div className="flex items-center gap-3">
                  {s.profile_photo_url ? (
                    <img
                      src={s.profile_photo_url}
                      alt={s.name}
                      className="w-12 h-12 rounded-2xl object-cover border border-gray-200 shadow-sm"
                    />
                  ) : (
                    <div className="w-12 h-12 rounded-2xl bg-primary-surface text-primary flex items-center justify-center font-bold text-lg">
                      {s.name?.charAt(0) || 'S'}
                    </div>
                  )}
                  <div>
                    <h3 className="font-bold text-gray-900 text-sm leading-tight">{s.name}</h3>
                    {s.name_mr && s.name_mr !== s.name && (
                      <p className="text-xs text-gray-500 font-serif leading-tight">{s.name_mr}</p>
                    )}
                    <span className="text-[10px] text-gray-400 font-mono">#{s.employee_id}</span>
                  </div>
                </div>
                <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                  s.role === 'SUPERVISOR' || s.role === 'ADMIN'
                    ? 'bg-purple-100 text-purple-700'
                    : 'bg-green-100 text-green-700'
                }`}>
                  {s.role}
                </span>
              </div>

              <div className="pt-2 border-t border-gray-100 space-y-1.5 text-xs text-gray-600">
                <div className="flex items-center gap-2">
                  <Building size={13} className="text-gray-400 flex-shrink-0" />
                  <span>{s.department}</span>
                </div>
                <div className="flex items-center gap-2">
                  <MapPin size={13} className="text-gray-400 flex-shrink-0" />
                  <span>{s.wards?.ward_name || 'Ward Not Assigned'}</span>
                </div>
                <div className="flex items-center gap-2">
                  <Phone size={13} className="text-gray-400 flex-shrink-0" />
                  <span>{s.phone}</span>
                </div>
              </div>

              <div className="pt-2 flex items-center justify-between text-[11px] text-gray-400">
                <span>Shift: {s.shift} ({s.shift_start?.slice(0, 5)} - {s.shift_end?.slice(0, 5)})</span>
                <span className="flex items-center gap-1 text-green-600 font-semibold">
                  <span className="w-1.5 h-1.5 rounded-full bg-green-500" /> Active
                </span>
              </div>
            </div>
          ))
        )}
      </div>

      {/* Add Personnel Modal */}
      {showAddModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="bg-white rounded-2xl max-w-lg w-full p-6 shadow-xl space-y-4 max-h-[90vh] overflow-y-auto">
            <h2 className="text-lg font-bold text-gray-900">Add Field Personnel</h2>
            <form onSubmit={handleAddStaff} className="space-y-3">
              <div>
                <label className="text-xs font-semibold text-gray-700">Full Name (English)</label>
                <input
                  required
                  value={newStaff.name}
                  onChange={e => setNewStaff({ ...newStaff, name: e.target.value })}
                  placeholder="e.g. Ramesh Shankar Patil"
                  className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                />
              </div>
              <div>
                <label className="text-xs font-semibold text-gray-700">Full Name (Marathi)</label>
                <input
                  value={newStaff.name_mr}
                  onChange={e => setNewStaff({ ...newStaff, name_mr: e.target.value })}
                  placeholder="उदा. रमेश शंकर पाटील"
                  className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-gray-700">Employee ID</label>
                  <input
                    required
                    value={newStaff.employee_id}
                    onChange={e => setNewStaff({ ...newStaff, employee_id: e.target.value })}
                    placeholder="e.g. SMK-1042"
                    className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                  />
                </div>
                <div>
                  <label className="text-xs font-semibold text-gray-700">Mobile Phone</label>
                  <input
                    required
                    value={newStaff.phone}
                    onChange={e => setNewStaff({ ...newStaff, phone: e.target.value })}
                    placeholder="9822012345"
                    className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                  />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-gray-700">Department</label>
                  <select
                    value={newStaff.department}
                    onChange={e => setNewStaff({ ...newStaff, department: e.target.value })}
                    className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                  >
                    <option value="SANITATION">Sanitation (स्वच्छता)</option>
                    <option value="WATER">Water Supply (पाणी पुरवठा)</option>
                    <option value="ROAD">Road Works (रस्ते)</option>
                    <option value="GARDEN">Garden & Trees (उद्यान)</option>
                    <option value="HEALTH">Health (आरोग्य)</option>
                  </select>
                </div>
                <div>
                  <label className="text-xs font-semibold text-gray-700">Role</label>
                  <select
                    value={newStaff.role}
                    onChange={e => setNewStaff({ ...newStaff, role: e.target.value })}
                    className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                  >
                    <option value="STAFF">Field Staff</option>
                    <option value="SUPERVISOR">Ward Supervisor</option>
                    <option value="ADMIN">Corporation Admin</option>
                  </select>
                </div>
              </div>
              <div>
                <label className="text-xs font-semibold text-gray-700">Assigned Ward</label>
                <select
                  value={newStaff.ward_id}
                  onChange={e => setNewStaff({ ...newStaff, ward_id: e.target.value })}
                  className="w-full mt-1 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                >
                  <option value="">No Ward (Unassigned)</option>
                  {wards.map(w => (
                    <option key={w.id} value={w.id}>{w.ward_name} (Ward {w.ward_number})</option>
                  ))}
                </select>
              </div>

              <div className="flex justify-end gap-2 pt-3">
                <button
                  type="button"
                  onClick={() => setShowAddModal(false)}
                  className="px-4 py-2 border border-gray-200 text-gray-600 rounded-xl text-sm hover:bg-gray-50"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 bg-primary text-white rounded-xl text-sm font-semibold hover:bg-primary-dark"
                >
                  Add Personnel
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
