import type { Schemas } from '@/api/client';

type Pair = { en: string; mr: string };

export const CATEGORY_TEXT: Record<Schemas['SubmitComplaintDto']['category'], Pair> = {
  GARBAGE: { en: 'Garbage not collected', mr: 'कचरा उचलला नाही' },
  DRAIN: { en: 'Blocked drain', mr: 'गटार तुंबले' },
  ROAD: { en: 'Road or pothole', mr: 'रस्ता / खड्डा' },
  WATER: { en: 'Water supply or leak', mr: 'पाणीपुरवठा / गळती' },
  TREE: { en: 'Fallen or dangerous tree', mr: 'पडलेले / धोकादायक झाड' },
  STRAY_ANIMAL: { en: 'Stray animals', mr: 'भटकी जनावरे' },
  OTHER: { en: 'Something else', mr: 'इतर' },
};

export const COMPLAINT_STATUS_TEXT: Record<Schemas['PublicComplaintDto']['status'], Pair & { step: number }> = {
  RECEIVED: { en: 'Received', mr: 'प्राप्त', step: 1 },
  ASSIGNED: { en: 'Assigned to a team', mr: 'पथकाकडे सोपवली', step: 2 },
  IN_PROGRESS: { en: 'Work in progress', mr: 'काम सुरू', step: 3 },
  RESOLVED: { en: 'Resolved', mr: 'निकाली', step: 4 },
  CLOSED: { en: 'Closed', mr: 'बंद', step: 4 },
  REJECTED: { en: 'Not taken up', mr: 'स्वीकारली नाही', step: 4 },
};

export const CITIZEN_TEXT = {
  portal: { en: 'Citizen portal', mr: 'नागरिक पोर्टल' },
  fileComplaint: { en: 'Report a problem', mr: 'तक्रार नोंदवा' },
  track: { en: 'Track a complaint', mr: 'तक्रारीची स्थिती' },
  wards: { en: 'Wards', mr: 'प्रभाग' },
  privacy: {
    en: 'Your name and number are optional and are never shown publicly.',
    mr: 'तुमचे नाव व क्रमांक ऐच्छिक आहेत आणि कधीही सार्वजनिक दाखवले जात नाहीत.',
  },
} satisfies Record<string, Pair>;
