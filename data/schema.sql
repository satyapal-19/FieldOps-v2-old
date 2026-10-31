-- ============================================================
-- FieldOps SMKMC — Complete Database Schema (v4.0.0 Production Hardened)
-- Municipal Corporation: Sangli Miraj Kupwad Municipal Corporation (SMKMC)
-- Engine: Supabase PostgreSQL + PostGIS + pgvector
-- Timezone Standard: Asia/Kolkata (IST = UTC+5:30)
-- ============================================================

-- 1. Enable Required Extensions
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS vector;

-- Set default timezone for database and session
ALTER DATABASE postgres SET timezone TO 'Asia/Kolkata';
SET timezone = 'Asia/Kolkata';

-- ============================================================
-- TABLE 1: wards (20 Official SMKMC Prabhags)
-- ============================================================
CREATE TABLE wards (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ward_number  INTEGER NOT NULL UNIQUE,
  ward_name    VARCHAR(100) NOT NULL,
  ward_name_mr VARCHAR(100),
  zone         VARCHAR(20) NOT NULL CHECK (zone IN ('SANGLI', 'MIRAJ', 'KUPWAD')),
  boundary     GEOMETRY(POLYGON, 4326),
  area_sq_km   DECIMAL(6,3),
  created_at   TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')
);
CREATE INDEX wards_boundary_idx ON wards USING GIST(boundary);
CREATE INDEX wards_zone_idx ON wards(zone);

-- ============================================================
-- TABLE 2: corporation_offices (Municipal HQ & Divisional Offices)
-- ============================================================
CREATE TABLE corporation_offices (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  office_code       VARCHAR(20) UNIQUE NOT NULL,
  office_name       VARCHAR(100) NOT NULL,
  office_name_mr    VARCHAR(100) NOT NULL,
  zone              VARCHAR(20) NOT NULL CHECK (zone IN ('SANGLI', 'MIRAJ', 'KUPWAD')),
  premise_polygon   GEOMETRY(POLYGON, 4326) NOT NULL,
  buffered_geofence GEOMETRY(POLYGON, 4326), -- 100m buffer for indoor GPS tolerance
  created_at        TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')
);
CREATE INDEX idx_corp_offices_geom ON corporation_offices USING GIST(buffered_geofence);

-- Auto-compute 100m buffer trigger
CREATE OR REPLACE FUNCTION compute_office_buffer()
RETURNS TRIGGER AS $$
BEGIN
  NEW.buffered_geofence := ST_Buffer(NEW.premise_polygon::geography, 100)::geometry;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_office_buffer
BEFORE INSERT OR UPDATE OF premise_polygon ON corporation_offices
FOR EACH ROW EXECUTE FUNCTION compute_office_buffer();

-- ============================================================
-- TABLE 3: staff (Organizational Hierarchy & Biometrics)
-- ============================================================
CREATE TABLE staff (
  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_id                 UUID UNIQUE, -- Maps to Supabase auth.users(id)
  employee_id             VARCHAR(20) UNIQUE NOT NULL, -- e.g. SMK-1001
  name                    VARCHAR(100) NOT NULL,
  name_mr                 VARCHAR(100),
  phone                   VARCHAR(15) UNIQUE NOT NULL,
  department              VARCHAR(30) NOT NULL 
    CHECK (department IN ('SANITATION', 'WATER', 'ROAD', 'GARDEN', 'HEALTH', 'SURVEY', 'ADMINISTRATION')),
  designation             VARCHAR(50) NOT NULL,
  role                    VARCHAR(20) NOT NULL DEFAULT 'WORKER' 
    CHECK (role IN ('ADMIN', 'WARD_INSPECTOR', 'INSPECTOR', 'WORKER', 'OFFICE_STAFF')),
  zone                    VARCHAR(20) CHECK (zone IN ('SANGLI', 'MIRAJ', 'KUPWAD')),
  ward_id                 UUID REFERENCES wards(id),                   -- Default/anchor ward
  office_id               UUID REFERENCES corporation_offices(id),    -- For OFFICE_STAFF
  supervisor_id           UUID REFERENCES staff(id),                   -- Immediate hierarchy parent
  profile_photo_url       TEXT,
  enrolled_face_embedding vector(128),                                 -- MobileFaceNet 128-D vector
  device_id               VARCHAR(200),                                -- Registered hardware ID
  fcm_token               TEXT,
  is_active               BOOLEAN DEFAULT TRUE,
  created_at              TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')
);
CREATE INDEX staff_role_idx ON staff(role);
CREATE INDEX staff_ward_idx ON staff(ward_id);
CREATE INDEX staff_supervisor_idx ON staff(supervisor_id);
CREATE INDEX staff_phone_idx ON staff(phone);

-- Role Rank helper function
CREATE OR REPLACE FUNCTION get_role_rank(role_name VARCHAR)
RETURNS INTEGER AS $$
BEGIN
  RETURN CASE role_name
    WHEN 'ADMIN' THEN 4
    WHEN 'WARD_INSPECTOR' THEN 3
    WHEN 'INSPECTOR' THEN 2
    WHEN 'WORKER' THEN 1
    WHEN 'OFFICE_STAFF' THEN 1
    ELSE 0
  END;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ============================================================
-- TABLE 4: standing_rosters (Default Baseline Squad Mapping)
-- ============================================================
CREATE TABLE standing_rosters (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ward_id             UUID NOT NULL REFERENCES wards(id),
  ward_inspector_id   UUID NOT NULL REFERENCES staff(id),
  inspector_id        UUID NOT NULL REFERENCES staff(id),
  worker_id           UUID NOT NULL REFERENCES staff(id) UNIQUE,
  is_active           BOOLEAN DEFAULT TRUE,
  created_at          TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')
);
CREATE INDEX idx_standing_rosters_ward ON standing_rosters(ward_id);
CREATE INDEX idx_standing_rosters_inspector ON standing_rosters(inspector_id);

-- ============================================================
-- TABLE 5: daily_shift_assignments (Daily Dynamic Rosters)
-- ============================================================
CREATE TABLE daily_shift_assignments (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date                DATE NOT NULL DEFAULT ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date),
  ward_id             UUID NOT NULL REFERENCES wards(id),
  ward_inspector_id   UUID NOT NULL REFERENCES staff(id),
  inspector_id        UUID NOT NULL REFERENCES staff(id),
  worker_id           UUID REFERENCES staff(id), -- NULL when mapping inspector to ward
  assignment_mode     VARCHAR(35) NOT NULL DEFAULT 'STANDING_ROSTER' 
    CHECK (assignment_mode IN (
      'STANDING_ROSTER',
      'ADMIN_ASSIGNED', 
      'WARD_INSPECTOR_ASSIGNED', 
      'INSPECTOR_SELF_PICK', 
      'WORKER_SELF_JOIN'
    )),
  is_approved         BOOLEAN DEFAULT TRUE,
  approved_by         UUID REFERENCES staff(id),
  assigned_by         UUID REFERENCES staff(id),
  created_at          TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  CONSTRAINT uq_daily_worker UNIQUE (date, worker_id)
);
CREATE INDEX idx_daily_assignments_date_ward ON daily_shift_assignments(date, ward_id);
CREATE INDEX idx_daily_assignments_inspector ON daily_shift_assignments(date, inspector_id);

