-- ============================================================
-- FieldOps SMKMC — Production-Grade Seed Dataset (v4.0.0 Hardened)
-- Municipal Corporation: Sangli Miraj Kupwad Municipal Corporation (SMKMC)
-- Coordinates Centered on Sangli-Miraj-Kupwad Triangle: ~16.85° N, 74.58° E
-- ============================================================

-- 0. SAFE ENVIRONMENT PURGE
TRUNCATE 
  attendance_logs, 
  location_pings, 
  tasks, 
  alerts, 
  messages, 
  conversation_participants, 
  conversations, 
  leave_requests, 
  attendance_regularization_requests, 
  staff_tamper_logs, 
  random_spot_verifications, 
  daily_shift_assignments, 
  standing_rosters, 
  shifts, 
  staff, 
  corporation_offices, 
  wards,
  citizen_complaints,
  ward_scores,
  holidays,
  checkpoint_scans,
  photos,
  payroll_records
CASCADE;

-- ============================================================
-- 1. 20 OFFICIAL SMKMC WARDS / PRABHAGS
-- ============================================================
INSERT INTO wards (id, ward_number, ward_name, ward_name_mr, zone, area_sq_km, boundary) VALUES
-- Sangli Zone (Wards 1 to 10)
('11111111-0000-0000-0000-000000000001', 1,  'Ward 1 - Haripur & Krishna Ghat', 'प्रभाग १ - हरिपूर व कृष्णा घाट', 'SANGLI', 3.20,
 ST_GeomFromText('POLYGON((74.550 16.840, 74.565 16.840, 74.565 16.855, 74.550 16.855, 74.550 16.840))', 4326)),
('11111111-0000-0000-0000-000000000002', 2,  'Ward 2 - Ganpati Peth & Rajwada', 'प्रभाग २ - गणपती पेठ व राजवाडा', 'SANGLI', 2.10,
 ST_GeomFromText('POLYGON((74.565 16.845, 74.580 16.845, 74.580 16.860, 74.565 16.860, 74.565 16.845))', 4326)),
('11111111-0000-0000-0000-000000000003', 3,  'Ward 3 - Gaonbhag & Central Market', 'प्रभाग ३ - गावभाग व मध्यवर्ती मंडई', 'SANGLI', 2.45,
 ST_GeomFromText('POLYGON((74.575 16.850, 74.590 16.850, 74.590 16.865, 74.575 16.865, 74.575 16.850))', 4326)),
('11111111-0000-0000-0000-000000000004', 4,  'Ward 4 - Vishrambag & Walchand College', 'प्रभाग ४ - विश्रामबाग व वालचंद कॉलेज', 'SANGLI', 3.80,
 ST_GeomFromText('POLYGON((74.595 16.840, 74.615 16.840, 74.615 16.860, 74.595 16.860, 74.595 16.840))', 4326)),
('11111111-0000-0000-0000-000000000005', 5,  'Ward 5 - Civil Hospital & ST Stand', 'प्रभाग ५ - सिव्हिल हॉस्पिटल व बस स्टँड', 'SANGLI', 2.60,
 ST_GeomFromText('POLYGON((74.580 16.855, 74.595 16.855, 74.595 16.870, 74.580 16.870, 74.580 16.855))', 4326)),
('11111111-0000-0000-0000-000000000006', 6,  'Ward 6 - Khanapur Road & Neminathnagar', 'प्रभाग ६ - खानापूर रोड व नेमिनाथनगर', 'SANGLI', 3.10,
 ST_GeomFromText('POLYGON((74.570 16.865, 74.590 16.865, 74.590 16.880, 74.570 16.880, 74.570 16.865))', 4326)),
('11111111-0000-0000-0000-000000000007', 7,  'Ward 7 - Gulmohar Colony & 100ft Road', 'प्रभाग ७ - गुलमोहर कॉलनी व १०० फुटी रस्ता', 'SANGLI', 2.90,
 ST_GeomFromText('POLYGON((74.590 16.860, 74.610 16.860, 74.610 16.875, 74.590 16.875, 74.590 16.860))', 4326)),
('11111111-0000-0000-0000-000000000008', 8,  'Ward 8 - Shinde Mala & Vijayanagar', 'प्रभाग ८ - शिंदे मळा व विजयनगर', 'SANGLI', 3.40,
 ST_GeomFromText('POLYGON((74.605 16.855, 74.625 16.855, 74.625 16.870, 74.605 16.870, 74.605 16.855))', 4326)),
