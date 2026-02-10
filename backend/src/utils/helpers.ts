import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { v4 as uuidv4 } from 'uuid';

export const hashPassword = async (password: string): Promise<string> => {
  return bcrypt.hash(password, 10);
};

export const comparePassword = async (
  password: string,
  hashedPassword: string
): Promise<boolean> => {
  return bcrypt.compare(password, hashedPassword);
};

export const generateToken = (userId: string, email: string, role: string): string => {
  const secret = process.env.JWT_SECRET || 'secret';
  return jwt.sign(
    { id: userId, email, role },
    secret,
    { expiresIn: process.env.JWT_EXPIRY || '7d' } as any
  );
};

export const generateId = (): string => {
  return uuidv4();
};

export const validateEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

export const validatePhone = (phone: string): boolean => {
  const phoneRegex = /^\+?[1-9]\d{1,14}$/;
  return phoneRegex.test(phone);
};

export const successResponse = <T,>(
  data: T,
  message: string = 'Success',
  statusCode: number = 200
) => ({
  success: true,
  data,
  message,
  statusCode,
});

export const errorResponse = (
  error: string,
  statusCode: number = 400
) => ({
  success: false,
  error,
  statusCode,
});

export const formatCurrency = (amount: number): string => {
  return `XOF ${amount.toFixed(2)}`;
};
