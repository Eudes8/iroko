import express, { Application, Request, Response, NextFunction } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { PrismaClient } from '@prisma/client';

// Load environment variables
dotenv.config();

// Import routes
import authRoutes from './routes/auth.routes';
import missionRoutes from './routes/mission.routes';
import userRoutes from './routes/user.routes';
import paymentRoutes from './routes/payment.routes';

// Import middleware
import { errorHandler } from './middleware/errorHandler';

// Import health controller
import { HealthController } from './health.controller';

const app: Application = express();
const prisma = new PrismaClient();

// Extract port and host
const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || 'localhost';

// ====== MIDDLEWARE ======
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

// CORS
const corsOrigin = process.env.CORS_ORIGIN?.split(',') || 'http://localhost';
app.use(cors({
  origin: corsOrigin,
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Request logging middleware (simple)
app.use((_req: Request, _res: Response, _next: NextFunction) => {
  console.log(`${new Date().toISOString()} - ${_req.method} ${_req.path}`);
  _next();
});

// ====== ROUTES ======
// Health check endpoints (pour Render.com et monitoring)
app.get('/health', HealthController.healthCheck);
app.get('/health/detailed', HealthController.detailedHealthCheck);

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/missions', missionRoutes);
app.use('/api/v1/users', userRoutes);
app.use('/api/v1/payments', paymentRoutes);

// ====== 404 HANDLER ======
app.use((_req: Request, res: Response) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found',
    path: _req.path,
    method: _req.method,
  });
});

// ====== ERROR HANDLER ======
app.use(errorHandler);

// ====== START SERVER ======
const server = app.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════╗
║  🚀 IROKO Backend Server Started   ║
║  Server: http://${HOST}:${PORT}          ║
║  Health: http://${HOST}:${PORT}/health   ║
║  API: http://${HOST}:${PORT}/api/v1      ║
║  Environment: ${process.env.NODE_ENV || 'development'} ║
╚════════════════════════════════════╝
  `);
});

// ====== GRACEFUL SHUTDOWN ======
const gracefulShutdown = async () => {
  console.log('\n🛑 Shutting down gracefully...');
  
  server.close(async () => {
    console.log('Server closed');
    await prisma.$disconnect();
    console.log('Database disconnected');
    process.exit(0);
  });

  // Force shutdown after 10 seconds
  setTimeout(() => {
    console.error('Could not close connections in time, forcefully shutting down');
    process.exit(1);
  }, 10000);
};

process.on('SIGTERM', gracefulShutdown);
process.on('SIGINT', gracefulShutdown);

// Handle uncaught exceptions
process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
  gracefulShutdown();
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
  gracefulShutdown();
});

export default app;
export { prisma };