('11111111-0000-0000-0000-000000000009', 9,  'Ward 9 - Chandni Chowk & Madhavnagar Rd', 'प्रभाग ९ - चांदणी चौक व माधवनगर रोड', 'SANGLI', 3.00,
 ST_GeomFromText('POLYGON((74.580 16.870, 74.600 16.870, 74.600 16.885, 74.580 16.885, 74.580 16.870))', 4326)),
('11111111-0000-0000-0000-000000000010', 10, 'Ward 10 - Sangliwadi & Riverfront', 'प्रभाग १० - सांगलीवाडी व नदीकाठ', 'SANGLI', 3.50,
 ST_GeomFromText('POLYGON((74.545 16.850, 74.565 16.850, 74.565 16.865, 74.545 16.865, 74.545 16.850))', 4326)),

-- Miraj Zone (Wards 11 to 16)
('11111111-0000-0000-0000-000000000011', 11, 'Ward 11 - Miraj Railway Station & Rest House', 'प्रभाग ११ - मिरज रेल्वे स्टेशन व विश्रामगृह', 'MIRAJ', 2.80,
 ST_GeomFromText('POLYGON((74.630 16.820, 74.650 16.820, 74.650 16.835, 74.630 16.835, 74.630 16.820))', 4326)),
('11111111-0000-0000-0000-000000000012', 12, 'Ward 12 - Brahmanpuri & Ganpati Galli', 'प्रभाग १२ - ब्राह्मणपुरी व गणपती गल्ली', 'MIRAJ', 2.20,
 ST_GeomFromText('POLYGON((74.640 16.835, 74.655 16.835, 74.655 16.850, 74.640 16.850, 74.640 16.835))', 4326)),
('11111111-0000-0000-0000-000000000013', 13, 'Ward 13 - Gandhi Chowk & Shani Mandir', 'प्रभाग १३ - गांधी चौक व शनी मंदिर', 'MIRAJ', 2.15,
 ST_GeomFromText('POLYGON((74.645 16.825, 74.660 16.825, 74.660 16.840, 74.645 16.840, 74.645 16.825))', 4326)),
('11111111-0000-0000-0000-000000000014', 14, 'Ward 14 - Mission Compound & Wanless Hospital', 'प्रभाग १४ - मिशन कंपाउंड व वानलेस हॉस्पिटल', 'MIRAJ', 3.10,
 ST_GeomFromText('POLYGON((74.635 16.840, 74.655 16.840, 74.655 16.855, 74.635 16.855, 74.635 16.840))', 4326)),
('11111111-0000-0000-0000-000000000015', 15, 'Ward 15 - Khasbag & Dargah Mohalla', 'प्रभाग १५ - खासबाग व दर्गा मोहल्ला', 'MIRAJ', 2.75,
 ST_GeomFromText('POLYGON((74.650 16.830, 74.670 16.830, 74.670 16.845, 74.650 16.845, 74.650 16.830))', 4326)),
('11111111-0000-0000-0000-000000000016', 16, 'Ward 16 - Shivaji Road & Kisan Chowk', 'प्रभाग १६ - शिवाजी रोड व किसान चौक', 'MIRAJ', 3.30,
 ST_GeomFromText('POLYGON((74.655 16.840, 74.675 16.840, 74.675 16.860, 74.655 16.860, 74.655 16.840))', 4326)),

-- Kupwad Zone (Wards 17 to 20)
('11111111-0000-0000-0000-000000000017', 17, 'Ward 17 - Kupwad MIDC Industrial Belt', 'प्रभाग १७ - कुपवाड एमआयडीसी औद्योगिक क्षेत्र', 'KUPWAD', 5.20,
 ST_GeomFromText('POLYGON((74.600 16.870, 74.630 16.870, 74.630 16.895, 74.600 16.895, 74.600 16.870))', 4326)),
('11111111-0000-0000-0000-000000000018', 18, 'Ward 18 - Kupwad Gaonthan & Grampanchayat', 'प्रभाग १८ - कुपवाड गावठाण व जुनी ग्रामपंचायत', 'KUPWAD', 2.80,
 ST_GeomFromText('POLYGON((74.615 16.860, 74.635 16.860, 74.635 16.875, 74.615 16.875, 74.615 16.860))', 4326)),
('11111111-0000-0000-0000-000000000019', 19, 'Ward 19 - Vasantdada Market Yard', 'प्रभाग १९ - वसंतदादा मार्केट यार्ड', 'KUPWAD', 3.40,
 ST_GeomFromText('POLYGON((74.625 16.850, 74.645 16.850, 74.645 16.868, 74.625 16.868, 74.625 16.850))', 4326)),
