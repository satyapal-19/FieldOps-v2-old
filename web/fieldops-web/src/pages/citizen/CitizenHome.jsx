import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { Link } from 'react-router-dom';
import { 
  Building2, Search, Send, CheckCircle2, Clock, 
  MapPin, AlertCircle, Camera, Check, ShieldCheck, ArrowRight 
} from 'lucide-react';
import toast from 'react-hot-toast';

export default function CitizenHome() {
  const [wards, setWards] = useState([]);
  const [trackingIdInput, setTrackingIdInput] = useState('');
  const [searchedComplaint, setSearchedComplaint] = useState(null);
  const [searching, setSearching] = useState(false);

  // File complaint form
  const [showForm, setShowForm] = useState(false);
  const [complaintForm, setComplaintForm] = useState({
    name: '',
    phone: '',
    ward_id: '',
    category: 'GARBAGE',
    description: '',
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submittedId, setSubmittedId] = useState(null);

  useEffect(() => {
    loadWards();
  }, []);

  async function loadWards() {
    const { data } = await supabase
      .from('wards')
      .select('id, ward_name, ward_number')
      .order('ward_number');
    setWards(data || []);
  }

  async function handleTrackComplaint(e) {
    e.preventDefault();
    if (!trackingIdInput.trim()) return;

    setSearching(true);
    setSearchedComplaint(null);

    const { data, error } = await supabase
      .from('citizen_complaints')
      .select('*, wards(ward_name), tasks(status, before_photo_url, after_photo_url, completion_note)')
      .eq('tracking_id', trackingIdInput.trim().toUpperCase())
      .single();

    if (error || !data) {
      toast.error('Complaint tracking ID not found');
    } else {
      setSearchedComplaint(data);
    }
    setSearching(false);
  }

  async function handleSubmitComplaint(e) {
    e.preventDefault();
    if (!complaintForm.name || !complaintForm.phone || !complaintForm.ward_id) {
      toast.error('Please fill in your name, phone, and select your ward');
      return;
    }

    setIsSubmitting(true);
    try {
      const generatedId = `SMK-${new Date().getFullYear()}-${Math.floor(1000 + Math.random() * 9000)}`;

      // 1. Insert complaint
      const { data: compData, error: compErr } = await supabase.from('citizen_complaints').insert({
        tracking_id: generatedId,
        name: complaintForm.name,
        phone: complaintForm.phone,
        ward_id: complaintForm.ward_id,
        category: complaintForm.category,
        description: complaintForm.description,
        status: 'RECEIVED',
      }).select().single();

      if (compErr) throw compErr;

      // 2. Auto-generate task for ward field staff
      await supabase.from('tasks').insert({
        title: `[Citizen] ${complaintForm.category}: ${complaintForm.description.slice(0, 40)}`,
        title_mr: `[नागरिक तक्रार] ${complaintForm.category}`,
        description: `Citizen Complaint (${generatedId}): ${complaintForm.description}. Contact: ${complaintForm.name} (${complaintForm.phone})`,
        priority: 'NORMAL',
        status: 'OPEN',
        ward_id: complaintForm.ward_id,
        citizen_complaint_id: compData.id,
      });

      setSubmittedId(generatedId);
      setShowForm(false);
      setComplaintForm({
        name: '',
        phone: '',
        ward_id: '',
        category: 'GARBAGE',
        description: '',
      });
      toast.success('Complaint submitted successfully!');
    } catch (err) {
      toast.error('Failed to submit: ' + err.message);
    } finally {
      setIsSubmitting(false);
    }
  }

  const getStatusStep = (status) => {
    switch (status) {
      case 'RECEIVED': return 1;
      case 'ASSIGNED': return 2;
      case 'IN_PROGRESS': return 3;
      case 'RESOLVED': return 4;
      default: return 1;
    }
  };

  return (
    <div className="min-h-screen bg-[#F7F9F7] flex flex-col font-sans">
      {/* Top Navbar */}
      <header className="bg-primary text-white shadow-md">
        <div className="max-w-6xl mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-white/10 rounded-xl flex items-center justify-center border border-white/20">
              <Building2 className="text-white" size={24} />
            </div>
            <div>
              <h1 className="font-bold text-base leading-tight">SMKMC FieldOps Portal</h1>
              <p className="text-[11px] text-green-200 leading-tight">सांगली मिरज कुपवाड महानगरपालिका</p>
            </div>
          </div>
          <div className="flex items-center gap-3">
            <Link
              to="/login"
              className="text-xs bg-white/15 hover:bg-white/25 px-3 py-1.5 rounded-lg font-semibold transition-colors"
            >
              कर्मचारी लॉगिन (Staff Login)
            </Link>
          </div>
        </div>
      </header>

      {/* Hero Banner */}
      <section className="bg-gradient-to-b from-primary to-[#154a1a] text-white py-12 px-4 text-center">
        <div className="max-w-3xl mx-auto space-y-4">
          <span className="text-xs font-semibold bg-white/15 px-3 py-1 rounded-full uppercase tracking-wider text-green-200">
            Citizen Grievance & Ward Transparency
          </span>
          <h2 className="text-2xl sm:text-3xl font-extrabold tracking-tight">
            स्वच्छ सांगली, सुंदर मिरज, प्रगत कुपवाड
          </h2>
          <p className="text-sm text-green-100 max-w-xl mx-auto">
            नागरिक तक्रार नोंदणी व प्रभाग स्वच्छता पारदर्शकता प्रणाली. आपल्या तक्रारीचे थेट ट्रॅकिंग करा.
          </p>

          {/* Track Complaint Input Box */}
          <div className="pt-4 max-w-md mx-auto">
            <form onSubmit={handleTrackComplaint} className="flex bg-white rounded-2xl p-1.5 shadow-lg">
              <input
                value={trackingIdInput}
                onChange={e => setTrackingIdInput(e.target.value)}
                placeholder="उदा. SMK-2026-1042 तक्रार क्रमांक टाका"
                className="flex-1 px-4 py-2 text-xs sm:text-sm text-gray-800 focus:outline-none rounded-xl"
              />
              <button
                type="submit"
                disabled={searching}
                className="bg-primary hover:bg-primary-dark text-white text-xs sm:text-sm font-semibold px-5 py-2.5 rounded-xl transition-all flex items-center gap-1.5 shadow"
              >
                <Search size={16} /> ट्रॅक करा
              </button>
            </form>
          </div>
        </div>
      </section>

      {/* Main Content Area */}
      <main className="max-w-6xl mx-auto px-4 py-8 flex-1 w-full space-y-8">
        {/* Success Confirmation Badge */}
        {submittedId && (
          <div className="p-4 bg-green-50 border border-green-200 rounded-2xl flex items-center justify-between flex-wrap gap-3">
            <div className="flex items-center gap-3">
              <CheckCircle2 className="text-green-600" size={28} />
              <div>
                <p className="font-bold text-green-950 text-sm">तक्रार यशस्वीपणे नोंदवली गेली आहे!</p>
                <p className="text-xs text-green-800">
                  तुमचा ट्रॅकिंग आयडी: <span className="font-mono font-bold text-sm bg-green-200/60 px-2 py-0.5 rounded">{submittedId}</span>
                </p>
              </div>
            </div>
            <button
              onClick={() => {
                setTrackingIdInput(submittedId);
                setSubmittedId(null);
              }}
              className="text-xs bg-green-700 hover:bg-green-800 text-white font-semibold px-3 py-1.5 rounded-lg"
            >
              आताच ट्रॅक करा
            </button>
          </div>
        )}

        {/* Complaint Tracking Result Card */}
        {searchedComplaint && (
          <div className="card space-y-4 border-2 border-primary/20 shadow-md">
            <div className="flex items-start justify-between flex-wrap gap-2 pb-3 border-b border-gray-100">
              <div>
                <div className="flex items-center gap-2">
                  <h3 className="text-base font-bold text-gray-900">
                    तक्रार: {searchedComplaint.tracking_id}
                  </h3>
                  <span className="text-xs bg-primary-surface text-primary font-bold px-2.5 py-0.5 rounded-full">
                    {searchedComplaint.category}
                  </span>
                </div>
                <p className="text-xs text-gray-500 mt-1">
                  प्रभाग: {searchedComplaint.wards?.ward_name} · नोंदणी: {new Date(searchedComplaint.created_at).toLocaleDateString()}
                </p>
              </div>
              <span className="text-xs font-bold text-green-800 bg-green-100 px-3 py-1 rounded-full">
                {searchedComplaint.status}
              </span>
            </div>

            {/* Stepper */}
            <div className="py-2">
              <div className="flex items-center justify-between text-xs text-gray-600 relative">
                {['प्राप्त (Received)', 'नियुक्त (Assigned)', 'प्रगतीपथावर (In Progress)', 'पूर्ण झाले (Resolved)'].map((step, idx) => {
                  const currentStep = getStatusStep(searchedComplaint.status);
                  const isDone = idx + 1 <= currentStep;
                  return (
                    <div key={step} className="flex flex-col items-center z-10 flex-1">
                      <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs ${
                        isDone ? 'bg-primary text-white' : 'bg-gray-200 text-gray-400'
                      }`}>
                        {isDone ? <Check size={14} /> : idx + 1}
                      </div>
                      <span className={`text-[10px] mt-1 text-center font-medium ${isDone ? 'text-primary font-bold' : 'text-gray-400'}`}>
                        {step}
                      </span>
                    </div>
                  );
                })}
              </div>
            </div>

            <p className="text-xs text-gray-700 bg-gray-50 p-3 rounded-xl">
              <strong>तक्रार तपशील:</strong> {searchedComplaint.description}
            </p>

            {/* Photo verification if available */}
            {searchedComplaint.tasks?.after_photo_url && (
              <div className="space-y-1">
                <p className="text-xs font-bold text-gray-700">कर्मचाऱ्यांनी काम पूर्ण केल्याचा फोटो (Photo Proof):</p>
                <img src={searchedComplaint.tasks.after_photo_url} alt="Resolved" className="w-48 h-32 object-cover rounded-xl border border-gray-200" />
              </div>
            )}
          </div>
        )}

        {/* Action Buttons: Lodge complaint */}
        <div className="flex items-center justify-between flex-wrap gap-4">
          <div>
            <h3 className="text-lg font-bold text-gray-900">नागरिक सेवा केंद्र</h3>
            <p className="text-xs text-gray-500">कचरा, सांडपाणी, रस्ते व पाणी पुरवठा तक्रारी नोंदवा</p>
          </div>
          <button
            onClick={() => setShowForm(!showForm)}
            className="flex items-center gap-2 bg-primary hover:bg-primary-dark text-white px-5 py-2.5 rounded-xl text-sm font-bold shadow transition-all"
          >
            <Send size={16} /> नवीन तक्रार नोंदवा
          </button>
        </div>

        {/* Lodge Complaint Form Card */}
        {showForm && (
          <div className="card space-y-4 border border-primary/20 shadow-md">
            <h4 className="font-bold text-gray-900 text-sm">नवीन नागरिक तक्रार अर्ज</h4>
            <form onSubmit={handleSubmitComplaint} className="space-y-3">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-gray-700">तुमचे नाव (Full Name)</label>
                  <input
                    required
                    value={complaintForm.name}
                    onChange={e => setComplaintForm({ ...complaintForm, name: e.target.value })}
                    placeholder="उदा. सचिन पाटील"
                    className="w-full mt-1 px-3 py-2 text-xs border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                  />
                </div>
                <div>
                  <label className="text-xs font-semibold text-gray-700">मोबाईल क्रमांक (Phone)</label>
                  <input
                    required
                    value={complaintForm.phone}
                    onChange={e => setComplaintForm({ ...complaintForm, phone: e.target.value })}
                    placeholder="9822012345"
                    className="w-full mt-1 px-3 py-2 text-xs border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-gray-700">प्रभाग निवडा (Ward)</label>
                  <select
                    required
                    value={complaintForm.ward_id}
                    onChange={e => setComplaintForm({ ...complaintForm, ward_id: e.target.value })}
                    className="w-full mt-1 px-3 py-2 text-xs border border-gray-200 rounded-xl bg-white focus:border-primary focus:outline-none"
                  >
                    <option value="">प्रभाग निवडा</option>
                    {wards.map(w => (
                      <option key={w.id} value={w.id}>{w.ward_name} (प्रभाग {w.ward_number})</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="text-xs font-semibold text-gray-700">समस्येचा प्रकार (Category)</label>
                  <select
                    value={complaintForm.category}
                    onChange={e => setComplaintForm({ ...complaintForm, category: e.target.value })}
                    className="w-full mt-1 px-3 py-2 text-xs border border-gray-200 rounded-xl bg-white focus:border-primary focus:outline-none"
                  >
                    <option value="GARBAGE">कचरा / Garbage Overflow</option>
                    <option value="DRAIN">सांडपाणी / Clogged Drain</option>
                    <option value="ROAD">खड्डे / Road Repair</option>
                    <option value="WATER">पाणी गळती / Pipeline Leak</option>
                    <option value="LIGHT">पथदिवा बंद / Streetlight Off</option>
                    <option value="OTHER">इतर समस्या / Other</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="text-xs font-semibold text-gray-700">समस्येचा तपशील व ठिकाण (Description & Landmark)</label>
                <textarea
                  required
                  rows={3}
                  value={complaintForm.description}
                  onChange={e => setComplaintForm({ ...complaintForm, description: e.target.value })}
                  placeholder="उदा. दत्त मंदिराच्या मागील बाजूस कचरा साचला आहे..."
                  className="w-full mt-1 px-3 py-2 text-xs border border-gray-200 rounded-xl focus:border-primary focus:outline-none"
                />
              </div>

              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setShowForm(false)}
                  className="px-4 py-2 border border-gray-200 text-gray-600 rounded-xl text-xs hover:bg-gray-50"
                >
                  रद्द करा
                </button>
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="px-5 py-2 bg-primary text-white rounded-xl text-xs font-bold hover:bg-primary-dark shadow transition-all"
                >
                  {isSubmitting ? 'नोंदवत आहे...' : 'तक्रार दाखल करा'}
                </button>
              </div>
            </form>
          </div>
        )}

        {/* Wards Transparency Grid */}
        <div className="space-y-4">
          <div>
            <h3 className="text-lg font-bold text-gray-900">प्रभाग स्वच्छता व सेवा पारदर्शकता (Ward Directory)</h3>
            <p className="text-xs text-gray-500">सांगली, मिरज आणि कुपवाड प्रभागांची आजची स्वच्छता स्थिती व उपस्थिती</p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
            {wards.map((w, idx) => {
              // Deterministic demo score for visual transparency
              const score = 75 + ((idx * 7) % 23);
              const isGreen = score >= 80;
              return (
                <Link
                  key={w.id}
                  to={`/citizen/ward/${w.id}`}
                  className="card hover:shadow-md transition-shadow group space-y-3"
                >
                  <div className="flex items-start justify-between">
                    <div>
                      <h4 className="font-bold text-gray-900 text-sm group-hover:text-primary transition-colors">
                        {w.ward_name}
                      </h4>
                      <span className="text-[11px] text-gray-400">प्रभाग क्र. {w.ward_number}</span>
                    </div>
                    <span className={`text-xs font-extrabold px-2.5 py-0.5 rounded-full ${
                      isGreen ? 'bg-green-100 text-green-800' : 'bg-amber-100 text-amber-800'
                    }`}>
                      {score}/100
                    </span>
                  </div>

                  <div className="w-full bg-gray-100 h-2 rounded-full overflow-hidden">
                    <div className={`h-full rounded-full ${isGreen ? 'bg-green-600' : 'bg-amber-500'}`} style={{ width: `${score}%` }} />
                  </div>

                  <div className="flex items-center justify-between text-[11px] text-gray-500 pt-1 border-t border-gray-100">
                    <span className="text-green-700 font-semibold">✓ हजेरी सक्रिय</span>
                    <span className="flex items-center gap-1 text-primary font-semibold group-hover:translate-x-0.5 transition-transform">
                      तपशील पहा <ArrowRight size={12} />
                    </span>
                  </div>
                </Link>
              );
            })}
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-white border-t border-gray-200 py-6 text-center text-xs text-gray-500 mt-12">
        <p className="font-semibold text-gray-700">सांगली मिरज कुपवाड महानगरपालिका (SMKMC) - फील्ड उपस्थिती व कार्य प्रणाली</p>
        <p className="text-[11px] text-gray-400 mt-1">Hackathon 2026 Solution · Built for Citizen Transparency</p>
      </footer>
    </div>
  );
}
