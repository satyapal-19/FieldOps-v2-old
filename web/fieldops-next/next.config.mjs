/** @type {import('next').NextConfig} */
const nextConfig = {
  // Self-contained server bundle for the SMKC server (run with `node server.js` under PM2).
  output: 'standalone',
  reactStrictMode: true,
  poweredByHeader: false,
};

export default nextConfig;