('11111111-0000-0000-0000-000000000020', 20, 'Ward 20 - Sangli-Miraj-Kupwad Triangle Link', 'प्रभाग २० - सांगली-मिरज-कुपवाड त्रिकोण रस्ता', 'KUPWAD', 4.10,
 ST_GeomFromText('POLYGON((74.610 16.850, 74.630 16.850, 74.630 16.865, 74.610 16.865, 74.610 16.850))', 4326));

-- ============================================================
-- 2. 3 CORPORATION OFFICES (HQ & Divisional Complexes)
-- ============================================================
INSERT INTO corporation_offices (id, office_code, office_name, office_name_mr, zone, premise_polygon) VALUES
('00000000-0000-0000-0000-000000000001', 'SMKMC-HQ', 'SMKMC Municipal Corporation Head Office', 'सांगली मिरज कुपवाड महानगरपालिका मुख्य कार्यालय (सांगली)', 'SANGLI',
 ST_GeomFromText('POLYGON((74.5820 16.8545, 74.5840 16.8545, 74.5840 16.8560, 74.5820 16.8560, 74.5820 16.8545))', 4326)),
('00000000-0000-0000-0000-000000000002', 'SMKMC-MIRAJ', 'SMKMC Miraj Divisional Office', 'महानगरपालिका विभागीय कार्यालय (मिरज)', 'MIRAJ',
 ST_GeomFromText('POLYGON((74.6435 16.8280, 74.6455 16.8280, 74.6455 16.8295, 74.6435 16.8295, 74.6435 16.8280))', 4326)),
('00000000-0000-0000-0000-000000000003', 'SMKMC-KUPWAD', 'SMKMC Kupwad Divisional Office', 'महानगरपालिका विभागीय कार्यालय (कुपवाड)', 'KUPWAD',
 ST_GeomFromText('POLYGON((74.6180 16.8810, 74.6200 16.8810, 74.6200 16.8830, 74.6180 16.8830, 74.6180 16.8810))', 4326));

-- ============================================================
-- 3. STAFF HIERARCHY (34 ACCOUNTS ACROSS ALL TIERS)
-- ============================================================