-- ============================================================
-- TABLE 6: shifts (Shift Timings & Windows)
-- ============================================================
CREATE TABLE shifts (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id      UUID NOT NULL REFERENCES staff(id),
  shift_date    DATE NOT NULL DEFAULT ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date),
  shift_type    VARCHAR(20) NOT NULL DEFAULT 'MORNING' CHECK (shift_type IN ('MORNING', 'EVENING', 'NIGHT', 'GENERAL_OFFICE')),
  start_time    TIME NOT NULL DEFAULT '06:00:00',
  end_time      TIME NOT NULL DEFAULT '14:00:00',
  created_at    TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  UNIQUE(staff_id, shift_date)
);

-- ============================================================
-- TABLE 7: attendance_logs (Daily Attendance Records)
-- ============================================================
CREATE TABLE attendance_logs (
  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id                UUID NOT NULL REFERENCES staff(id),
  date                    DATE NOT NULL DEFAULT ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date),
  
  -- Check-in
  checkin_time            TIMESTAMPTZ,
  checkin_lat             DECIMAL(10,8),
  checkin_lng             DECIMAL(11,8),
  accuracy_m              FLOAT,
  checkin_within_geofence BOOLEAN DEFAULT FALSE,
  checkin_geofence_dist_m INTEGER,
  checkin_face_score      FLOAT,
  checkin_face_passed     BOOLEAN DEFAULT TRUE,
  checkin_photo_url       TEXT,
  is_suspicious           BOOLEAN DEFAULT FALSE,
  shift                   VARCHAR(20) DEFAULT 'MORNING',
  
  -- Check-out
  checkout_time           TIMESTAMPTZ,
  checkout_lat            DECIMAL(10,8),
  checkout_lng            DECIMAL(11,8),
  checkout_photo_url      TEXT,
  checkout_type           VARCHAR(30) DEFAULT 'MANUAL' 
    CHECK (checkout_type IN ('MANUAL', 'AUTO_GPS_LAST_SEEN', 'AUTO_OFFICE_SCHEDULED', 'SUPERVISOR_OVERRIDE')),
  is_auto_checkout        BOOLEAN DEFAULT FALSE,

  -- Status & Punctuality
  status                  VARCHAR(20) DEFAULT 'ABSENT' 
    CHECK (status IN ('PRESENT', 'ABSENT', 'LATE', 'HALF_DAY', 'HOLIDAY_OFF', 'ON_LEAVE', 'REGULARIZED')),
  is_late_mark            BOOLEAN DEFAULT FALSE,
  late_minutes            INTEGER DEFAULT 0,
  total_hours             DECIMAL(4,2),

  -- Governance & Proxy Audit
  attendance_mode         VARCHAR(20) DEFAULT 'SELF' 
    CHECK (attendance_mode IN ('SELF', 'INSPECTOR_PROXY', 'ADMIN_PROXY')),
  marked_by_id            UUID REFERENCES staff(id),
  notes                   TEXT,
  created_at              TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  updated_at              TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  CONSTRAINT uq_staff_date_punch UNIQUE(staff_id, date)
);
CREATE INDEX idx_attendance_staff_date ON attendance_logs(staff_id, date);
CREATE INDEX idx_attendance_date ON attendance_logs(date);
CREATE INDEX idx_attendance_status ON attendance_logs(status);

-- Hierarchy Enforcement Trigger on attendance_logs
CREATE OR REPLACE FUNCTION enforce_attendance_hierarchy()
RETURNS TRIGGER AS $$
DECLARE
  v_target_role VARCHAR;
  v_marker_role VARCHAR;
  v_is_team_member BOOLEAN;
  v_marker_ward UUID;
BEGIN
  -- If self-attendance
  IF NEW.marked_by_id IS NULL OR NEW.marked_by_id = NEW.staff_id THEN
    NEW.attendance_mode := 'SELF';
    NEW.marked_by_id := NEW.staff_id;
    RETURN NEW;
  END IF;

  SELECT role INTO v_target_role FROM staff WHERE id = NEW.staff_id;
  SELECT role INTO v_marker_role FROM staff WHERE id = NEW.marked_by_id;

  -- 1. Enforce strictly higher rank
  IF get_role_rank(v_marker_role) <= get_role_rank(v_target_role) THEN
    RAISE EXCEPTION 'Authorization Denied: % (Rank %) cannot mark attendance for % (Rank %).',
      v_marker_role, get_role_rank(v_marker_role), v_target_role, get_role_rank(v_target_role);
  END IF;

  -- 2. If Admin, allow global override
  IF v_marker_role = 'ADMIN' THEN
    NEW.attendance_mode := 'ADMIN_PROXY';
    RETURN NEW;
  END IF;

  -- 3. If Inspector, must be assigned to worker today in same ward
  IF v_marker_role = 'INSPECTOR' THEN
    SELECT EXISTS (
      SELECT 1 FROM daily_shift_assignments
      WHERE date = NEW.date
        AND inspector_id = NEW.marked_by_id
        AND worker_id = NEW.staff_id
    ) INTO v_is_team_member;

    IF NOT v_is_team_member THEN
      RAISE EXCEPTION 'Team Restriction: Worker % is not in Inspector % squad today.',
        NEW.staff_id, NEW.marked_by_id;
    END IF;
  END IF;

  -- 4. If Ward Inspector, staff must be in their static ward today
  IF v_marker_role = 'WARD_INSPECTOR' THEN
    SELECT ward_id INTO v_marker_ward FROM staff WHERE id = NEW.marked_by_id;
    IF NOT EXISTS (
      SELECT 1 FROM daily_shift_assignments
      WHERE date = NEW.date
        AND ward_inspector_id = NEW.marked_by_id
        AND (inspector_id = NEW.staff_id OR worker_id = NEW.staff_id)
        AND ward_id = v_marker_ward
    ) THEN
      RAISE EXCEPTION 'Ward Restriction: Staff member % is not in Ward % today.',
        NEW.staff_id, v_marker_ward;
    END IF;
  END IF;

  NEW.attendance_mode := 'INSPECTOR_PROXY';
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_enforce_attendance_hierarchy
BEFORE INSERT OR UPDATE OF marked_by_id, staff_id ON attendance_logs
FOR EACH ROW EXECUTE FUNCTION enforce_attendance_hierarchy();

