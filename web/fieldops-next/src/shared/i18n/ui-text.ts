/** Fixed UI strings in English and Marathi. Error messages come from the shared code table. */
export const UI_TEXT = {
  appName: { en: 'FieldOps SMKMC', mr: 'FieldOps SMKMC' },
  corporation: { en: 'Sangli Miraj Kupwad Municipal Corporation', mr: 'सांगली मिरज कुपवाड शहर महानगरपालिका' },
  signIn: { en: 'Sign in', mr: 'साइन इन' },
  signingIn: { en: 'Signing in…', mr: 'साइन इन होत आहे…' },
  signOut: { en: 'Sign out', mr: 'साइन आउट' },
  staffSignIn: { en: 'Staff sign-in', mr: 'कर्मचारी साइन इन' },
  staffSignInHint: {
    en: 'For administrators, ward inspectors and office staff. Field staff use the mobile app.',
    mr: 'प्रशासक, प्रभाग निरीक्षक आणि कार्यालयीन कर्मचाऱ्यांसाठी. क्षेत्रीय कर्मचारी मोबाइल अॅप वापरतात.',
  },
  identifier: { en: 'Employee code or mobile number', mr: 'कर्मचारी कोड किंवा मोबाइल क्रमांक' },
  password: { en: 'Password', mr: 'पासवर्ड' },
  citizenPortal: { en: 'Citizen portal', mr: 'नागरिक पोर्टल' },
  language: { en: 'मराठी', mr: 'English' },
  requestId: { en: 'Request ID', mr: 'विनंती आयडी' },
  retry: { en: 'Try again', mr: 'पुन्हा प्रयत्न करा' },
  loading: { en: 'Loading…', mr: 'लोड होत आहे…' },
  today: { en: 'Today', mr: 'आज' },
  present: { en: 'Present', mr: 'उपस्थित' },
  late: { en: 'Late', mr: 'उशिरा' },
  halfDay: { en: 'Half day', mr: 'अर्धा दिवस' },
  absent: { en: 'Absent', mr: 'अनुपस्थित' },
  openAlerts: { en: 'Open alerts', mr: 'खुल्या सूचना' },
  latestAlerts: { en: 'Latest open alerts', mr: 'नवीन खुल्या सूचना' },
  noOpenAlerts: { en: 'No open alerts.', mr: 'खुल्या सूचना नाहीत.' },
  welcome: { en: 'Welcome', mr: 'स्वागत' },
} as const satisfies Record<string, { en: string; mr: string }>;

export type UiKey = keyof typeof UI_TEXT;
