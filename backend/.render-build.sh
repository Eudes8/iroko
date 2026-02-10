#!/bin/bash
# Script de build pour Render.com

set -e

echo "🚀 Début du build IROKO Backend..."

# Installer les dépendances
echo "📦 Installation des dépendances..."
npm ci

# Générer le client Prisma
echo "🔧 Génération du client Prisma..."
npm run db:generate

# Compiler TypeScript
echo "🔨 Compilation TypeScript..."
npm run build

echo "✅ Build terminé avec succès!"