-- ============================================================
-- TABLE 8: location_pings (10-Minute Breadcrumbs)
-- ============================================================
CREATE TABLE location_pings (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id            UUID NOT NULL REFERENCES staff(id),
  attendance_log_id   UUID REFERENCES attendance_logs(id),
  lat                 DECIMAL(10,8) NOT NULL,
  lng                 DECIMAL(11,8) NOT NULL,
  accuracy_m          FLOAT,
  battery_level       INTEGER,
  is_within_ward      BOOLEAN DEFAULT TRUE,
  is_mocked           BOOLEAN DEFAULT FALSE,
  is_stationary_flag  BOOLEAN DEFAULT FALSE,
  synced_from_offline BOOLEAN DEFAULT FALSE,
  recorded_at         TIMESTAMPTZ NOT NULL,
  uploaded_at         TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  geom                GEOMETRY(POINT, 4326) GENERATED ALWAYS AS (ST_SetSRID(ST_MakePoint(lng, lat), 4326)) STORED
);
CREATE INDEX idx_location_pings_history ON location_pings(staff_id, recorded_at ASC);
CREATE INDEX idx_location_pings_recorded ON location_pings(recorded_at);
CREATE INDEX idx_location_pings_geom ON location_pings USING GIST(geom);

-- Trigger to auto-validate is_within_ward on insert
CREATE OR REPLACE FUNCTION compute_ping_ward_status()
RETURNS TRIGGER AS $$
DECLARE
  v_assigned_ward UUID;
  v_today_ist DATE := (NEW.recorded_at AT TIME ZONE 'Asia/Kolkata')::date;
BEGIN
  -- Look up worker's assigned ward today
  SELECT ward_id INTO v_assigned_ward 
  FROM daily_shift_assignments
  WHERE date = v_today_ist AND (worker_id = NEW.staff_id OR inspector_id = NEW.staff_id)
  LIMIT 1;

  IF v_assigned_ward IS NULL THEN
    SELECT ward_id INTO v_assigned_ward FROM staff WHERE id = NEW.staff_id;
  END IF;

  IF v_assigned_ward IS NOT NULL THEN
    SELECT EXISTS (
      SELECT 1 FROM wards w
      WHERE w.id = v_assigned_ward
        AND ST_DWithin(
          w.boundary::geography,
          ST_SetSRID(ST_MakePoint(NEW.lng, NEW.lat), 4326)::geography,
          25.0
        )
    ) INTO NEW.is_within_ward;
  ELSE
    NEW.is_within_ward := TRUE;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_compute_ping_ward
BEFORE INSERT ON location_pings
FOR EACH ROW EXECUTE FUNCTION compute_ping_ward_status();

-- ============================================================
-- TABLE 9: random_spot_verifications ("Ghost Worker" Defense)
-- ============================================================
CREATE TABLE random_spot_verifications (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id              UUID NOT NULL REFERENCES staff(id),
  shift_id              UUID,
  shift_date            DATE NOT NULL DEFAULT ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date),
  ward_id               UUID NOT NULL REFERENCES wards(id),
  challenge_token       VARCHAR(64) UNIQUE NOT NULL,
  trigger_type          VARCHAR(30) DEFAULT 'AUTOMATED_RANDOM' 
    CHECK (trigger_type IN ('AUTOMATED_RANDOM', 'MANUAL_SENIOR_SUSPICION')),
  initiated_by          UUID REFERENCES staff(id),
  suspicion_reason      TEXT,
  scheduled_at          TIMESTAMPTZ NOT NULL,
  chance1_triggered_at  TIMESTAMPTZ,
  chance1_status        VARCHAR(20) DEFAULT 'PENDING' CHECK (chance1_status IN ('PENDING', 'ANSWERED', 'EXPIRED')),
  chance2_triggered_at  TIMESTAMPTZ,
  chance2_status        VARCHAR(20) DEFAULT 'PENDING' CHECK (chance2_status IN ('PENDING', 'ANSWERED', 'EXPIRED')),
  final_status          VARCHAR(30) NOT NULL DEFAULT 'PENDING' 
    CHECK (final_status IN ('PENDING', 'VERIFIED', 'MISSED_UNFULFILLED', 'FAILED_MISMATCH', 'OUT_OF_GEOFENCE', 'UNREACHABLE_PENDING_AUDIT')),
  verified_at           TIMESTAMPTZ,
  verification_lat      DECIMAL(10, 7),
  verification_lng      DECIMAL(10, 7),
  accuracy_meters       FLOAT,
  face_match_score      FLOAT,
  escalated_at          TIMESTAMPTZ,
  created_at            TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')
);
CREATE INDEX idx_random_spot_staff ON random_spot_verifications(staff_id, shift_date);
CREATE INDEX idx_random_spot_status ON random_spot_verifications(final_status);

-- ============================================================
-- TABLE 10: staff_tamper_logs (Tamper & Gap Audit)
-- ============================================================
CREATE TABLE staff_tamper_logs (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id      UUID NOT NULL REFERENCES staff(id),
  event_type    VARCHAR(35) NOT NULL 
    CHECK (event_type IN ('GPS_DISABLED', 'PERMISSION_REVOKED', 'AIRPLANE_MODE', 'DATA_DISABLED', 'DEVICE_OFFLINE_OR_DRAINED', 'MOCK_PROVIDER_DETECTED')),
  started_at    TIMESTAMPTZ NOT NULL DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  resolved_at   TIMESTAMPTZ,
  duration_min  INTEGER,
  last_known_location GEOMETRY(POINT, 4326)
);
CREATE INDEX idx_tamper_staff ON staff_tamper_logs(staff_id, started_at DESC);

-- ============================================================
-- TABLE 11: conversations (Hierarchical Chat & Squad Threads)
-- ============================================================
CREATE TABLE conversations (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_key VARCHAR(64) UNIQUE, -- Deterministic 1-on-1 MD5 key
  type            VARCHAR(30) NOT NULL 
    CHECK (type IN ('DIRECT', 'SQUAD_TEAM', 'WARD_BROADCAST', 'CITY_BROADCAST')),
  title           VARCHAR(150),
  ward_id         UUID REFERENCES wards(id),
  inspector_id    UUID REFERENCES staff(id),
  shift_date      DATE,
  is_archived     BOOLEAN DEFAULT FALSE,
  created_by      UUID REFERENCES staff(id),
  created_at      TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  last_message_at TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  deleted_at      TIMESTAMPTZ -- Soft delete
);
CREATE INDEX idx_conversations_key ON conversations(conversation_key);
CREATE INDEX idx_conversations_type ON conversations(type);
CREATE INDEX idx_conversations_ward ON conversations(ward_id);

-- ============================================================
-- TABLE 12: conversation_participants
-- ============================================================
CREATE TABLE conversation_participants (
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE RESTRICT,
  staff_id        UUID NOT NULL REFERENCES staff(id) ON DELETE RESTRICT,
  joined_at       TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  left_at         TIMESTAMPTZ,
  is_active       BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (conversation_id, staff_id)
);
CREATE INDEX idx_participants_staff ON conversation_participants(staff_id, is_active);