-- Level 4: Municipal Admin
INSERT INTO staff (id, employee_id, name, name_mr, phone, role, department, designation, zone, profile_photo_url) VALUES
('20000000-0000-0000-0000-000000000001', 'SMK-1001', 'Dr. Abhijit Patil (IAS)', 'डॉ. अभिजित पाटील (महानगरपालिका आयुक्त)', '+919822010001', 'ADMIN', 'ADMINISTRATION', 'Municipal Commissioner', 'SANGLI', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150');

-- Level 3: 3 Ward Inspectors (Static Anchors)
INSERT INTO staff (id, employee_id, name, name_mr, phone, role, department, designation, zone, ward_id, supervisor_id) VALUES
('20000000-0000-0000-0000-000000000002', 'SMK-2001', 'Sanjay Vitthal Pawar', 'संजय विठ्ठल पवार', '+919822020001', 'WARD_INSPECTOR', 'SANITATION', 'Senior Ward Inspector (Sangli)', 'SANGLI', '11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000001'),
('20000000-0000-0000-0000-000000000003', 'SMK-2002', 'Mahesh Anand Jadhav', 'महेश आनंद जाधव', '+919822020002', 'WARD_INSPECTOR', 'HEALTH', 'Senior Ward Inspector (Miraj)', 'MIRAJ', '11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000001'),
('20000000-0000-0000-0000-000000000004', 'SMK-2003', 'Satish Narayan Patil', 'सतीश नारायण पाटील', '+919822020003', 'WARD_INSPECTOR', 'SANITATION', 'Senior Ward Inspector (Kupwad)', 'KUPWAD', '11111111-0000-0000-0000-000000000017', '20000000-0000-0000-0000-000000000001');

-- Level 2: 6 Field Inspectors (Dynamic Squad Leads)
INSERT INTO staff (id, employee_id, name, name_mr, phone, role, department, designation, zone, ward_id, supervisor_id) VALUES
('20000000-0000-0000-0000-000000000005', 'SMK-3001', 'Amit Deshmukh', 'अमित देशमुख', '+919822030001', 'INSPECTOR', 'SANITATION', 'Field Inspector Squad 4A', 'SANGLI', '11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000002'),
('20000000-0000-0000-0000-000000000006', 'SMK-3002', 'Vikas Dattatray More', 'विकास दत्तात्रय मोरे', '+919822030002', 'INSPECTOR', 'ROAD', 'Field Inspector Squad 4B', 'SANGLI', '11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000002'),
('20000000-0000-0000-0000-000000000007', 'SMK-3003', 'Ganesh Ramchandra Shinde', 'गणेश रामचंद्र शिंदे', '+919822030003', 'INSPECTOR', 'SANITATION', 'Field Inspector Squad 11A', 'MIRAJ', '11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000003'),
('20000000-0000-0000-0000-000000000008', 'SMK-3004', 'Nilesh Mohan Kadam', 'निलेश मोहन कदम', '+919822030004', 'INSPECTOR', 'WATER', 'Field Inspector Squad 11B', 'MIRAJ', '11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000003'),
('20000000-0000-0000-0000-000000000009', 'SMK-3005', 'Rajesh Balaso Mane', 'राजेश बाळासो माने', '+919822030005', 'INSPECTOR', 'SANITATION', 'Field Inspector Squad 17A', 'KUPWAD', '11111111-0000-0000-0000-000000000017', '20000000-0000-0000-0000-000000000004'),
('20000000-0000-0000-0000-000000000010', 'SMK-3006', 'Sachin Pandurang Chavan', 'सचिन पांडुरंग चव्हाण', '+919822030006', 'INSPECTOR', 'ROAD', 'Field Inspector Squad 17B', 'KUPWAD', '11111111-0000-0000-0000-000000000017', '20000000-0000-0000-0000-000000000004');

-- Level 1: 18 Field Workers (Safai Kamgars, Water & Road Staff)
INSERT INTO staff (id, employee_id, name, name_mr, phone, role, department, designation, zone, ward_id, supervisor_id) VALUES
-- Squad 4A (under Inspector Amit Deshmukh)
('20000000-0000-0000-0000-000000000011', 'SMK-4001', 'Ramesh Vishnu Patil', 'रमेश विष्णू पाटील', '+919822040001', 'WORKER', 'SANITATION', 'Safai Kamgar (Drainage)', 'SANGLI', '11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000005'),
('20000000-0000-0000-0000-000000000012', 'SMK-4002', 'Sunita Mahadev Kamble', 'सुनिता महादेव कांबळे', '+919822040002', 'WORKER', 'SANITATION', 'Safai Kamgar (Street Sweeping)', 'SANGLI', '11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000005'),
('20000000-0000-0000-0000-000000000013', 'SMK-4003', 'Prakash Baburao Shinde', 'प्रकाश बाबुराव शिंदे', '+919822040003', 'WORKER', 'SANITATION', 'Safai Kamgar (Solid Waste Transfer)', 'SANGLI', '11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000005'),

-- Squad 4B (under Inspector Vikas More)
('20000000-0000-0000-0000-000000000014', 'SMK-4004', 'Deepak Ananda Kulkarni', 'दीपक आनंदा कुलकर्णी', '+919822040004', 'WORKER', 'ROAD', 'Road Maintenance Worker', 'SANGLI', '11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000006'),
('20000000-0000-0000-0000-000000000015', 'SMK-4005', 'Suresh Kisan Shinde', 'सुरेश किसन शिंदे', '+919822040005', 'WORKER', 'ROAD', 'Pothole Repair Crew', 'SANGLI', '11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000006'),
('20000000-0000-0000-0000-000000000016', 'SMK-4006', 'Kishor Dnyandeo Mali', 'किशोर ज्ञानदेव माळी', '+919822040006', 'WORKER', 'GARDEN', 'Civic Garden Maintenance', 'SANGLI', '11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000006'),

-- Squad 11A (under Inspector Ganesh Shinde)
('20000000-0000-0000-0000-000000000017', 'SMK-4007', 'Ashok Namdeo Chavan', 'अशोक नामदेव चव्हाण', '+919822040007', 'WORKER', 'SANITATION', 'Safai Kamgar (Station Area)', 'MIRAJ', '11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000007'),
('20000000-0000-0000-0000-000000000018', 'SMK-4008', 'Parvati Shankar Salunkhe', 'पार्वती शंकर साळुंखे', '+919822040008', 'WORKER', 'SANITATION', 'Safai Kamgar (Street Sweeping)', 'MIRAJ', '11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000007'),
('20000000-0000-0000-0000-000000000019', 'SMK-4009', 'Santosh Ganpati Gurav', 'संतोष गणपती गुरव', '+919822040009', 'WORKER', 'SANITATION', 'Public Restroom Cleaner', 'MIRAJ', '11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000007'),

-- Squad 11B (under Inspector Nilesh Kadam)
('20000000-0000-0000-0000-000000000020', 'SMK-4010', 'Tanaji Shankar Bhosale', 'तानाजी शंकर भोसले', '+919822040010', 'WORKER', 'WATER', 'Pipeline Valve Operator', 'MIRAJ', '11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000008'),
('20000000-0000-0000-0000-000000000021', 'SMK-4011', 'Anil Bhimrao Thorat', 'अनिल भीमराव थोरात', '+919822040011', 'WORKER', 'WATER', 'Water Supply Leak Inspector', 'MIRAJ', '11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000008'),
('20000000-0000-0000-0000-000000000022', 'SMK-4012', 'Vijay Appaso Yadav', 'विजय आप्पासो यादव', '+919822040012', 'WORKER', 'WATER', 'Pump House Operator', 'MIRAJ', '11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000008'),

-- Squad 17A (under Inspector Rajesh Mane)
('20000000-0000-0000-0000-000000000023', 'SMK-4013', 'Pandurang Dadu Waghmare', 'पांडुरंग दादू वाघमारे', '+919822040013', 'WORKER', 'SANITATION', 'Industrial Waste Transfer', 'KUPWAD', '11111111-0000-0000-0000-000000000017', '20000000-0000-0000-0000-000000000009'),
('20000000-0000-0000-0000-000000000024', 'SMK-4014', 'Rukmini Balu Kamble', 'रुक्मिणी बाळू कांबळे', '+919822040014', 'WORKER', 'SANITATION', 'Safai Kamgar (MIDC Sector)', 'KUPWAD', '11111111-0000-0000-0000-000000000017', '20000000-0000-0000-0000-000000000009'),
('20000000-0000-0000-0000-000000000025', 'SMK-4015', 'Subhash Maruti Gaikwad', 'सुभाष मारुती गायकवाड', '+919822040015', 'WORKER', 'SANITATION', 'Drainage De-silting Crew', 'KUPWAD', '11111111-0000-0000-0000-000000000017', '20000000-0000-0000-0000-000000000009'),

-- Squad 17B (under Inspector Sachin Chavan)
('20000000-0000-0000-0000-000000000026', 'SMK-4016', 'Baban Govind Sawant', 'बबन गोविंद सावंत', '+919822040016', 'WORKER', 'ROAD', 'Heavy Road Repair Worker', 'KUPWAD', '11111111-0000-0000-0000-000000000010'),
('20000000-0000-0000-0000-000000000027', 'SMK-4017', 'Dnyaneshwar Kerba Sutar', 'ज्ञानेश्वर केरबा सुतार', '+919822040017', 'WORKER', 'ROAD', 'Storm Drain Concrete Mason', 'KUPWAD', '11111111-0000-0000-0000-000000000010'),
('20000000-0000-0000-0000-000000000028', 'SMK-4018', 'Mahadev Yashwant More', 'महादेव यशवंत मोरे', '+919822040018', 'WORKER', 'GARDEN', 'MIDC Green Corridor Maintenance', 'KUPWAD', '11111111-0000-0000-0000-000000000010');

-- Level 1 (Office Staff Track - Direct to Admin)
INSERT INTO staff (id, employee_id, name, name_mr, phone, role, department, designation, zone, office_id, supervisor_id) VALUES
('20000000-0000-0000-0000-000000000029', 'SMK-5001', 'Pooja Anand Kulkarni', 'पूजा आनंद कुलकर्णी', '+919822050001', 'OFFICE_STAFF', 'ADMINISTRATION', 'Senior Establishment Clerk', 'SANGLI', '00000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001'),
('20000000-0000-0000-0000-000000000030', 'SMK-5002', 'Rahul Suresh Patil', 'राहुल सुरेश पाटील', '+919822050002', 'OFFICE_STAFF', 'ADMINISTRATION', 'Muster Roll Accountant', 'SANGLI', '00000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001'),
('20000000-0000-0000-0000-000000000031', 'SMK-5003', 'Sneha Dattatray Shinde', 'स्नेहा दत्तात्रय शिंदे', '+919822050003', 'OFFICE_STAFF', 'ADMINISTRATION', 'Citizen Grievance Officer', 'SANGLI', '00000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001'),
('20000000-0000-0000-0000-000000000032', 'SMK-5004', 'Manoj Prakash Joshi', 'मनोज प्रकाश जोशी', '+919822050004', 'OFFICE_STAFF', 'ADMINISTRATION', 'Divisional Clerk (Miraj)', 'MIRAJ', '00000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000001'),
('20000000-0000-0000-0000-000000000033', 'SMK-5005', 'Varsha Arvind Kadam', 'वर्षा अरविंद कदम', '+919822050005', 'OFFICE_STAFF', 'ADMINISTRATION', 'Divisional Accountant (Miraj)', 'MIRAJ', '00000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000001'),
('20000000-0000-0000-0000-000000000034', 'SMK-5006', 'Kishor Namdeo Pawar', 'किशोर नामदेव पवार', '+919822050006', 'OFFICE_STAFF', 'ADMINISTRATION', 'Divisional Clerk (Kupwad)', 'KUPWAD', '00000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000001');

-- ============================================================
-- 4. STANDING ROSTERS (BASELINE SQUAD MAPPINGS)
-- ============================================================
INSERT INTO standing_rosters (ward_id, ward_inspector_id, inspector_id, worker_id) VALUES
-- Ward 4 Squads
('11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000005', '20000000-0000-0000-0000-000000000011'),
('11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000005', '20000000-0000-0000-0000-000000000012'),
('11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000005', '20000000-0000-0000-0000-000000000013'),
('11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000006', '20000000-0000-0000-0000-000000000014'),
('11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000006', '20000000-0000-0000-0000-000000000015'),
('11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000006', '20000000-0000-0000-0000-000000000016'),

-- Ward 11 Squads
('11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000007', '20000000-0000-0000-0000-000000000017'),
('11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000007', '20000000-0000-0000-0000-000000000018'),
('11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000007', '20000000-0000-0000-0000-000000000019'),
('11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000008', '20000000-0000-0000-0000-000000000020'),
('11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000008', '20000000-0000-0000-0000-000000000021'),
('11111111-0000-0000-0000-000000000011', '20000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000008', '20000000-0000-0000-0000-000000000022'),

-- Ward 17 Squads
('11111111-0000-0000-0000-000000000017', '20000000-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000009', '20000000-0000-0000-0000-000000000023'),
('11111111-0000-0000-0000-000000000017', '20000000-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000009', '20000000-0000-0000-0000-000000000024'),
('11111111-0000-0000-0000-000000000017', '20000000-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000009', '20000000-0000-0000-0000-000000000025'),
('11111111-0000-0000-0000-000000000017', '20000000-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000010', '20000000-0000-0000-0000-000000000026'),
('11111111-0000-0000-0000-000000000017', '20000000-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000010', '20000000-0000-0000-0000-000000000027'),
('11111111-0000-0000-0000-000000000017', '20000000-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000010', '20000000-0000-0000-0000-000000000028');

-- ============================================================
-- 5. DAILY SHIFT ASSIGNMENTS (TODAY'S ACTIVE ROSTER)
-- ============================================================
INSERT INTO daily_shift_assignments (date, ward_id, ward_inspector_id, inspector_id, worker_id, assignment_mode)
SELECT 
  ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date),
  ward_id,
  ward_inspector_id,
  inspector_id,
  worker_id,
  'STANDING_ROSTER'
FROM standing_rosters;

-- ============================================================
-- 6. SHIFTS (TODAY'S TIMINGS)
-- ============================================================
INSERT INTO shifts (staff_id, shift_date, shift_type, start_time, end_time)
SELECT 
  id, 
  ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date),
  CASE WHEN role = 'OFFICE_STAFF' THEN 'GENERAL_OFFICE' ELSE 'MORNING' END,
  CASE WHEN role = 'OFFICE_STAFF' THEN '09:30:00'::TIME ELSE '06:00:00'::TIME END,
  CASE WHEN role = 'OFFICE_STAFF' THEN '17:30:00'::TIME ELSE '14:00:00'::TIME END
FROM staff;

-- ============================================================
-- 7. TODAY'S ATTENDANCE LOGS
-- ============================================================
INSERT INTO attendance_logs (
  staff_id, date, checkin_time, checkin_lat, checkin_lng, accuracy_m,
  checkin_within_geofence, checkin_face_score, status, is_late_mark, late_minutes,
  attendance_mode, marked_by_id
) VALUES
-- On-Time Worker Self Check-In (Ramesh Patil)
('20000000-0000-0000-0000-000000000011', ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date),
 ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date || ' 06:08:24 Asia/Kolkata')::TIMESTAMPTZ,
 16.8450, 74.6020, 8.5, true, 0.96, 'PRESENT', false, 0, 'SELF', '20000000-0000-0000-0000-000000000011'),

