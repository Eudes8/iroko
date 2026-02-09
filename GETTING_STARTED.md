# Guide de Démarrage - IROKO Flutter App

## 📋 Prérequis

- **Flutter** : 3.0.0 ou plus récent
- **Dart** : 3.0.0 ou plus récent
- **Git** : Pour cloner le repository

### Installation de Flutter

Suivez les instructions officielles : https://flutter.dev/docs/get-started/install

Vérifiez votre installation :
```bash
flutter --version
dart --version
```

## 🚀 Premiers pas

### 1. Cloner le repository

```bash
git clone https://github.com/Eudes8/iroko.git
cd iroko
```

### 2. Installer les dépendances

```bash
# Télécharger les dépendances Pub
flutter pub get

# (Optionnel) Générer les fichiers générés par build_runner
flutter pub run build_runner build
```

### 3. Lancer l'application (Web - Sans SDK requis)

```bash
# Lancer sur Chrome (plus simple, pas de SDK requis!)
flutter run -d chrome

# Ou lancer une version web générale
flutter run -d web-server
```

**L'avantage du web :** Vous n'avez besoin ni du SDK Android ni du SDK iOS pour tester !

### 4. (Optionnel) Lancer sur Android/iOS

#### Android
```bash
# Nécessite le SDK Android
flutter run -d android
```

#### iOS
```bash
# Nécessite Xcode (macOS seulement)
flutter run -d ios
```

## 📱 Structure du projet

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart      # Constantes globales
│   ├── services/
│   │   └── http_service.dart       # Service HTTP avec Dio
│   ├── theme/
│   │   └── app_theme.dart          # Thème de l'application
│   └── utils/
│       └── exceptions.dart         # Types d'exceptions personnalisés
│
├── data/
│   ├── models/
│   │   ├── user_model.dart         # Modèles des utilisateurs
│   │   └── mission_model.dart      # Modèles des missions
│   └── repositories/
│       ├── auth_repository.dart    # Logique d'authentification
│       └── mission_repository.dart # Logique des missions
│
├── domain/
│   ├── entities/
│   │   ├── user.dart               # Entité User
│   │   └── mission.dart            # Entité Mission
│   └── usecases/
│       ├── auth_usecases.dart      # Cas d'usage d'auth
│       └── mission_usecases.dart   # Cas d'usage des missions
│
├── presentation/
│   ├── auth/
│   │   └── login_screen.dart       # Écran de connexion
│   ├── home/
│   │   └── home_screen.dart        # Écran d'accueil
│   ├── profile/
│   │   └── provider_profile_screen.dart  # Profil prestataire
│   └── widgets/
│       └── booking_screen.dart     # Écran de réservation
│
└── main.dart                        # Point d'entrée de l'application
```

## 🔑 Configuration API

### Par défaut
L'application est configurée pour se connecter à :
```
Base URL: https://api.iroko.ci/v1
Socket URL: https://socket.iroko.ci
```

### Pour le développement local
Modifiez le `baseUrl` dans [lib/core/constants/app_constants.dart](lib/core/constants/app_constants.dart) :

```dart
static const String baseUrl = 'http://localhost:3000/v1';
static const String socketUrl = 'http://localhost:3000';
```

## 🔑 Variables d'environnement

Créez un fichier `.env` à la racine du projet (optionnel) :

```env
API_BASE_URL=https://api.iroko.ci/v1
SOCKET_URL=https://socket.iroko.ci
STRIPE_PUBLIC_KEY=pk_...
STRIPE_SECRET_KEY=sk_...
GOOGLE_SIGN_IN_WEB_CLIENT_ID=...
```

## 🏃 Exécution avec des options

### Mode Debug
```bash
flutter run -d chrome
```

### Mode Release (optimisé, plus rapide)
```bash
flutter run -d chrome --release
```

### Avec logs détaillés
```bash
flutter run -d chrome --verbose
```

### Profil de performance
```bash
flutter run -d chrome --profile
```

## 🧪 Tests

### Tests unitaires
```bash
flutter test
```

### Tests spécifiques
```bash
flutter test test/domain/usecases/auth_usecases_test.dart
```

### Avec couverture
```bash
flutter test --coverage
```

## 🔧 Dépannage

### L'application ne démarre pas
```bash
# Nettoyer le cache
flutter clean

# Réinstaller les dépendances
flutter pub get

# Relancer
flutter run -d chrome
```

### Erreurs de build
```bash
# Mettre à jour Flutter
flutter upgrade

# Mettre à jour les packages
flutter pub upgrade

# Vérifier les dépendances
flutter pub outdated
```

### Problèmes de localhost
```bash
# Si Chrome ne peut pas accéder à localhost:
# Vérifier que le port est disponible
# Ou spécifier un port différent
flutter run -d chrome --web-port=8081
```

## 📚 Architecture Pattern

Le projet suit **Clean Architecture** :

- **Presentation Layer** : Widgets, écrans, gestion d'état
- **Domain Layer** : Entities, UseCases, Repositories abstraits
- **Data Layer** : Models, Repository implémentations, HTTP calls

```
ShowLogin → LoginScreen → LoginUseCase → AuthRepository → HttpService → API
   ↓
GetCurrentUser → HomeScreen ← GetCurrentUserUseCase ← AuthRepository
```

## 💡 Patterns utilisés

### Service Locator (GetIt)
```dart
final userRepository = GetIt.I<AuthRepository>();
```

### Dependency Injection
```dart
// Dans main.dart
getIt.registerSingleton<LoginUseCase>(
  LoginUseCase(getIt<AuthRepository>()),
);
```

### Model + Entity
```dart
// UserModel (data layer) ↔ User (domain layer)
User user = UserModel.fromJson(jsonData);
```

## 🔄 Flux de développement recommandé

### 1. Implémenter la logique métier
Créer les enteties et use cases dans `domain/`

### 2. Implémenter l'accès aux données
Créer les models et repositories dans `data/`

### 3. Ajouter les services
Implémenter les appels HTTP dans `core/services/`

### 4. Créer l'interface utilisateur
Développer les écrans dans `presentation/`

### 5. Connecter via GetIt
Enregistrer les dépendances dans `main.dart`

## 📖 Documentation supplémentaire

- [Architecture détaillée](ARCHITECTURE.md)
- [Documentation API](API_DOCUMENTATION.md)
- [Cahier des charges](SPECIFICATIONS.md)

## 🆘 Support et Questions

### Ressources utiles
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Clean Architecture](https://resocoder.com/flutter-clean-architecture)

### Issues
Signalez les problèmes via GitHub Issues

## ✅ Checklist pour démarrer

- [ ] Flutter installé et à jour
- [ ] Repository cloné
- [ ] `flutter pub get` exécuté
- [ ] Aucune erreur avec `flutter doctor`
- [ ] L'app démarre avec `flutter run -d chrome`
- [ ] Vous voyez l'écran de connexion
- [ ] Vous pouvez naviguer dans les écrans

## 🎉 Félicitations!

Vous êtes prêt à développer l'application IROKO! 

Commencez par explorer la structure du projet et modifiez les fichiers selon vos besoins.

---

**Dernière mise à jour:** 9 février 2025

**Questions?** Consultez la documentation ou ouvrez une issue sur GitHub