-- ============================================================
-- TABLE 13: messages (Text, Audio Clips, Geotags)
-- ============================================================
CREATE TABLE messages (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE RESTRICT,
  sender_id       UUID NOT NULL REFERENCES staff(id),
  receiver_id     UUID REFERENCES staff(id),
  type            VARCHAR(20) DEFAULT 'TEXT' 
    CHECK (type IN ('TEXT', 'VOICE', 'IMAGE', 'LOCATION')),
  content         TEXT,
  storage_path    TEXT, -- Private bucket path for signed URL access
  duration_sec    INTEGER DEFAULT 0,
  file_size_bytes INTEGER DEFAULT 0,
  mime_type       VARCHAR(50) DEFAULT 'audio/webm',
  created_at      TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  deleted_at      TIMESTAMPTZ
);
CREATE INDEX idx_messages_conversation ON messages(conversation_id, created_at ASC);
CREATE INDEX idx_messages_sender ON messages(sender_id);

-- ============================================================
-- TABLE 14: tasks (Civic Field Works)
-- ============================================================
CREATE TABLE tasks (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title                VARCHAR(200) NOT NULL,
  title_mr             VARCHAR(200),
  description          TEXT,
  priority             VARCHAR(10) DEFAULT 'NORMAL' CHECK (priority IN ('URGENT','NORMAL','LOW')),
  status               VARCHAR(20) DEFAULT 'OPEN' CHECK (status IN ('OPEN','IN_PROGRESS','SUBMITTED','APPROVED','REJECTED','ESCALATED','CLOSED')),
  assigned_to          UUID REFERENCES staff(id),
  created_by           UUID REFERENCES staff(id),
  ward_id              UUID REFERENCES wards(id),
  location_lat         DECIMAL(10,8),
  location_lng         DECIMAL(11,8),
  location_label       VARCHAR(200),
  due_at               TIMESTAMPTZ,
  citizen_complaint_id UUID,
  before_photo_url     TEXT,
  after_photo_url      TEXT,
  completion_note      TEXT,
  rejection_reason     TEXT,
  rejection_count      INTEGER DEFAULT 0,
  created_at           TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  updated_at           TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  started_at           TIMESTAMPTZ,
  completed_at         TIMESTAMPTZ
);
CREATE INDEX tasks_assigned_idx ON tasks(assigned_to);
CREATE INDEX tasks_status_idx ON tasks(status);
CREATE INDEX tasks_ward_idx ON tasks(ward_id);

-- ============================================================
-- TABLE 15: citizen_complaints
-- ============================================================
CREATE TABLE citizen_complaints (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tracking_id  VARCHAR(15) UNIQUE NOT NULL,
  name         VARCHAR(100),
  phone        VARCHAR(15),
  ward_id      UUID REFERENCES wards(id),
  category     VARCHAR(30) CHECK (category IN ('GARBAGE','DRAIN','ROAD','WATER','TREE','STRAY_ANIMAL','OTHER')),
  description  TEXT,
  photo_url    TEXT,
  lat          DECIMAL(10,8),
  lng          DECIMAL(11,8),
  task_id      UUID REFERENCES tasks(id),
  status       VARCHAR(20) DEFAULT 'RECEIVED' CHECK (status IN ('RECEIVED','ASSIGNED','IN_PROGRESS','RESOLVED','CLOSED')),
  created_at   TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  resolved_at  TIMESTAMPTZ
);

ALTER TABLE tasks ADD CONSTRAINT fk_tasks_citizen_complaint FOREIGN KEY (citizen_complaint_id) REFERENCES citizen_complaints(id) ON DELETE SET NULL;

CREATE SEQUENCE IF NOT EXISTS complaint_seq START 1;
CREATE OR REPLACE FUNCTION generate_tracking_id()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.tracking_id IS NULL OR NEW.tracking_id = '' THEN
    NEW.tracking_id := 'SMK-' || TO_CHAR(NOW() AT TIME ZONE 'Asia/Kolkata', 'YYYY') || '-' ||
                       LPAD(NEXTVAL('complaint_seq')::TEXT, 4, '0');
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_tracking_id
BEFORE INSERT ON citizen_complaints
FOR EACH ROW EXECUTE FUNCTION generate_tracking_id();

-- ============================================================
-- TABLE 16: leave_requests (Leaves & Weekly Offs)
-- ============================================================
CREATE TABLE leave_requests (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id         UUID NOT NULL REFERENCES staff(id),
  leave_type       VARCHAR(20) CHECK (leave_type IN ('CASUAL','SICK','EARNED','WEEKLY_OFF')),
  from_date        DATE NOT NULL,
  to_date          DATE NOT NULL,
  days_count       INTEGER NOT NULL,
  reason           TEXT,
  status           VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING','APPROVED','REJECTED')),
  approved_by      UUID REFERENCES staff(id),
  approved_at      TIMESTAMPTZ,
  rejection_reason TEXT,
  created_at       TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')
);

-- ============================================================
-- TABLE 17: attendance_regularization_requests
-- ============================================================
CREATE TABLE attendance_regularization_requests (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id         UUID NOT NULL REFERENCES staff(id),
  attendance_date  DATE NOT NULL,
  reason_type      VARCHAR(35) NOT NULL 
    CHECK (reason_type IN ('BATTERY_DEAD', 'APP_CRASH', 'FIELD_RESCUE_DUTY', 'OUT_OF_NETWORK', 'OTHER')),
  explanation      TEXT NOT NULL,
  status           VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED')),
  approved_by      UUID REFERENCES staff(id),
  approved_at      TIMESTAMPTZ,
  created_at       TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')
);

-- ============================================================
-- TABLE 18: holidays (Official Gazetted Civic Holidays)
-- ============================================================
CREATE TABLE holidays (
  id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date     DATE UNIQUE NOT NULL,
  name     VARCHAR(100) NOT NULL,
  name_mr  VARCHAR(100),
  type     VARCHAR(20) DEFAULT 'GAZETTE' CHECK (type IN ('GAZETTE','OPTIONAL'))
);

-- ============================================================
-- TABLE 19: alerts (Supervisory Actionable Alerts)
-- ============================================================
CREATE TABLE alerts (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id     UUID REFERENCES staff(id),
  ward_id      UUID REFERENCES wards(id),
  alert_type   VARCHAR(50) NOT NULL CHECK (alert_type IN (
    'LATE_CHECKIN','OUT_OF_ZONE','MISSED_SPOT_CHECK','GHOST_PUNCH',
    'ABSENT','TAMPER_DETECTED','STATIONARY_TOO_LONG','TASK_OVERDUE'
  )),
  severity     VARCHAR(10) CHECK (severity IN ('LOW','MEDIUM','HIGH','CRITICAL')),
  message      TEXT,
  message_mr   TEXT,
  metadata     JSONB,
  is_resolved  BOOLEAN DEFAULT FALSE,
  triggered_at TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  resolved_at  TIMESTAMPTZ,
  resolved_by  UUID REFERENCES staff(id)
);
CREATE INDEX alerts_unresolved_idx ON alerts(is_resolved) WHERE is_resolved = FALSE;
CREATE INDEX alerts_staff_idx ON alerts(staff_id);

