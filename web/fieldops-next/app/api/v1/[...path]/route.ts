import type { NextRequest } from 'next/server';
import { proxyToApi } from '@/server/api-proxy';

// Pass-through to the NestJS API with the session from httpOnly cookies. No data access here.
export const dynamic = 'force-dynamic';

type Context = { params: Promise<{ path: string[] }> };

async function handle(req: NextRequest, { params }: Context) {
  return proxyToApi(req, (await params).path);
}

export { handle as GET, handle as POST, handle as PUT, handle as PATCH, handle as DELETE };
