# IROKO - Plateforme de Services Digitale

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-green)
![License](https://img.shields.io/badge/License-Proprietary-red)
![Status](https://img.shields.io/badge/Status-MVP1-brightgreen)

IROKO est une **plateforme Flutter moderne** pour digitaliser les services en Côte d'Ivoire : soutien scolaire, recrutement et services d'entretien.

## 🎯 Services Offerts

### 📚 Soutien Scolaire
- Connexion d'élèves avec des tuteurs expérimentés
- Du primaire au lycée
- Filtrage par matière, niveau et localisation
- Système de réservation de créneaux
- Paiement sécurisé via escrow

### 💼 Recrutement
- Plateforme de job board pour personnel de maison et postes spécialisés
- CVthèque consultable et filtrable
- Système de candidature simplifié
- Alertes automatiques sur nouvelles offres

### 🧹 Services d'Entretien
- Réservation de services de nettoyage et entretien
- Flexibilité : ponctuel ou récurrent
- Prestataires vérifiés et notés
- Paiement sécurisé

## ✨ Fonctionnalités Principales

- ✅ **Authentification** : Login/Register avec email ou Google
- ✅ **Messagerie** : Chat sécurisé entre clients et prestataires
- ✅ **Système d'Escrow** : Paiements sécurisés et libération conditionnelle
- ✅ **Notation & Avis** : Système de confiance basé sur les évaluations
- ✅ **Profils Vérifiés** : KYC et vérification des compétences
- ✅ **Portefeuille Virtuel** : Gestion des gains pour prestataires
- ✅ **Notifications** : Alertes en temps réel
- ✅ **Mobile-First** : Interface optimisée pour smartphones

## 🚀 Démarrage Rapide

### Installation (30 sec)
```bash
# Cloner le projet
git clone https://github.com/Eudes8/iroko.git
cd iroko

# Installer les dépendances
flutter pub get

# Lancer sur web (sans SDK Android/iOS!)
flutter run -d chrome
```

**C'est tout!** L'application démarre sans avoir besoin du SDK Android ou iOS.

## 📚 Documentation

| Document | Description |
|----------|---|
| [🚀 GETTING_STARTED.md](GETTING_STARTED.md) | Guide de démarrage complet |
| [🏗️ ARCHITECTURE.md](ARCHITECTURE.md) | Architecture du projet et structure |
| [📡 API_DOCUMENTATION.md](API_DOCUMENTATION.md) | Documentation complète de l'API REST |
| [📋 CODE_STYLE_GUIDE.md](CODE_STYLE_GUIDE.md) | Conventions de code et best practices |
| [🗺️ ROADMAP.md](ROADMAP.md) | Roadmap et étapes de développement |

## 🏗️ Architecture

Le projet suit une **Clean Architecture** avec injection de dépendances.

## 🛠️ Stack Technologique

- **Flutter 3.0+** - Framework UI cross-platform
- **Dart 3.0+** - Langage de programmation
- **Dio** - Client HTTP
- **Provider** - Gestion d'état
- **GetIt** - Service Locator
- **Firebase** - Auth & Analytics
- **Stripe** - Paiements

## 🚀 Lancer sur d'autres platforms
```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web release
flutter run -d web --release
```

## 🎯 État du Projet

- ✅ Architecture complète (Clean Architecture)
- ✅ Authentification de base
- ✅ Écrans principaux (Login, Home, Profile, Booking)
- ✅ Repositories & UseCases
- ✅ HTTP Service avec Dio
- ⏳ Gestion d'état (Provider)
- ⏳ Tests unitaires
- ⏳ Intégration paiements

Voir [ROADMAP.md](ROADMAP.md) pour la roadmap complète.

## 🚨 Issues et Contributions

Pour contribuer au projet :
1. Fork le repository
2. Créer une branche (`git checkout -b feature/amazing`)
3. Commit les changements
4. Push et ouvrir une Pull Request

## 📄 Licence

Copyright © 2025 IROKO. Tous droits réservés.

## 🙏 Support

- 📧 Email: support@iroko.ci
- 📱 WhatsApp: +225 xx xx xx xx xx

---

<div align="center">

**[Démarrer](GETTING_STARTED.md)** • **[Architecture](ARCHITECTURE.md)** • **[Roadmap](ROADMAP.md)**

Fabriqué avec ❤️ pour la communauté ivoirienne

</div>
