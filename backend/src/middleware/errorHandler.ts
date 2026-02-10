import { Request, Response, NextFunction } from 'express';

export const errorHandler = (
  error: any,
  _req: Request,
  res: Response,
  _next: NextFunction
): void => {
  console.error('❌ Error:', error);

  const statusCode = error.statusCode || 500;
  const message = error.message || 'Internal Server Error';

  if (process.env.NODE_ENV === 'development') {
    res.status(statusCode).json({
      success: false,
      error: message,
      stack: error.stack,
      details: error,
    });
  } else {
    // Production: don't leak error details
    res.status(statusCode).json({
      success: false,
      error: statusCode === 500 ? 'Internal Server Error' : message,
    });
  }
};

export class AppError extends Error {
  constructor(
    public statusCode: number,
    message: string
  ) {
    super(message);
    Error.captureStackTrace(this, this.constructor);
  }
}
