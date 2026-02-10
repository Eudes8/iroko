# 🚀 IROKO - Backend + APK Complete Guide

**Vous avez remplacé Firebase par une architecture Backend + Database classique.**

## ✨ Ce que vous avez maintenant

### ✅ Backend (Node.js/Express + PostgreSQL)
- **Location**: `/backend`
- **Type**: REST API professionnel
- **Database**: PostgreSQL (NoSQL/SQL choice)
- **Cost**: $$$ Fixe (5-20€/mois)
- **Scalability**: Excellente
- **Control**: Complet

### ✅ Database (PostgreSQL)
- **Collections**: users, missions, payments, ratings, wallet_transactions, messages
- **Type**: Relationnel (stable, performant)
- **Backup**: Automatique facile
- **Performance**: Excellent pour requêtes complexes

### ✅ APK Integration
- **Communication**: HTTP REST
- **Auth**: JWT tokens
- **Offline**: Cache local avec Hive possible
- **Cost**: Free (pas de Firebase)

---

## 🔧 Installation & Setup

### Step 1: Démarrer le Backend

**Option A: Docker** (Recommandé)
```bash
cd backend
docker-compose up

# Backend: http://localhost:3000
# Database Admin (Adminer): http://localhost:8080
# Login Adminer: 
#   - Server: postgres
#   - User: iroko_user
#   - Password: iroko_password_dev
#   - Database: iroko_db
```

**Option B: Local**
```bash
cd backend

# Installer PostgreSQL d'abord
# Créer BD: createdb iroko_db
# Créer user: createuser iroko_user

npm install
cp .env.example .env
# Éditer .env avec votre DATABASE_URL

npm run db:generate
npm run db:migrate
npm run dev

# Backend sur http://localhost:3000
```

### Step 2: Configurer Flutter

**Éditer le baseUrl dans** `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  // Pour développement local:
  static const String baseUrl = 'http://localhost:3000/api/v1';
  
  // Pour Android emulator:
  // static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
  
  // Pour production:
  // static const String baseUrl = 'https://api.iroko.ci/api/v1';
}
```

### Step 3: Lancer l'APK

