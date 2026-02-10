#!/bin/bash

# IROKO Backend startup script

set -e

echo "🚀 Starting IROKO Backend..."

# Check if .env exists
if [ ! -f .env ]; then
    echo "📋 Creating .env from .env.example..."
    cp .env.example .env
    echo "⚠️  Please update .env with your database credentials"
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Run Prisma setup
echo "🗄️  Setting up database..."
npm run db:generate

if [ "$1" == "--seed" ]; then
    echo "🌱 Seeding database..."
    npm run db:seed
fi

# Start development server
echo "✅ Starting server..."
npm run dev