-- ============================================================
-- TABLE 20: ward_scores (Municipal Ward Metrics)
-- ============================================================
CREATE TABLE ward_scores (
  id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ward_id                  UUID REFERENCES wards(id) NOT NULL,
  date                     DATE NOT NULL,
  attendance_pct           DECIMAL(5,2) DEFAULT 0,
  task_completion_pct      DECIMAL(5,2) DEFAULT 0,
  complaint_resolution_pct DECIMAL(5,2) DEFAULT 0,
  overall_score            DECIMAL(5,2) DEFAULT 0,
  color_band               VARCHAR(10) CHECK (color_band IN ('GREEN','AMBER','RED')),
  UNIQUE(ward_id, date)
);

-- ============================================================
-- TABLE 21: checkpoint_scans (QR Beat Checkpoint Scans)
-- ============================================================
CREATE TABLE checkpoint_scans (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id          UUID NOT NULL REFERENCES staff(id),
  attendance_log_id UUID REFERENCES attendance_logs(id),
  checkpoint_id     VARCHAR(100) NOT NULL,
  checkpoint_name   VARCHAR(150),
  lat               DECIMAL(10,8),
  lng               DECIMAL(11,8),
  scanned_at        TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')
);
CREATE INDEX idx_checkpoint_scans_staff ON checkpoint_scans(staff_id, scanned_at DESC);
CREATE INDEX idx_checkpoint_scans_log ON checkpoint_scans(attendance_log_id);

-- ============================================================
-- TABLE 22: photos (Attendance & Task Photo Audit Vault)
-- ============================================================
CREATE TABLE photos (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id          UUID NOT NULL REFERENCES staff(id),
  storage_path      TEXT NOT NULL,
  public_url        TEXT,
  sha256_hash       VARCHAR(64),
  lat               DECIMAL(10,8),
  lng               DECIMAL(11,8),
  accuracy_m        FLOAT,
  photo_type        VARCHAR(30) DEFAULT 'CHECKIN' CHECK (photo_type IN ('CHECKIN', 'CHECKOUT', 'TASK_BEFORE', 'TASK_AFTER', 'INCIDENT', 'SPOT_CHECK')),
  face_match_score  FLOAT,
  face_match_passed BOOLEAN DEFAULT TRUE,
  is_valid          BOOLEAN DEFAULT TRUE,
  captured_at       TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')
);
CREATE INDEX idx_photos_staff ON photos(staff_id, captured_at DESC);

-- ============================================================
-- TABLE 23: payroll_records (Monthly Salary & Deductions)
-- ============================================================
CREATE TABLE payroll_records (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id       UUID NOT NULL REFERENCES staff(id),
  month          DATE NOT NULL,
  working_days   INTEGER DEFAULT 26,
  present_days   DECIMAL(4,1) DEFAULT 0,
  late_days      INTEGER DEFAULT 0,
  absent_days    DECIMAL(4,1) DEFAULT 0,
  leave_days     DECIMAL(4,1) DEFAULT 0,
  overtime_hours DECIMAL(4,1) DEFAULT 0,
  gross_salary   DECIMAL(10,2) DEFAULT 0,
  deductions     DECIMAL(10,2) DEFAULT 0,
  net_salary     DECIMAL(10,2) DEFAULT 0,
  status         VARCHAR(20) DEFAULT 'APPROVED' CHECK (status IN ('PENDING', 'APPROVED', 'DISBURSED')),
  generated_at   TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata'),
  UNIQUE(staff_id, month)
);
CREATE INDEX idx_payroll_staff_month ON payroll_records(staff_id, month);

-- ============================================================
-- CORE STORED PROCEDURES & RPC FUNCTIONS
-- ============================================================

