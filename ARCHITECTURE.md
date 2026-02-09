# IROKO - Plateforme de Services Flutter

Une application Flutter moderne pour digitaliser les services IROKO : soutien scolaire, recrutement et entretien.

## 🎯 Vue d'ensemble du projet

IROKO est une plateforme de mise en relation entre clients et prestataires de services en Côte d'Ivoire. L'application supporte trois services principaux :

1. **Soutien Scolaire** - Mise en relation d'élèves avec des tuteurs expérimentés
2. **Recrutement** - Plateforme de job board pour personnel de maison et postes spércialisés
3. **Services d'Entretien** - Réservation de services d'entretien et nettoyage

## 🏗️ Architecture

Le projet suit une architecture **Clean Architecture** avec trois couches :

```
lib/
├── core/              # Logique partagée
│   ├── constants/     # Constantes de l'application
│   ├── theme/         # Thème et styles
│   ├── services/      # Services (HTTP, etc.)
│   └── utils/         # Utilitaires et exceptions
├── data/              # Couche données
│   ├── models/        # Modèles de données
│   ├── datasources/   # Sources de données
│   └── repositories/  # Implémentations des repositories
├── domain/            # Couche métier
│   ├── entities/      # Entités de domaine
│   └── usecases/      # Cas d'usage
└── presentation/      # Couche présentation
    ├── auth/          # Écrans d'authentification
    ├── home/          # Écran d'accueil
    ├── profile/       # Écrans de profil
    ├── services/      # Écrans spécifiques aux services
    └── widgets/       # Widgets réutilisables
```

## 📦 Dépendances principales

### State Management & Architecture
- `provider` - Gestion d'état réactive
- `get_it` - Service locator pour l'injection de dépendances

### Networking
- `dio` - Client HTTP avec intercepteurs
- `http` - Client HTTP alternatif

### Authentification
- `firebase_auth` - Authentification avec Firebase
- `google_sign_in` - Connexion Google

### Paiements
- `stripe_flutter` - Intégration Stripe pour paiements

### Stockage Local
- `hive` - Base de données NoSQL locale
- `shared_preferences` - Stockage de préférences simples

### Navigation
- `go_router` - Système de routing moderne

### Messagerie
- `socket_io_client` - Communication en temps réel via WebSocket

### UI
- `flutter_rating_bar` - Widgets de notation
- `image_picker` - Sélection d'images
- `flutter_svg` - Support des fichiers SVG
- `google_maps_flutter` - Intégration des cartes Google

### Utilitaires
- `intl` - Internationalisation et formatage de dates
- `flutter_validator` - Validation de formulaires

## 🚀 Configuration du projet

### Prérequis
- Flutter 3.0.0+
- Dart 3.0.0+

### Installation

```bash
# Cloner le repository
git clone <repository-url>
cd iroko

# Installer les dépendances
flutter pub get

# Générer les fichiers générés
flutter pub run build_runner build

# Lancer l'application (web)
flutter run -d chrome
```

## 📱 Fonctionnalités principales

### Authentication
- ✅ Login avec email/password
- ✅ Inscription avec sélection de rôle (client/prestataire)
- ✅ Connexion Google
- ✅ Récupération de mot de passe
- ✅ Gestion de session
- ✅ Vérification d'identité (KYC)

### Services - Soutien Scolaire
- ✅ Recherche de tuteurs par matière et niveau
- ✅ Filtrage par localisation
- ✅ Gestion du calendrier de disponibilités
- ✅ Réservation de créneaux
- ✅ Système de paiement sécurisé (Escrow)

### Services - Recrutement
- ✅ Publication d'offres d'emploi
- ✅ CVthèque avec filtrage
- ✅ Système de candidature
- ✅ Alertes de nouvelles offres

### Services - Entretien
- ✅ Recherche d'agents d'entretien
- ✅ Réservation ponctuelle ou récurrente
- ✅ Gestion des prestations
- ✅ Paiement à la demande

