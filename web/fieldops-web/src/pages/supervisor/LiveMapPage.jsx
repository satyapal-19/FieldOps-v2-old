import { useEffect, useState, useRef } from 'react';
import { MapContainer, TileLayer, Marker, Popup, Circle, Polyline, Polygon } from 'react-leaflet';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import { supabase } from '../../lib/supabase';
import { Users, MapPin, RefreshCw } from 'lucide-react';

// Fix Leaflet marker icons in Vite
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-icon-2x.png',
  iconUrl:       'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-icon.png',
  shadowUrl:     'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-shadow.png',
});

const makeIcon = (color) => L.divIcon({
  className: '',
  html: `<div style="width:36px;height:36px;background:${color};border:3px solid white;border-radius:50%;display:flex;align-items:center;justify-content:center;box-shadow:0 2px 8px rgba(0,0,0,0.3)">
    <svg width="16" height="16" fill="white" viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
  </div>`,
  iconSize: [36, 36],
  iconAnchor: [18, 18],
});

const SMKMC_CENTER = [16.8524, 74.5815];
const WCE_CENTER   = [16.8443, 74.6020];
const WCE_POLYGON  = [
  [16.8455, 74.6008],
  [16.8455, 74.6032],
  [16.8431, 74.6032],
  [16.8431, 74.6008],
];

