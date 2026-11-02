import 'server-only';

/** Server-side settings for the web app; the browser never sees these. */
export const serverConfig = {
  apiUrl: (process.env.API_INTERNAL_URL ?? 'http://localhost:3000').replace(/\/+$/, ''),
  cookieSecure:
    process.env.COOKIE_SECURE !== undefined
      ? process.env.COOKIE_SECURE === 'true'
      : process.env.NODE_ENV === 'production',
};
