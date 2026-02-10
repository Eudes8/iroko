import { NextRequest, NextResponse } from 'next/server';

/**
 * Health Check Endpoint
 * GET /api/health
 */
export async function GET(request: NextRequest) {
  const uptime = process.uptime();
  const memoryUsage = process.memoryUsage();

  return NextResponse.json({
    status: 'ok',
    message: 'IROKO Backend is running',
    timestamp: new Date().toISOString(),
    uptime: {
      seconds: uptime,
      human: formatUptime(uptime),
    },
    environment: process.env.NODE_ENV || 'development',
    version: '1.0.0',
    memory: {
      rss: `${Math.round(memoryUsage.rss / 1024 / 1024)}MB`,
      heapTotal: `${Math.round(memoryUsage.heapTotal / 1024 / 1024)}MB`,
      heapUsed: `${Math.round(memoryUsage.heapUsed / 1024 / 1024)}MB`,
    },
  });
}

/**
 * Formater le temps d'exécution en format lisible
 */
function formatUptime(seconds: number): string {
  const days = Math.floor(seconds / 86400);
  const hours = Math.floor((seconds % 86400) / 3600);
  const minutes = Math.floor((seconds % 3600) / 60);
  const secs = Math.floor(seconds % 60);

  const parts: string[] = [];
  if (days > 0) parts.push(`${days}d`);
  if (hours > 0) parts.push(`${hours}h`);
  if (minutes > 0) parts.push(`${minutes}m`);
  if (secs > 0 || parts.length === 0) parts.push(`${secs}s`);

  return parts.join(' ');
}
