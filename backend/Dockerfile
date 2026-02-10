# Multi-stage build
FROM node:18 AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source
COPY . .

# Copy prisma schema
COPY prisma ./prisma

# Generate Prisma client
RUN npm run db:generate

# Build TypeScript
RUN npm run build

# Production image
FROM node:18

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy built app from builder
COPY --from=builder /app/dist ./dist

# Copy prisma client and schema from builder
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma ./node_modules/@prisma
COPY prisma ./prisma

# Create non-root user
RUN groupadd -g 1001 nodejs
RUN useradd -m -u 1001 -g nodejs nodejs
USER nodejs

EXPOSE 3000

CMD ["node", "dist/server.js"]