-- On-Time Worker Self Check-In (Sunita Kamble)
('20000000-0000-0000-0000-000000000012', ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date),
 ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date || ' 06:14:10 Asia/Kolkata')::TIMESTAMPTZ,
 16.8465, 74.6040, 11.2, true, 0.94, 'PRESENT', false, 0, 'SELF', '20000000-0000-0000-0000-000000000012'),

-- Late Mark (>15m grace) Worker (Prakash Shinde: arrived 06:32 AM)
('20000000-0000-0000-0000-000000000013', ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date),
 ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date || ' 06:32:45 Asia/Kolkata')::TIMESTAMPTZ,
 16.8480, 74.6055, 9.1, true, 0.92, 'LATE', true, 32, 'SELF', '20000000-0000-0000-0000-000000000013'),

-- Inspector Proxy Punch (Deepak Kulkarni marked by Inspector Amit Deshmukh)
('20000000-0000-0000-0000-000000000014', ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date),
 ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date || ' 06:11:30 Asia/Kolkata')::TIMESTAMPTZ,
 16.8455, 74.6025, 12.0, true, 0.91, 'PRESENT', false, 0, 'INSPECTOR_PROXY', '20000000-0000-0000-0000-000000000005'),

-- Office Staff Punch (Pooja Kulkarni at Sangli HQ 100m geofence)
('20000000-0000-0000-0000-000000000029', ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date),
 ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date || ' 09:25:00 Asia/Kolkata')::TIMESTAMPTZ,
 16.8552, 74.5828, 14.5, true, 0.98, 'PRESENT', false, 0, 'SELF', '20000000-0000-0000-0000-000000000029');

