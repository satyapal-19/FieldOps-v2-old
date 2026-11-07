import 'server-only';
import createClient from 'openapi-fetch';
import { headers } from 'next/headers';
import type { paths } from '@/api/generated/schema';
import { serverConfig } from './config';

/**
 * The API client for server-rendered citizen pages: public endpoints only, no session. The
 * browser's address (from IIS) is passed on, so the per-IP limit counts each citizen, not
 * this server.
 */
export async function publicApi() {
  const incoming = await headers();
  const forwarded = incoming.get('x-forwarded-for');
  return createClient<paths>({
    baseUrl: serverConfig.apiUrl,
    headers: forwarded ? { 'x-forwarded-for': forwarded } : {},
    cache: 'no-store',
  });
}
