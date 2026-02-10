#!/bin/bash
# Script de build pour Flutter Web (Vercel)

set -e

echo "🚀 Début du build Flutter Web pour Vercel..."

# Vérifier que Flutter est installé
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé. Veuillez installer Flutter d'abord."
    exit 1
fi

echo "📦 Version Flutter: $(flutter --version | head -n 1)"

# Nettoyer le build précédent
echo "🧹 Nettoyage du build précédent..."
flutter clean

# Récupérer les dépendances
echo "📥 Récupération des dépendances..."
flutter pub get

# Build pour le web
echo "🔨 Build Flutter Web..."
flutter build web --release

echo "✅ Build terminé avec succès!"
echo "📁 Les fichiers sont dans le dossier 'build/web'"