-- ============================================================
-- 8. 10-MINUTE LOCATION PINGS (MOVEMENT TRAIL IN WARD 4)
-- ============================================================
INSERT INTO location_pings (staff_id, lat, lng, accuracy_m, battery_level, is_within_ward, recorded_at) VALUES
('20000000-0000-0000-0000-000000000011', 16.8450, 74.6020, 8.5, 95, true, ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date || ' 06:10:00 Asia/Kolkata')::TIMESTAMPTZ),
('20000000-0000-0000-0000-000000000011', 16.8462, 74.6035, 9.0, 93, true, ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date || ' 06:20:00 Asia/Kolkata')::TIMESTAMPTZ),
('20000000-0000-0000-0000-000000000011', 16.8475, 74.6050, 7.8, 91, true, ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date || ' 06:30:00 Asia/Kolkata')::TIMESTAMPTZ),
('20000000-0000-0000-0000-000000000011', 16.8490, 74.6068, 8.2, 89, true, ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date || ' 06:40:00 Asia/Kolkata')::TIMESTAMPTZ);

-- ============================================================
-- 9. TASKS & CITIZEN COMPLAINTS
-- ============================================================
INSERT INTO tasks (
  id, title, title_mr, description, priority, status, assigned_to, 
  created_by, ward_id, location_lat, location_lng, location_label, due_at
) VALUES
('50000000-0000-0000-0000-000000000001', 
 'Clear storm drain obstruction near Walchand College Gate', 
 'वालचंद कॉलेज गेट जवळील गटार गाळ काढणे', 
 'Clear heavy silt and plastic debris blocking storm drainage before monsoon rain', 
 'URGENT', 'IN_PROGRESS', '20000000-0000-0000-0000-000000000011', 
 '20000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000004', 
 16.8452, 74.6025, 'WCE Main Road, Vishrambag', NOW() + INTERVAL '3 hours'),

