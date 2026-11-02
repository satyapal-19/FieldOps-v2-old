import { dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

/** @type {import('next').NextConfig} */
const nextConfig = {
  // Self-contained server bundle for the SMKC server (run with `node server.js` under PM2).
  output: 'standalone',
  // This folder is the app root (the repo root has its own lockfile for helper scripts).
  outputFileTracingRoot: dirname(fileURLToPath(import.meta.url)),
  reactStrictMode: true,
  poweredByHeader: false,
};

export default nextConfig;
