import { Request, Response } from 'express';

/**
 * Health Check Controller
 * Utilisé par Render.com et autres plateformes pour vérifier que le service est en ligne
 */
export class HealthController {
  /**
   * Endpoint de santé basique
   * GET /health
   */
  static async healthCheck(_req: Request, res: Response): Promise<void> {
    const uptime = process.uptime();
    const memoryUsage = process.memoryUsage();

    res.status(200).json({
      status: 'ok',
      message: 'IROKO Backend is running',
      timestamp: new Date().toISOString(),
      uptime: {
        seconds: uptime,
        human: formatUptime(uptime),
      },
      environment: process.env.NODE_ENV || 'development',
      version: process.env.npm_package_version || '1.0.0',
      memory: {
        rss: `${Math.round(memoryUsage.rss / 1024 / 1024)}MB`,
        heapTotal: `${Math.round(memoryUsage.heapTotal / 1024 / 1024)}MB`,
        heapUsed: `${Math.round(memoryUsage.heapUsed / 1024 / 1024)}MB`,
      },
    });
  }

  /**
   * Endpoint de santé détaillé avec vérification de la base de données
   * GET /health/detailed
   */
  static async detailedHealthCheck(_req: Request, res: Response): Promise<void> {
    try {
      // Importer Prisma dynamiquement pour éviter les erreurs au démarrage
      const { PrismaClient } = await import('@prisma/client');
      const prisma = new PrismaClient();

      // Tester la connexion à la base de données
      await prisma.$queryRaw`SELECT 1`;
      await prisma.$disconnect();

      const uptime = process.uptime();

      res.status(200).json({
        status: 'ok',
        message: 'IROKO Backend is running',
        timestamp: new Date().toISOString(),
        uptime: {
          seconds: uptime,
          human: formatUptime(uptime),
        },
        environment: process.env.NODE_ENV || 'development',
        version: process.env.npm_package_version || '1.0.0',
        services: {
          database: 'connected',
          api: 'running',
        },
      });
    } catch (error) {
      res.status(503).json({
        status: 'error',
        message: 'Service unavailable',
        timestamp: new Date().toISOString(),
        error: error instanceof Error ? error.message : 'Unknown error',
      });
    }
  }
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