('50000000-0000-0000-0000-000000000002', 
 'Sweep 100ft road commercial zone', 
 '१०० फुटी रस्ता व्यावसायिक संकुल स्वच्छता', 
 'Daily sweeping and dry waste collection transfer to municipal dumper', 
 'NORMAL', 'OPEN', '20000000-0000-0000-0000-000000000012', 
 '20000000-0000-0000-0000-000000000005', '11111111-0000-0000-0000-000000000004', 
 16.8470, 74.6045, '100ft Road Corner, Vishrambag', NOW() + INTERVAL '5 hours');

INSERT INTO citizen_complaints (id, tracking_id, name, phone, ward_id, category, description, status) VALUES
('60000000-0000-0000-0000-000000000001', 'SMK-2026-0001', 'सचिन कुलकर्णी', '+919822099991', '11111111-0000-0000-0000-000000000004', 'GARBAGE', 'विश्रामबाग चौकात कचरा साचला आहे', 'IN_PROGRESS'),
('60000000-0000-0000-0000-000000000002', 'SMK-2026-0002', 'अमोल जोशी', '+919822099992', '11111111-0000-0000-0000-000000000011', 'WATER', 'स्टेशन रोडवर पिण्याच्या पाण्याची गळती', 'RECEIVED');

-- ============================================================
-- 10. CONVERSATIONS & CHAT THREADS
-- ============================================================
INSERT INTO conversations (id, conversation_key, type, title, ward_id, inspector_id, shift_date) VALUES
('70000000-0000-0000-0000-000000000001', 'GLOBAL_BROADCAST_SMKMC', 'CITY_BROADCAST', 'SMKMC Municipal Commissioner Directives', NULL, NULL, NULL),
('70000000-0000-0000-0000-000000000002', 'WARD_4_BROADCAST', 'WARD_BROADCAST', 'Ward 4 Vishrambag Field Announcements', '11111111-0000-0000-0000-000000000004', NULL, NULL),
('70000000-0000-0000-0000-000000000003', 'SQUAD_4A_TODAY', 'SQUAD_TEAM', 'Inspector Amit Squad 4A Field Ops', '11111111-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000005', ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date));

