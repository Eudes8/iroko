#!/bin/bash

# Script de configuration Vercel pour IROKO
# Ce script configure le projet Vercel et importe les variables d'environnement

set -e

echo "🚀 Configuration Vercel pour IROKO"
echo "=================================="
echo ""

# Vérifier si Vercel CLI est installé
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI n'est pas installé."
    echo "Installation en cours..."
    npm install -g vercel
fi

echo "✅ Vercel CLI est installé"
echo ""

# Étape 1: Connexion à Vercel
echo "📝 Étape 1: Connexion à Vercel"
echo "-------------------------------"
echo "Veuillez vous connecter à Vercel:"
vercel login
echo ""

# Étape 2: Lier le projet
echo "📝 Étape 2: Lier le projet"
echo "---------------------------"
echo "Lier le projet au répertoire actuel..."
vercel link --yes
echo ""

# Étape 3: Importer les variables d'environnement
echo "📝 Étape 3: Importer les variables d'environnement"
echo "---------------------------------------------------"

# DATABASE_URL
echo "Ajout de DATABASE_URL..."
vercel env add DATABASE_URL production <<EOF
postgresql://neondb_owner:npg_Ix8lkoZCicd1@ep-cold-breeze-ai3lc5bl-pooler.c-4.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require
EOF

# JWT_SECRET
echo "Ajout de JWT_SECRET..."
JWT_SECRET=$(openssl rand -base64 32)
vercel env add JWT_SECRET production <<EOF
$JWT_SECRET
EOF

# NODE_ENV
echo "Ajout de NODE_ENV..."
vercel env add NODE_ENV production <<EOF
production
EOF

# CORS_ORIGIN
echo "Ajout de CORS_ORIGIN..."
vercel env add CORS_ORIGIN production <<EOF
https://iroko.vercel.app
EOF

echo ""
echo "✅ Variables d'environnement importées avec succès"
echo ""

# Étape 4: Récupérer les IDs
echo "📝 Étape 4: Récupérer les IDs Vercel"
echo "-------------------------------------"

# Récupérer l'Organization ID
ORG_ID=$(cat .vercel/project.json | grep -o '"orgId":"[^"]*"' | cut -d'"' -f4)
echo "Organization ID: $ORG_ID"

# Récupérer le Project ID
PROJECT_ID=$(cat .vercel/project.json | grep -o '"projectId":"[^"]*"' | cut -d'"' -f4)
echo "Project ID: $PROJECT_ID"

echo ""
echo "📝 Étape 5: Générer un token Vercel"
echo "-----------------------------------"
echo "Veuillez générer un token Vercel:"
echo "1. Allez sur https://vercel.com/account/tokens"
echo "2. Cliquez sur 'Create'"
echo "3. Nommez-le 'GitHub Actions'"
echo "4. Copiez le token"
echo ""
read -p "Collez le token Vercel ici: " VERCEL_TOKEN

echo ""
echo "✅ Configuration terminée avec succès!"
echo ""
echo "📋 Secrets GitHub à configurer:"
echo "================================"
echo "VERCEL_TOKEN=$VERCEL_TOKEN"
echo "VERCEL_ORG_ID=$ORG_ID"
echo "VERCEL_PROJECT_ID=$PROJECT_ID"
echo "DATABASE_URL=postgresql://neondb_owner:npg_Ix8lkoZCicd1@ep-cold-breeze-ai3lc5bl-pooler.c-4.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require"
echo "JWT_SECRET=$JWT_SECRET"
echo "CORS_ORIGIN=https://iroko.vercel.app"
echo ""
echo "📝 Prochaines étapes:"
echo "===================="
echo "1. Allez sur votre repository GitHub"
echo "2. Settings → Secrets and variables → Actions"
echo "3. Ajoutez les secrets ci-dessus"
echo "4. Pussez votre code sur GitHub"
echo "5. GitHub Actions se lancera automatiquement"
echo ""
echo "🎉 Prêt à déployer!"
