# 🚀 Guide de Configuration - IROKO

Guide rapide pour configurer IROKO avec Vercel et GitHub Actions.

---

## 📋 Prérequis

- Compte GitHub avec le repository IROKO
- Compte Vercel (gratuit)
- GitHub CLI installé

---

## 🎯 Étapes de Configuration

### 1. Configurer les Secrets GitHub (5 min)

Exécutez le script automatique:

```bash
./setup-github-secrets.sh
```

Le script va:
- Installer GitHub CLI si nécessaire
- Vous connecter à GitHub
- Ajouter automatiquement tous les secrets nécessaires

### 2. Pousser le Code (2 min)

```bash
git add .
git commit -m "Setup: GitHub Actions configuration"
git push origin main
```

### 3. Attendre le Déploiement Automatique (5-10 min)

GitHub Actions se lancera automatiquement:
- ✅ Build Android APK
- ✅ Deploy to Vercel
- ✅ Create Release

### 4. Télécharger l'APK (2 min)

Allez sur **Releases** dans votre repository GitHub et téléchargez `app-release.apk`

---

## 🌐 URLs de Production

- **Frontend:** `https://iroko.vercel.app`
- **API:** `https://iroko.vercel.app/api`
- **Health:** `https://iroko.vercel.app/api/health`

---

## 🔄 Déploiements Futurs

Chaque `git push` déclenchera automatiquement le déploiement:

```bash
git add .
git commit -m "Nouvelle fonctionnalité"
git push origin main
```

---

## 📚 Documentation

- **README:** [`README.md`](README.md)
- **API:** [`API_DOCUMENTATION.md`](API_DOCUMENTATION.md)
- **Architecture:** [`ARCHITECTURE.md`](ARCHITECTURE.md)

---

**Temps estimé:** 15-20 minutes
**Coût total:** $0/mois 💰