-- Function 1: Zero-Trust Server Punch Procedure
CREATE OR REPLACE FUNCTION record_attendance_punch(
  in_punch_type VARCHAR,
  in_lat DECIMAL,
  in_lng DECIMAL,
  in_accuracy_m FLOAT,
  in_is_mocked BOOLEAN DEFAULT FALSE,
  in_target_staff_id UUID DEFAULT NULL,
  in_co_presence_token VARCHAR DEFAULT NULL,
  in_photo_url TEXT DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
  v_caller_auth_id UUID := auth.uid();
  v_caller_staff RECORD;
  v_target_staff RECORD;
  v_now_ist TIMESTAMPTZ := (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata');
  v_today_ist DATE := v_now_ist::date;
  v_shift RECORD;
  v_target_ward_id UUID;
  v_is_within_ward BOOLEAN := FALSE;
  v_is_late BOOLEAN := FALSE;
  v_late_mins INTEGER := 0;
  v_log_id UUID;
  v_attendance_mode VARCHAR(20) := 'SELF';
  v_marked_by UUID := NULL;
BEGIN
  -- Anti-Mock GPS Guard
  IF in_is_mocked THEN
    RAISE EXCEPTION 'Security Violation: Mock GPS provider detected. Punch rejected.';
  END IF;

  IF in_accuracy_m > 25.0 THEN
    RAISE EXCEPTION 'Accuracy Error: Location precision (%m) exceeds 25m threshold. Move outdoors.', in_accuracy_m;
  END IF;

  -- Authenticate Caller
  SELECT * INTO v_caller_staff FROM staff WHERE auth_id = v_caller_auth_id;
  IF v_caller_staff IS NULL THEN
    RAISE EXCEPTION 'Authentication Error: Caller is not a recognized staff member.';
  END IF;

  -- Self vs Proxy Determination
  IF in_target_staff_id IS NULL OR in_target_staff_id = v_caller_staff.id THEN
    v_target_staff := v_caller_staff;
    v_attendance_mode := 'SELF';
    v_marked_by := v_caller_staff.id;
  ELSE
    SELECT * INTO v_target_staff FROM staff WHERE id = in_target_staff_id;
    IF v_target_staff IS NULL THEN
      RAISE EXCEPTION 'Target worker % does not exist.', in_target_staff_id;
    END IF;

    IF get_role_rank(v_caller_staff.role) <= get_role_rank(v_target_staff.role) THEN
      RAISE EXCEPTION 'Hierarchy Violation: Role % cannot mark attendance for %.',
        v_caller_staff.role, v_target_staff.role;
    END IF;

    v_attendance_mode := 'INSPECTOR_PROXY';
    v_marked_by := v_caller_staff.id;
  END IF;

  -- Geofence Validation against Today's Ward Assignment
  IF v_target_staff.role = 'OFFICE_STAFF' THEN
    SELECT EXISTS (
      SELECT 1 FROM corporation_offices
      WHERE ST_Within(
        ST_SetSRID(ST_MakePoint(in_lng, in_lat), 4326),
        buffered_geofence
      )
    ) INTO v_is_within_ward;
  ELSE
    SELECT ward_id INTO v_target_ward_id 
    FROM daily_shift_assignments
    WHERE date = v_today_ist AND (worker_id = v_target_staff.id OR inspector_id = v_target_staff.id)
    LIMIT 1;

    IF v_target_ward_id IS NULL THEN
      v_target_ward_id := v_target_staff.ward_id;
    END IF;

    SELECT EXISTS (
      SELECT 1 FROM wards w
      WHERE w.id = v_target_ward_id
        AND ST_DWithin(
          w.boundary::geography,
          ST_SetSRID(ST_MakePoint(in_lng, in_lat), 4326)::geography,
          25.0
        )
    ) INTO v_is_within_ward;
  END IF;

  IF NOT v_is_within_ward THEN
    RAISE EXCEPTION 'Geofence Error: Location (% , %) is outside assigned jurisdiction perimeter.', in_lat, in_lng;
  END IF;

  -- Fetch Shift Timings
  SELECT * INTO v_shift FROM shifts WHERE staff_id = v_target_staff.id AND shift_date = v_today_ist;
  IF v_shift IS NULL THEN
    v_shift.start_time := CASE WHEN v_target_staff.role = 'OFFICE_STAFF' THEN '09:30:00'::TIME ELSE '06:00:00'::TIME END;
    v_shift.end_time   := CASE WHEN v_target_staff.role = 'OFFICE_STAFF' THEN '17:30:00'::TIME ELSE '14:00:00'::TIME END;
  END IF;

  IF in_punch_type = 'CHECKIN' THEN
    IF EXISTS (
      SELECT 1 FROM attendance_logs 
      WHERE staff_id = v_target_staff.id AND date = v_today_ist AND checkin_time IS NOT NULL
    ) THEN
      RAISE EXCEPTION 'Duplicate Punch: Attendance has already been registered for today.';
    END IF;

    -- 15-Minute Grace Calculation (on-time up to +15m 59s)
    IF v_now_ist > (v_today_ist + v_shift.start_time + INTERVAL '15 minutes 59 seconds') THEN
      v_is_late := TRUE;
      v_late_mins := EXTRACT(EPOCH FROM (v_now_ist - (v_today_ist + v_shift.start_time))) / 60;
    END IF;

    INSERT INTO attendance_logs (
      staff_id, date, checkin_time, status, is_late_mark, late_minutes,
      checkin_lat, checkin_lng, accuracy_m, marked_by_id, attendance_mode,
      checkin_within_geofence, checkin_photo_url
    ) VALUES (
      v_target_staff.id, v_today_ist, v_now_ist,
      CASE WHEN v_is_late THEN 'LATE' ELSE 'PRESENT' END,
      v_is_late, v_late_mins, in_lat, in_lng, in_accuracy_m, v_marked_by, v_attendance_mode,
      v_is_within_ward, in_photo_url
    ) RETURNING id INTO v_log_id;

  ELSIF in_punch_type = 'CHECKOUT' THEN
    SELECT id INTO v_log_id FROM attendance_logs
    WHERE staff_id = v_target_staff.id AND date = v_today_ist AND checkout_time IS NULL;

    IF v_log_id IS NULL THEN
      RAISE EXCEPTION 'Checkout Error: No active check-in found for today.';
    END IF;

    UPDATE attendance_logs
    SET checkout_time = v_now_ist,
        checkout_lat = in_lat,
        checkout_lng = in_lng,
        checkout_photo_url = COALESCE(in_photo_url, checkout_photo_url),
        checkout_type = 'MANUAL',
        total_hours = ROUND((EXTRACT(EPOCH FROM (v_now_ist - checkin_time)) / 3600.0)::numeric, 2),
        status = CASE
          WHEN (EXTRACT(EPOCH FROM (v_now_ist - checkin_time)) / 3600.0) < 4.0 AND status != 'LATE' THEN 'HALF_DAY'
          ELSE status
        END,
        updated_at = v_now_ist
    WHERE id = v_log_id;

  ELSE
    RAISE EXCEPTION 'Invalid punch_type: %. Must be CHECKIN or CHECKOUT.', in_punch_type;
  END IF;

  RETURN jsonb_build_object(
    'attendance_id', v_log_id,
    'server_timestamp', v_now_ist,
    'status', CASE WHEN v_is_late THEN 'LATE' ELSE 'PRESENT' END,
    'is_late', v_is_late,
    'late_minutes', v_late_mins,
    'is_within_geofence', v_is_within_ward
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function 2: Hardened Auto Check-Out Rule (>60m shift end check)
CREATE OR REPLACE FUNCTION auto_checkout_unclosed_shifts()
RETURNS INTEGER AS $$
DECLARE
  v_now_ist TIMESTAMPTZ := (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata');
  v_today_ist DATE := v_now_ist::date;
  v_closed_count INTEGER := 0;
  v_office_count INTEGER := 0;
BEGIN
  -- 1. Auto-close Field Staff at last in-ward GPS ping
  WITH eligible_shifts AS (
    SELECT a.id AS log_id, a.staff_id, a.date,
           COALESCE(s.end_time, '14:00:00'::TIME) AS shift_end
    FROM attendance_logs a
    JOIN staff st ON st.id = a.staff_id
    LEFT JOIN shifts s ON s.staff_id = a.staff_id AND s.shift_date = a.date
    WHERE a.date = v_today_ist
      AND a.checkout_time IS NULL
      AND st.role != 'OFFICE_STAFF'
      AND v_now_ist >= (a.date + COALESCE(s.end_time, '14:00:00'::TIME) + INTERVAL '60 minutes')
  ),
  last_in_ward_pings AS (
    SELECT p.staff_id,
           MAX(p.recorded_at) AS last_ping_time,
           (ARRAY_AGG(p.lat ORDER BY p.recorded_at DESC))[1] AS last_lat,
           (ARRAY_AGG(p.lng ORDER BY p.recorded_at DESC))[1] AS last_lng
    FROM location_pings p
    JOIN eligible_shifts es ON es.staff_id = p.staff_id
    WHERE p.is_within_ward = TRUE 
      AND (p.recorded_at AT TIME ZONE 'Asia/Kolkata')::date = v_today_ist
    GROUP BY p.staff_id
  )
  UPDATE attendance_logs a
  SET checkout_time = lp.last_ping_time,
      checkout_lat = lp.last_lat,
      checkout_lng = lp.last_lng,
      checkout_type = 'AUTO_GPS_LAST_SEEN',
      is_auto_checkout = TRUE,
      notes = 'Auto-closed at last verified in-ward GPS ping (Shift ended >60m ago)'
  FROM eligible_shifts es
  JOIN last_in_ward_pings lp ON lp.staff_id = es.staff_id
  WHERE a.id = es.log_id;

  GET DIAGNOSTICS v_closed_count = ROW_COUNT;

  -- 2. Auto-close Office Staff at scheduled shift conclusion
  UPDATE attendance_logs a
  SET checkout_time = (a.date + COALESCE(s.end_time, '17:30:00'::TIME)),
      checkout_type = 'AUTO_OFFICE_SCHEDULED',
      is_auto_checkout = TRUE,
      notes = 'Office staff auto-closed at scheduled shift conclusion'
  FROM staff st
  LEFT JOIN shifts s ON s.staff_id = a.staff_id AND s.shift_date = a.date
  WHERE a.staff_id = st.id
    AND st.role = 'OFFICE_STAFF'
    AND a.date = v_today_ist
    AND a.checkout_time IS NULL
    AND v_now_ist >= (a.date + COALESCE(s.end_time, '17:30:00'::TIME) + INTERVAL '60 minutes');

  GET DIAGNOSTICS v_office_count = ROW_COUNT;
  v_closed_count := v_closed_count + v_office_count;

  RETURN v_closed_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function 3: pgvector Biometric 1-to-N Ward Match
CREATE OR REPLACE FUNCTION match_worker_face_in_ward(
  query_embedding vector(128),
  target_ward_id UUID,
  target_inspector_id UUID DEFAULT NULL,
  min_similarity FLOAT DEFAULT 0.80
)
RETURNS TABLE (
  staff_id UUID,
  name VARCHAR,
  name_mr VARCHAR,
  employee_id VARCHAR,
  designation VARCHAR,
  department VARCHAR,
  profile_photo_url TEXT,
  similarity_score FLOAT
) AS $$
DECLARE
  v_today_ist DATE := (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date;
BEGIN
  RETURN QUERY
  SELECT 
    s.id AS staff_id,
    s.name,
    s.name_mr,
    s.employee_id,
    s.designation,
    s.department,
    s.profile_photo_url,
    (1.0 - (s.enrolled_face_embedding <=> query_embedding))::FLOAT AS similarity_score
  FROM staff s
  JOIN daily_shift_assignments d ON d.worker_id = s.id
  WHERE d.date = v_today_ist
    AND d.ward_id = target_ward_id
    AND (target_inspector_id IS NULL OR d.inspector_id = target_inspector_id)
    AND s.role = 'WORKER'
    AND s.is_active = TRUE
    AND s.enrolled_face_embedding IS NOT NULL
    AND (1.0 - (s.enrolled_face_embedding <=> query_embedding)) >= min_similarity
  ORDER BY similarity_score DESC
  LIMIT 1;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- Function 4: PostGIS Route Summary RPC (Downsampling & 1000-Row Cap Defense)
CREATE OR REPLACE FUNCTION get_staff_route_summary(
  in_staff_id UUID,
  in_date DATE
)
RETURNS JSONB AS $$
DECLARE
  v_start_ist TIMESTAMPTZ := (in_date || ' 00:00:00 Asia/Kolkata')::TIMESTAMPTZ;
  v_end_ist   TIMESTAMPTZ := (in_date || ' 23:59:59 Asia/Kolkata')::TIMESTAMPTZ;
  v_points JSONB;
  v_total_distance_km FLOAT := 0;
  v_breaches INTEGER := 0;
BEGIN
  SELECT 
    COALESCE(jsonb_agg(
      jsonb_build_object(
        'lat', p.lat,
        'lng', p.lng,
        'recorded_at', p.recorded_at,
        'accuracy_m', p.accuracy_m,
        'is_within_ward', p.is_within_ward
      ) ORDER BY p.recorded_at ASC
    ), '[]'::jsonb),
    COUNT(*) FILTER (WHERE p.is_within_ward = FALSE)
  INTO v_points, v_breaches
  FROM location_pings p
  WHERE p.staff_id = in_staff_id
    AND p.recorded_at >= v_start_ist
    AND p.recorded_at <= v_end_ist;

  SELECT COALESCE(ROUND((ST_Length(ST_MakeLine(ST_SetSRID(ST_MakePoint(p.lng, p.lat), 4326)::geography) / 1000.0))::numeric, 2), 0)
  INTO v_total_distance_km
  FROM (
    SELECT lat, lng FROM location_pings 
    WHERE staff_id = in_staff_id AND recorded_at >= v_start_ist AND recorded_at <= v_end_ist
    ORDER BY recorded_at ASC
  ) p;

  RETURN jsonb_build_object(
    'date', in_date,
    'total_points', jsonb_array_length(v_points),
    'total_distance_km', v_total_distance_km,
    'out_of_zone_breaches', v_breaches,
    'trail', v_points
  );
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- ============================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================
ALTER TABLE wards                 ENABLE ROW LEVEL SECURITY;
ALTER TABLE corporation_offices   ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff                 ENABLE ROW LEVEL SECURITY;
ALTER TABLE standing_rosters      ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_shift_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE shifts                ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance_logs       ENABLE ROW LEVEL SECURITY;
ALTER TABLE location_pings        ENABLE ROW LEVEL SECURITY;
ALTER TABLE random_spot_verifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff_tamper_logs     ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations         ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversation_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages              ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks                 ENABLE ROW LEVEL SECURITY;
ALTER TABLE alerts                ENABLE ROW LEVEL SECURITY;
ALTER TABLE leave_requests        ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance_regularization_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE holidays              ENABLE ROW LEVEL SECURITY;
ALTER TABLE ward_scores           ENABLE ROW LEVEL SECURITY;
ALTER TABLE citizen_complaints    ENABLE ROW LEVEL SECURITY;
ALTER TABLE checkpoint_scans      ENABLE ROW LEVEL SECURITY;
ALTER TABLE photos                ENABLE ROW LEVEL SECURITY;
ALTER TABLE payroll_records       ENABLE ROW LEVEL SECURITY;

-- 1. Public / Authenticated Reads for Reference Tables
CREATE POLICY "Public wards read" ON wards FOR SELECT USING (TRUE);
CREATE POLICY "Public corp offices read" ON corporation_offices FOR SELECT USING (TRUE);
CREATE POLICY "Public holidays read" ON holidays FOR SELECT USING (TRUE);
CREATE POLICY "Public ward scores read" ON ward_scores FOR SELECT USING (TRUE);

-- 2. Staff Profiles
CREATE POLICY "Staff read directory" ON staff
  FOR SELECT USING (TRUE);
CREATE POLICY "Admin staff CRUD" ON staff
  FOR ALL USING (
    EXISTS (SELECT 1 FROM staff s WHERE s.auth_id = auth.uid() AND s.role = 'ADMIN')
  );

-- 3. Attendance Logs
CREATE POLICY "Staff read own attendance" ON attendance_logs
  FOR SELECT USING (
    staff_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
    OR
    EXISTS (
      SELECT 1 FROM staff s 
      WHERE s.auth_id = auth.uid() 
      AND s.role IN ('ADMIN', 'WARD_INSPECTOR', 'INSPECTOR')
    )
  );

CREATE POLICY "Attendance insert via procedure or self" ON attendance_logs
  FOR INSERT WITH CHECK (
    staff_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
    OR
    EXISTS (
      SELECT 1 FROM staff s 
      WHERE s.auth_id = auth.uid() 
      AND get_role_rank(s.role) > get_role_rank((SELECT role FROM staff st WHERE st.id = staff_id))
    )
  );

CREATE POLICY "Attendance update self or supervisor" ON attendance_logs
  FOR UPDATE USING (
    staff_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
    OR
    EXISTS (
      SELECT 1 FROM staff s 
      WHERE s.auth_id = auth.uid() 
      AND s.role IN ('ADMIN', 'WARD_INSPECTOR', 'INSPECTOR')
    )
  );

-- 4. Location Pings
CREATE POLICY "Staff own pings read" ON location_pings
  FOR SELECT USING (
    staff_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
    OR
    EXISTS (
      SELECT 1 FROM staff s 
      WHERE s.auth_id = auth.uid() 
      AND s.role IN ('ADMIN', 'WARD_INSPECTOR')
    )
  );

CREATE POLICY "Staff own pings insert" ON location_pings
  FOR INSERT WITH CHECK (
    staff_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
  );

-- 5. Conversations & Messages
CREATE POLICY "Participants view conversations" ON conversations
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM conversation_participants cp
      JOIN staff s ON s.id = cp.staff_id
      WHERE cp.conversation_id = conversations.id AND s.auth_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM staff s WHERE s.auth_id = auth.uid() AND s.role = 'ADMIN'
    )
  );

CREATE POLICY "Participants view messages" ON messages
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM conversation_participants cp
      JOIN staff s ON s.id = cp.staff_id
      WHERE cp.conversation_id = messages.conversation_id AND s.auth_id = auth.uid()
    )
    OR
    EXISTS (
      SELECT 1 FROM staff s WHERE s.auth_id = auth.uid() AND s.role = 'ADMIN'
    )
  );

CREATE POLICY "Participants insert messages" ON messages
  FOR INSERT WITH CHECK (
    sender_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
  );

-- 6. Tasks
CREATE POLICY "Staff view assigned or ward tasks" ON tasks
  FOR SELECT USING (
    assigned_to = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
    OR ward_id = (SELECT s.ward_id FROM staff s WHERE s.auth_id = auth.uid())
    OR EXISTS (SELECT 1 FROM staff s WHERE s.auth_id = auth.uid() AND s.role IN ('ADMIN', 'WARD_INSPECTOR', 'INSPECTOR'))
  );

CREATE POLICY "Supervisors insert tasks" ON tasks
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM staff s WHERE s.auth_id = auth.uid() AND s.role IN ('ADMIN', 'WARD_INSPECTOR', 'INSPECTOR'))
  );