### Fonctionnalités Transversales
- ✅ Messagerie instantanée
- ✅ Système de notation et avis
- ✅ Portefeuille virtuel pour prestataires
- ✅ Gestion d'escrow pour les paiements
- ✅ Notifications locales et push

## 🔧 Configuration des services

### HTTP Service
Le service HTTP gère l'authentification, les requêtes et les erreurs :

```dart
// Utilisation
final httpService = GetIt.I<HttpService>();
final response = await httpService.get('/missions/search');
```

### Repositories
Les repositories encapsulent la logique d'accès aux données :

```dart
// AuthRepository
Future<User> login(String email, String password);
Future<User> register({...});

// MissionRepository
Future<List<Mission>> searchMissions({...});
Future<Mission> createMission({...});
```

### UseCases
Les cas d'usage contiennent la logique métier :

```dart
// Exempleutilisation
final loginUseCase = GetIt.I<LoginUseCase>();
final user = await loginUseCase(LoginParams(email, password));
```

## 💳 Intégration des paiements

Les paiements utilisent un système d'escrow :

1. **Client** paie la plateforme
2. **Argent** est conservé en escrow
3. **Prestataire** effectue le service
4. **Client** valide le service
5. **Prestataire** reçoit le paiement (moins commission IROKO)

La commission IROKO est configurable dans le Back-Office (défaut : 15%).

## 🎨 Thème et Design

Le projet utilise un système de thème centralisé :

```dart
// Couleurs
AppTheme.primaryColor      // Vert IROKO
AppTheme.secondaryColor    // Orange
AppTheme.errorColor        // Rouge
AppTheme.successColor      // Vert

// Espacements
AppTheme.spacingSmall      // 8px
AppTheme.spacingMedium     // 16px
AppTheme.spacingLarge      // 24px
```

## 📊 Modèles de données

### User
```dart
User {
  id, email, name, phone, profileImage, role,
  bio, averageRating, reviewCount, isVerified,
  createdAt, updatedAt
}
```

### Provider (extends User)
```dart
Provider extends User {
  specialties, hourlyRate, location,
  certifications, providerType
}
```

### Mission
```dart
Mission {
  id, clientId, providerId, serviceType, title,
  description, category, level, scheduledDate,
  durationMinutes, price, commission, status,
  paymentStatus, clientRating, providerRating,
  createdAt, updatedAt, completedAt
}
```

## 🔒 Sécurité

- ✅ HTTPS partout
- ✅ Tokens JWT pour authentification
- ✅ Validation des entrées
- ✅ Protection OWASP Top 10
- ✅ Paiements via prestataire PCI DSS

## 📱 Tests

Pour tester l'application en web sans SDK :

```bash
# Web (sans besoin Android SDK ou iOS SDK)
flutter run -d chrome

# Configuration pour le web
# Le fichier pubspec.yaml a flutter_web:
#   use_wasm: false
```

## 🚦 État du projet

- ✅ Architecture de base
- ✅ Models et Entities
- ✅ Repositories
- ✅ UseCases
- ✅ Écrans d'authentification
- ✅ Écran d'accueil
- ✅ Écran de profil
- ⏳ Intégration des paiements
- ⏳ Messagerie en temps réel
- ⏳ Gestion d'état complète
- ⏳ Tests unitaires et d'intégration

## 🔄 Prochaines étapes

1. **Implémentation des BLOCs/Providers** pour la gestion d'état
2. **Intégration du système de notifications**
3. **Implémentation complète des écrans**
4. **Tests unitaires et d'intégration**
5. **Déploiement sur Android et iOS**
6. **Optimisations de performance**

## 📞 Support

Pour toute question ou problème :
- Email : support@iroko.ci
- Documentation : [lien vers la doc]

## 📄 Licence

Copyright © 2025 IROKO. Tous droits réservés.

---

**Développé avec ❤️ pour la communauté ivoirienne**