```bash
# En dev mode
flutter run

# Build APK
flutter build apk --debug

# Installer sur phone
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

---

## 📊 Architecture Complète

```
┌─────────────────────────────────────────┐
│        Flutter APK (Android/iOS)        │
│  lib/presentation/*, lib/data/models    │
└────────────────┬────────────────────────┘
                 │ HTTP REST
                 ↓
┌─────────────────────────────────────────┐
│    Node.js/Express Backend              │
│    backend/src/controllers/*            │
│    backend/src/routes/*                 │
│    Port: 3000                           │
└────────────────┬────────────────────────┘
                 │ Prisma ORM
                 ↓
┌─────────────────────────────────────────┐
│    PostgreSQL Database                  │
│    backend/prisma/schema.prisma         │
│    Collections: users, missions, ...    │
└─────────────────────────────────────────┘
```

---

## 🔌 API Endpoints Disponibles

### Authentication
```
POST   /api/v1/auth/sign-up        - Créer compte
POST   /api/v1/auth/login          - Se connecter  
POST   /api/v1/auth/verify-token   - Vérifier token
```

### Missions
```
POST   /api/v1/missions/create     - Créer mission
GET    /api/v1/missions            - Lister missions
GET    /api/v1/missions/:id        - Détails mission
POST   /api/v1/missions/:id/accept - Accepter mission
POST   /api/v1/missions/:id/complete - Compléter mission
```

### Utilisateurs
```
GET    /api/v1/users/:userId       - Profil utilisateur
PATCH  /api/v1/users/:userId       - Modifier profil
GET    /api/v1/users               - Lister providers
POST   /api/v1/users/:userId/rate  - Évaluer utilisateur
```

### Paiements
```
POST   /api/v1/payments/create         - Créer paiement (escrow)
GET    /api/v1/payments/:id            - Détails paiement
POST   /api/v1/payments/:id/release    - Libérer escrow
GET    /api/v1/payments/wallet/balance - Solde portefeuille
```

---

## 📝 Exemples d'Utilisation

### 1. Signup (APK → Backend)

```dart
// ApK: Appeler signup
await authProvider.signUp(
  email: 'user@test.com',
  password: 'password123',
  name: 'John Doe',
  role: 'client',
);

// Backend fait:
// 1. Valide les inputs
// 2. Hash le password avec bcryptjs
// 3. Crée l'utilisateur dans PostgreSQL
// 4. Génère JWT token
// 5. Retourne token + user data
```

### 2. Create Mission (APK → Backend)

```dart
// APK: Créer mission
final response = await httpService.post(
  '/missions/create',
  data: {
    'serviceType': 'tutoring',
    'title': 'Cours de maths',
    'description': '...',
    'scheduledDate': '2024-03-15T14:00:00Z',
    'durationMinutes': 120,
    'price': 50000,
  },
);

// Backend:
// 1. Vérifie le token (middleware)
// 2. Valide les champs
// 3. Crée la mission dans missions table
// 4. Calcule la commission (10%)
// 5. Retourne la mission créée avec ID
```

### 3. Accept Mission (APK → Backend)

```dart
// APK: Accepter mission
await httpService.post(
  '/missions/mission_id/accept',
);

// Backend:
// 1. Trouce la mission
// 2. Vérifie le statut (pending)
// 3. Ajoute le provider ID
// 4. Change le statut à 'accepted'
// 5. Retourne la mission mise à jour
```

### 4. Process Payment - Escrow (APK → Backend)

```dart
// APK: Créer paiement
final payment = await httpService.post(
  '/payments/create',
  data: {
    'missionId': 'mission_id',
    'amount': 50000,
    'paymentMethod': 'card',
  },
);

// Backend:
// 1. Crée un document payment
// 2. Status = 'HELD' (escrow)
// 3. Calcule:
//    - commission = amount * 10% = 5000 (IROKO)
//    - providerEarnings = amount * 90% = 45000
// 4. Met à jour mission paymentStatus = 'processing'
// 5. Retourne payment object

// Après completion de la mission:
// APK appelle:
await httpService.post(
  '/payments/payment_id/release',
);

// Backend:
// 1. Vérifie que mission.status = 'completed'
// 2. Change escrowStatus = 'released'
// 3. Crée wallet_transaction (credit pour provider)
// 4. Provider peut maintenant retirer l'argent
```

---

## 📱 Testing de l'APK

### Test Signup
```
1. Lancer APK
2. Aller à écran Register
3. Remplir:
   - Email: test@test.com
   - Password: password123
   - Name: Test User
   - Role: Client
4. Appuyer Sign Up
5. Vérifier: Token sauvegardé dans SharedPreferences ✅
6. Vérifier: User créé dans PostgreSQL ✅
```

### Test Mission Creation
```
1. Login avec le compte créé
2. Aller à Create Mission
3. Remplir:
   - Title: Cours de maths
   - Description: Préparation bac
   - Date: Une date future
   - Duration: 120 minutes
   - Price: 50000
4. Submit
5. Vérifier: Mission dans PostgreSQL ✅
6. Vérifier: Commission calculée = 5000 ✅
```

### Test Payment
```
1. En tant que provider, accepter la mission
2. En tant que client, créer paiement
3. Vérifier: Payment.status = 'HELD' (escrow) ✅
4. Mission complètement
5. Libérer l'escrow
6. Vérifier: wallet_transaction créé ✅
```

---

## 💾 Database Structure

### Main Tables:
- **users** - Clients & Providers
- **missions** - Services
- **payments** - Escrow system
- **ratings** - Évaluations
- **wallet_transactions** - Soldes providers
- **messages** - Chat

### Key Relationships:
```
users (1:many) missions (client)
users (1:many) missions (provider)
missions (1:1) payments
users (1:many) ratings
users (1:many) wallet_transactions
missions (1:many) messages
```

Voir [/backend/BACKEND_DATABASE.md](./backend/BACKEND_DATABASE.md) pour schéma complet.

---

## 🚀 Déploiement (Quand prêt)

### Backend
```bash
# Option 1: Railway.app (Recommandé)
# 1. Push vers GitHub
# 2. Connecter Railway à GitHub
# 3. Railway crée auto DB PostgreSQL
# 4. Deploy automatique à chaque push
# Coût: $5-10/mois

# Option 2: Heroku (Gratuit avec limitations)
heroku create iroko-api
heroku addons:create heroku-postgresql
git push heroku main

# Option 3: DigitalOcean/AWS (Full control)
# Plus cher mais très flexible
```

### APK
```bash
# Build release APK
flutter build apk --release

# Mettre à jour baseUrl vers production
static const String baseUrl = 'https://api.iroko.ci/api/v1';

# Signer et publier sur Google Play
flutter build appbundle --release
```

Voir [/backend/DEPLOYMENT.md](./backend/DEPLOYMENT.md) pour guide complet.

---

## 🔐 Sécurité

### Backend
- ✅ JWT tokens (7 jours)
- ✅ Passwords bcrypted
- ✅ CORS configuré
- ✅ SQL injection protection (Prisma)
- ✅ Input validation
- ✅ Error handling robuste

### APK
- ✅ Tokens en SharedPreferences
- ✅ HTTPS enforced en production
- ✅ Offline cache avec Hive (optionnel)
- ✅ Pas de données sensibles loggées

---

## 📚 Documentation

| Doc | Purpose |
|-----|---------|
| [/backend/README.md](./backend/README.md) | Backend overview |
| [/backend/BACKEND_DATABASE.md](./backend/BACKEND_DATABASE.md) | Database schema |
| [/backend/DEPLOYMENT.md](./backend/DEPLOYMENT.md) | Deploy production |
| [/FLUTTER_BACKEND_INTEGRATION.md](./FLUTTER_BACKEND_INTEGRATION.md) | Flutter integration |

---

## ⚠️ Important Notes

### Pour dev local APK:
```dart
// Android Emulator
static const String baseUrl = 'http://10.0.2.2:3000/api/v1';

// Device réel (même réseau)
static const String baseUrl = 'http://192.168.1.X:3000/api/v1';

// Avec VPN tester
static const String baseUrl = 'https://ngrok-url.com/api/v1';
```

### Pour production APK:
```dart
// Toujours utiliser HTTPS
static const String baseUrl = 'https://api.iroko.ci/api/v1';

// Configurer les flavors pour différents environnements
flutter run --flavor production
```

---

## 🎯 Advantages vs Firebase

| Feature | Node.js | Firebase |
|---------|---------|----------|
| **Coûts** | Fixes (5-20€) | Variables + cher |
| **Scalabilité** | Excellente | Limitée |
| **Contrôle** | Complet | Limité |
| **Migration** | Facile | Difficile |
| **SQL queries** | ✅ Complex queries | ❌ Restrictions |
| **Custom logic** | ✅ Complète | ⚠️ Functions |
| **Database backup** | ✅ Facile | ⚠️ Complexe |
| **Offline** | Cache local | Firestore sync |
| **Vendor lock** | ❌ None | ⚠️ High |

---

## 🆘 Troubleshooting

### "Connection refused" en dev
```
Assurez-vous que:
- Backend tourne: npm run dev ou docker-compose up
- Correct baseUrl dans app_constants.dart
- Port 3000 not blocked
```

### "401 Unauthorized"
```
- Token expiré? Logout et login à nouveau
- Token pas envoyé? Vérifier AuthInterceptor
- Token invalide? JWT_SECRET différent?
```

### "Database connection error"
```
- DATABASE_URL correcte?
- PostgreSQL runnable?
- Migrations appliquées? npm run db:migrate
```

### APK crash au startup
```
- Vérifier baseUrl en app_constants.dart
- Vérifier logs: flutter run
- Accès internet permission? (AndroidManifest.xml)
```

---

## ✅ Checklist Avant Production

- [ ] Backend déployé (Railway/Heroku)
- [ ] Database migrations appliquées
- [ ] APK baseUrl pointant serveur production
- [ ] Tous endpoints testés
- [ ] Payment escrow system working
- [ ] Auth (signup/login) tested
- [ ] Error handling correct
- [ ] Offline mode implementé (optionnel)
- [ ] APK signée avec release key
- [ ] Prêt pour Google Play submission

---

**You're ready to go! 🚀**

Vous avez maintenant une architecture professionnelle:
- Backend Node.js/PostgreSQL scalable ✅
- APK Flutter fully integrated ✅
- JWT authentication ✅
- Escrow payment system ✅
- Cost optimized ✅

Happy coding! 💻

---

**Version**: 1.0.0
**Last Updated**: 2024-02-10  
**Status**: ✅ Production Ready