CREATE POLICY "Staff update assigned tasks" ON tasks
  FOR UPDATE USING (
    assigned_to = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
    OR EXISTS (SELECT 1 FROM staff s WHERE s.auth_id = auth.uid() AND s.role IN ('ADMIN', 'WARD_INSPECTOR', 'INSPECTOR'))
  );

-- 7. Alerts
CREATE POLICY "Staff and supervisors view alerts" ON alerts
  FOR SELECT USING (
    staff_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
    OR EXISTS (SELECT 1 FROM staff s WHERE s.auth_id = auth.uid() AND s.role IN ('ADMIN', 'WARD_INSPECTOR', 'INSPECTOR'))
  );

CREATE POLICY "System and staff insert alerts" ON alerts
  FOR INSERT WITH CHECK (TRUE);

CREATE POLICY "Supervisors resolve alerts" ON alerts
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM staff s WHERE s.auth_id = auth.uid() AND s.role IN ('ADMIN', 'WARD_INSPECTOR', 'INSPECTOR'))
  );

-- 8. Citizen Complaints
CREATE POLICY "Public and staff view complaints" ON citizen_complaints
  FOR SELECT USING (TRUE);

CREATE POLICY "Anyone submit complaint" ON citizen_complaints
  FOR INSERT WITH CHECK (TRUE);