-- Add Participants
INSERT INTO conversation_participants (conversation_id, staff_id) VALUES
-- Squad 4A members
('70000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000005'),
('70000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000011'),
('70000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000012'),
('70000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000013');

-- Messages
INSERT INTO messages (conversation_id, sender_id, type, content) VALUES
('70000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000005', 'TEXT', 'नमस्कार टीम. आज विश्रामबाग वालचंद कॉलेज परिसरातील नाले सफाईचे काम वेळेत पूर्ण करायचे आहे.'),
('70000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000011', 'TEXT', 'हो साहेब, आम्ही कॉलेज गेट समोरील नाला सफाई सुरु केली आहे.');

-- ============================================================
-- 11. GAZETTED HOLIDAYS 2026-27
-- ============================================================
INSERT INTO holidays (date, name, name_mr, type) VALUES
('2026-01-26', 'Republic Day',         'प्रजासत्ताक दिन',   'GAZETTE'),
('2026-03-28', 'Holi',                 'होळी',               'GAZETTE'),
('2026-04-02', 'Ram Navami',           'रामनवमी',            'GAZETTE'),
('2026-04-14', 'Ambedkar Jayanti',     'आंबेडकर जयंती',     'GAZETTE'),
('2026-05-01', 'Maharashtra Day',      'महाराष्ट्र दिन',    'GAZETTE'),
('2026-08-15', 'Independence Day',     'स्वातंत्र्य दिन',   'GAZETTE'),
('2026-08-27', 'Ganesh Chaturthi',     'गणेश चतुर्थी',     'GAZETTE'),
('2026-10-02', 'Gandhi Jayanti',       'गांधी जयंती',       'GAZETTE'),
('2026-10-20', 'Dussehra',             'दसरा',               'GAZETTE'),
('2026-11-01', 'Diwali',               'दिवाळी',             'GAZETTE'),
('2026-11-02', 'Diwali (Laxmi Puja)', 'दिवाळी (लक्ष्मीपूजन)', 'GAZETTE'),
('2026-11-14', 'Gurunanak Jayanti',   'गुरुनानक जयंती',    'GAZETTE'),
('2026-12-25', 'Christmas',            'ख्रिसमस',            'GAZETTE'),
('2027-01-26', 'Republic Day',         'प्रजासत्ताक दिन',   'GAZETTE');

-- ============================================================
-- 12. WARD PERFORMANCE SCORES
-- ============================================================
INSERT INTO ward_scores (ward_id, date, attendance_pct, task_completion_pct, complaint_resolution_pct, overall_score, color_band) VALUES
('11111111-0000-0000-0000-000000000004', ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date), 96.0, 94.0, 90.0, 94.2, 'GREEN'),
('11111111-0000-0000-0000-000000000011', ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date), 88.5, 82.0, 85.0, 86.0, 'GREEN'),
('11111111-0000-0000-0000-000000000017', ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date), 76.0, 70.0, 72.0, 73.5, 'AMBER');

-- ============================================================
-- 13. CHECKPOINT SCANS (TODAY'S VERIFIED BEAT VISITS)
-- ============================================================
INSERT INTO checkpoint_scans (staff_id, checkpoint_id, checkpoint_name, lat, lng, scanned_at) VALUES
('20000000-0000-0000-0000-000000000011', 'CP-S1', 'CP-S1 — गणपती पेठ चौक', 16.8540, 74.5830, ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date || ' 06:45:00 Asia/Kolkata')::TIMESTAMPTZ),
('20000000-0000-0000-0000-000000000011', 'CP-S2', 'CP-S2 — राजवाडा परिसर', 16.8555, 74.5850, ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date || ' 07:15:00 Asia/Kolkata')::TIMESTAMPTZ);

-- ============================================================
-- 14. PAYROLL RECORDS (CURRENT MONTH APPROVED MAPPINGS)
-- ============================================================
INSERT INTO payroll_records (
  staff_id, month, working_days, present_days, late_days, absent_days, leave_days,
  overtime_hours, gross_salary, deductions, net_salary, status
) VALUES
('20000000-0000-0000-0000-000000000011', ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date - INTERVAL '1 month')::date, 26, 24.5, 2, 1.0, 0.5, 5.0, 16900.00, 975.00, 16534.00, 'APPROVED'),
('20000000-0000-0000-0000-000000000012', ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Kolkata')::date - INTERVAL '1 month')::date, 26, 26.0, 0, 0.0, 0.0, 8.0, 16900.00, 0.00, 17875.00, 'DISBURSED');