export default function LiveMapPage() {
  const [staffLocations, setStaffLocations] = useState([]);
  const [selectedStaff,  setSelectedStaff]  = useState(null);
  const [pingTrail,      setPingTrail]       = useState([]);
  const [loading,        setLoading]         = useState(true);
  const channelRef = useRef(null);

  useEffect(() => {
    loadLocations();

    // Live location updates via Realtime
    channelRef.current = supabase.channel('live-pings')
      .on('postgres_changes', {
        event: 'INSERT', schema: 'public', table: 'location_pings',
      }, payload => {
        const ping = payload.new;
        setStaffLocations(prev => {
          const idx = prev.findIndex(s => s.staff_id === ping.staff_id);
          if (idx >= 0) {
            const updated = [...prev];
            updated[idx] = { ...updated[idx], lat: ping.lat, lng: ping.lng, last_ping: ping.recorded_at };
            return updated;
          }
          return prev;
        });
      })
      .subscribe();

    return () => channelRef.current?.unsubscribe();
  }, []);

  async function loadLocations() {
    setLoading(true);
    // Get today's latest ping per staff
    const today = new Date().toISOString().slice(0, 10);
    const { data } = await supabase
      .from('location_pings')
      .select('*, staff:staff_id(id, name, name_mr, role, department)')
      .gte('recorded_at', `${today}T00:00:00Z`)
      .order('recorded_at', { ascending: false });

    // Deduplicate — latest ping per staff
    const seen = new Set();
    const latest = (data || []).filter(p => {
      if (seen.has(p.staff_id)) return false;
      seen.add(p.staff_id);
      return true;
    });
    setStaffLocations(latest);
    setLoading(false);
  }

  async function loadPingTrail(staffId) {
    const today = new Date().toISOString().slice(0, 10);
    const { data } = await supabase
      .from('location_pings')
      .select('lat,lng,recorded_at,is_within_ward')
      .eq('staff_id', staffId)
      .gte('recorded_at', `${today}T00:00:00Z`)
      .order('recorded_at');
    setPingTrail((data || []).map(p => [p.lat, p.lng]));
  }

  const onStaffClick = (s) => {
    setSelectedStaff(s);
    loadPingTrail(s.staff_id);
  };

  const getColor = (s) => {
    if (!s.is_within_ward) return '#C62828';
    const minsAgo = (Date.now() - new Date(s.last_ping).getTime()) / 60000;
    if (minsAgo < 15) return '#2E7D32';
    if (minsAgo < 60) return '#F57F17';
    return '#78909C';
  };

  return (
    <div className="flex h-full">
      {/* Sidebar */}
      <div className="w-64 bg-white border-r border-gray-200 flex flex-col overflow-hidden flex-shrink-0">
        <div className="p-4 border-b border-gray-100 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Users size={16} className="text-primary" />
            <span className="text-sm font-semibold">Field Staff</span>
          </div>
          <button onClick={loadLocations} className="text-gray-400 hover:text-primary transition-colors">
            <RefreshCw size={14} />
          </button>
        </div>

        {/* Legend */}
        <div className="px-4 py-2 border-b border-gray-100 flex gap-3 text-[10px] text-gray-500">
          <span className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-green-700 inline-block"/>Active</span>
          <span className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-amber-500 inline-block"/>Idle</span>
          <span className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-red-700 inline-block"/>Out of zone</span>
        </div>

        <div className="flex-1 overflow-y-auto">
          {loading ? (
            <div className="flex justify-center items-center h-24">
              <div className="w-5 h-5 border-2 border-primary border-t-transparent rounded-full animate-spin"/>
            </div>
          ) : staffLocations.length === 0 ? (
            <p className="text-xs text-gray-400 text-center py-8">No staff in field today</p>
          ) : (
            staffLocations.map(s => (
              <button
                key={s.staff_id}
                onClick={() => onStaffClick(s)}
                className={`w-full text-left px-4 py-3 border-b border-gray-50 hover:bg-gray-50 transition-colors ${
                  selectedStaff?.staff_id === s.staff_id ? 'bg-primary-surface' : ''
                }`}
              >
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full flex-shrink-0" style={{ background: getColor(s) }} />
                  <div className="min-w-0">
                    <p className="text-xs font-semibold truncate">{s.staff?.name_mr || s.staff?.name}</p>
                    <p className="text-[10px] text-gray-400">{s.staff?.department}</p>
                  </div>
                </div>
              </button>
            ))
          )}
        </div>

        {/* Selected staff details */}
        {selectedStaff && (
          <div className="border-t border-gray-100 p-4 bg-primary-surface">
            <p className="text-xs font-bold text-primary">{selectedStaff.staff?.name}</p>
            <div className="flex items-center gap-1 mt-1">
              <MapPin size={10} className="text-gray-400" />
              <p className="text-[10px] text-gray-500">{selectedStaff.lat?.toFixed(4)}, {selectedStaff.lng?.toFixed(4)}</p>
            </div>
            <p className="text-[10px] text-gray-400 mt-0.5">
              {new Date(selectedStaff.last_ping).toLocaleTimeString('en-IN')}
            </p>
          </div>
        )}
      </div>

      {/* Map */}
      <div className="flex-1 relative">
        <MapContainer
          center={SMKMC_CENTER}
          zoom={14}
          style={{ height: '100%', width: '100%' }}
        >
          <TileLayer
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            attribution='© OpenStreetMap'
            maxZoom={19}
          />

          {/* SMKMC ward boundary demo circle */}
          <Circle
            center={SMKMC_CENTER}
            radius={1500}
            pathOptions={{ color: '#2E7D32', fillColor: '#2E7D32', fillOpacity: 0.05, weight: 1.5, dashArray: '6,4' }}
          />

          {/* Walchand College of Engineering (WCE) Geofence Polygon */}
          <Polygon
            positions={WCE_POLYGON}
            pathOptions={{ color: '#0052cc', fillColor: '#0052cc', fillOpacity: 0.2, weight: 2.5 }}
          >
            <Popup>
              <div className="text-xs space-y-1">
                <p className="font-bold text-primary">🏛️ Ward 4 — Walchand College (WCE)</p>
                <p className="text-gray-600">Designated Geofence Area (Vishrambag)</p>
                <p className="text-[10px] text-green-700 font-semibold">Assigned Staff: Ramesh Patil</p>
              </div>
            </Popup>
          </Polygon>

          {/* Staff markers */}
          {staffLocations.map(s => (
            <Marker
              key={s.staff_id}
              position={[s.lat, s.lng]}
              icon={makeIcon(getColor(s))}
              eventHandlers={{ click: () => onStaffClick(s) }}
            >
              <Popup>
                <div className="text-xs space-y-1">
                  <p className="font-bold">{s.staff?.name_mr || s.staff?.name}</p>
                  <p className="text-gray-500">{s.staff?.department}</p>
                  <p className={s.is_within_ward ? 'text-green-700' : 'text-red-700'}>
                    {s.is_within_ward ? '✓ In Zone' : '⚠ Out of Zone'}
                  </p>
                  <p className="text-gray-400">{new Date(s.last_ping).toLocaleTimeString('en-IN')}</p>
                </div>
              </Popup>
            </Marker>
          ))}

          {/* Ping trail for selected staff */}
          {pingTrail.length > 1 && (
            <Polyline positions={pingTrail} pathOptions={{ color: '#2E7D32', weight: 3, opacity: 0.7 }} />
          )}
        </MapContainer>
      </div>
    </div>
  );
}