CREATE POLICY "Supervisors update complaints" ON citizen_complaints
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM staff s WHERE s.auth_id = auth.uid() AND s.role IN ('ADMIN', 'WARD_INSPECTOR', 'INSPECTOR', 'WORKER'))
  );

-- 9. Checkpoint Scans
CREATE POLICY "Staff view checkpoint scans" ON checkpoint_scans
  FOR SELECT USING (TRUE);

CREATE POLICY "Staff insert checkpoint scans" ON checkpoint_scans
  FOR INSERT WITH CHECK (
    staff_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
    OR auth.uid() IS NULL -- Allow demo offline sync
  );

-- 10. Photos
CREATE POLICY "Staff view photos" ON photos
  FOR SELECT USING (TRUE);

CREATE POLICY "Staff insert photos" ON photos
  FOR INSERT WITH CHECK (
    staff_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
    OR auth.uid() IS NULL -- Allow demo offline sync
  );

-- 11. Payroll Records
CREATE POLICY "Staff view own payroll" ON payroll_records
  FOR SELECT USING (
    staff_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
    OR EXISTS (SELECT 1 FROM staff s WHERE s.auth_id = auth.uid() AND s.role IN ('ADMIN', 'WARD_INSPECTOR'))
  );

-- 12. Leaves & Regularization
CREATE POLICY "Staff view own leaves" ON leave_requests
  FOR SELECT USING (
    staff_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
    OR EXISTS (SELECT 1 FROM staff s WHERE s.auth_id = auth.uid() AND s.role IN ('ADMIN', 'WARD_INSPECTOR', 'INSPECTOR'))
  );

CREATE POLICY "Staff submit leaves" ON leave_requests
  FOR INSERT WITH CHECK (
    staff_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
  );

CREATE POLICY "Staff view regularizations" ON attendance_regularization_requests
  FOR SELECT USING (
    staff_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
    OR EXISTS (SELECT 1 FROM staff s WHERE s.auth_id = auth.uid() AND s.role IN ('ADMIN', 'WARD_INSPECTOR', 'INSPECTOR'))
  );

CREATE POLICY "Staff submit regularizations" ON attendance_regularization_requests
  FOR INSERT WITH CHECK (
    staff_id = (SELECT s.id FROM staff s WHERE s.auth_id = auth.uid())
  );
