# 🚀 Checklist Déploiement IROKO Backend + DB

Guide pas-à-pas pour déployer le backend Firebase et configurer Firestore.

## Phase 1: Préparation Firebase

### ✅ 1. Créer le projet Firebase
- [ ] Aller sur https://console.firebase.google.com
- [ ] Créer nouveau projet: `iroko-platform`
- [ ] Région: europe-west1 (Belgique)
- [ ] Activer Google Analytics (optionnel)

### ✅ 2. Récupérer les identifiants
- [ ] Aller à Paramètres → Configuration
- [ ] Copier le bloc de configuration Firebase
- [ ] Sauvegarder dans `/functions/.env`

```env
FIREBASE_PROJECT_ID=iroko-platform
FIREBASE_API_KEY=AIzaSy...
FIREBASE_AUTH_DOMAIN=iroko-platform.firebaseapp.com
FIREBASE_STORAGE_BUCKET=iroko-platform.appspot.com
FIREBASE_MESSAGING_SENDER_ID=...
FIREBASE_APP_ID=...
```

### ✅ 3. Activer services Firebase
- [ ] Authentication > Email/Password
- [ ] Authentication > Google Sign-In (optionnel)
- [ ] Firestore Database (Production mode)
- [ ] Cloud Functions
- [ ] Cloud Storage (images)

---

## Phase 2: Configuration Firestore

### ✅ 4. Créer la base de données Firestore
- [ ] Firestore Database > Créer base
- [ ] Mode: **Production** (ou Development pour dev)
- [ ] Région: **europe-west1**
- [ ] Attendre l'initialisation (~2 minutes)

### ✅ 5. Importer les règles de sécurité
- [ ] Aller à Firestore > Rules
- [ ] Copier le contenu de `/firebase/firestore.rules`
- [ ] Publier les règles

```bash
firebase deploy --only firestore:rules
```

### ✅ 6. Créer les indexes Firestore
- [ ] Importer `/firebase/firestore.indexes.json`
- [ ] Ou créer manuellement depuis Console → Indexes

---

## Phase 3: Cloud Functions

### ✅ 7. Préparer l'environnement local
```bash
# Installer Firebase CLI
npm install -g firebase-tools

# Se connecter
firebase login

# Sélectionner le projet
firebase use iroko-platform

# Vérifier
firebase projects:list
```

### ✅ 8. Tester localement
```bash
cd functions
npm install

# Démarrer les émulateurs
npm run serve

# Vérifier dans une autre terminal
curl http://localhost:5001/iroko-platform/europe-west1/api/health
```

Doit retourner:
```json
{
  "status": "ok",
  "message": "IROKO Backend is running",
  "timestamp": "2024-02-10T..."
}
```

### ✅ 9. Déployer les Cloud Functions
```bash
# Compiler TypeScript
npm run build

# Déployer
firebase deploy --only functions

# Vérifier le déploiement
firebase functions:log
```

Les fonction sont maintenant accessibles sur:
```
https://europe-west1-iroko-platform.cloudfunctions.net/api/v1
```

---

## Phase 4: Configuration Flutter

### ✅ 10. Installer dépendances Firebase
```bash
cd /workspaces/iroko

# Ajouter les packages
flutter pub add firebase_core firebase_auth firebase_firestore cloud_functions

# Configurer Firebase pour Flutter
flutterfire configure --project=iroko-platform
```

### ✅ 11. Mettre à jour AppConstants
Éditer `lib/core/constants/app_constants.dart`:

```dart
static const String baseUrl = 'https://europe-west1-iroko-platform.cloudfunctions.net/api/v1';
static const String firebaseProjectId = 'iroko-platform';
// ... autres constantes
```

### ✅ 12. Initialiser Firebase dans main.dart
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

### ✅ 13. Tester la connexion
```bash
# Lancer l'app
flutter run -d chrome

# Tester signup
# Tester login
# Vérifier les logs Firebase
```

---

## Phase 5: Tests Integration

### ✅ 14. Tester Signup
```bash
POST /api/v1/auth/sign-up
{
  "email": "test@example.com",
  "password": "password123",
  "name": "Test User",
  "role": "client"
}
```

Résultat attendu: ✅ User créé dans Firestore

### ✅ 15. Tester Login
```bash
POST /api/v1/auth/login
{
  "email": "test@example.com",
  "password": "password123"
}
```

Résultat attendu: ✅ Token retourné

### ✅ 16. Tester Missions
```bash
POST /api/v1/missions/create
Headers: Authorization: Bearer <token>
{
  "serviceType": "tutoring",
  "title": "Cours de maths",
  "description": "...",
  "scheduledDate": "2024-03-15T14:00:00Z",
  "durationMinutes": 120,
  "price": 50000
}
```

Résultat attendu: ✅ Mission créée dans Firestore

### ✅ 17. Tester Paiements
```bash
POST /api/v1/payments/create
Headers: Authorization: Bearer <token>
{
  "missionId": "mission_id",
  "amount": 50000,
  "paymentMethod": "card"
}
```

Résultat attendu: ✅ Paiement créé en escrow

---

## Phase 6: Configuration Production

### ✅ 18. Configurer les secrets
```bash
# Dans Firebase Console > Functions > Runtime settings
# Ou via gcloud:

gcloud functions deploy api --runtime nodejs18 \
  --set-env-vars STRIPE_SECRET_KEY=sk_live_...

# Vérifier
firebase functions:log
```

### ✅ 19. Configurer les limites de quota
- [ ] Firestore: Enable billing if needed
- [ ] Functions: Set memory to 512MB
- [ ] Storage: Set upload limit

### ✅ 20. Activer CORS correctement
Éditer `functions/src/index.ts`:
```typescript
const corsOptions = {
  origin: ['https://iroko.ci', 'https://app.iroko.ci'],
  credentials: true
};
app.use(cors(corsOptions));
```

### ✅ 21. Configurer les backups Firestore
- [ ] Firestore > Backups > Create backup
- [ ] Schedule: Daily
- [ ] Retention: 30 days

---

## Phase 7: Monitoring

### ✅ 22. Configurer les logs
```bash
# Voir les logs en temps réel
firebase functions:log --follow

# Exporter les logs
firebase functions:log > backend.log
```

### ✅ 23. Configurer les alertes
Dans Cloud Console:
- [ ] Alerts > Create policy
- [ ] Trigger: Function errors > 5 errors/min
- [ ] Action: Email notification

### ✅ 24. Configurer les métriques
- [ ] Cloud Monitoring > Dashboards
- [ ] Ajouter graphiques:
  - Function execution time
  - Firestore read/write operations
  - Errors count

---

## Phase 8: Documentation

### ✅ 25. Mise à jour documenta
- [ ] Mettre à jour `BACKEND_FIREBASE.md` si changements
- [ ] Mettre à jour les secrets du team
- [ ] Créer documentation API (Postman collection)

### ✅ 26. Onboarding team
- [ ] Créer guide de développement local
- [ ] Montrer comment utiliser emulators
- [ ] Setup pour chaque développeur

---

## 🚨 Checklist de Sécurité

### ✅ 27. Sécurité Firestore
- [ ] Vérifier firestore.rules (pas de `allow read, write: if true`)
- [ ] Activer "Require authentication"
- [ ] Vérifier les composites indexes

### ✅ 28. Sécurité Cloud Functions
- [ ] Valider TOUS les inputs
- [ ] Vérifier les permissions (isOwner, etc)
- [ ] Rate limiting activé
- [ ] CORS restrictif

### ✅ 29. Sécurité Storage
- [ ] Vérifier les règles d'accès
- [ ] Limiter la taille des uploads
- [ ] Nettoyer les fichiers orphelins

### ✅ 30. Sécurité Flutter
- [ ] Ne pas hardcoder les secrets
- [ ] Utiliser keystore Android
- [ ] Utiliser Keychain iOS
- [ ] Obfusquer le code

---

## ✅ Validation Finale

### ✅ 31. Health Check Production
```bash
# Tester toutes les endpoints
curl https://europe-west1-iroko-platform.cloudfunctions.net/api/v1/health
```

Doit retourner `status: ok`

### ✅ 32. Performance Check
```bash
# Tester la latence
ab -n 100 -c 10 https://europe-west1-iroko-platform.cloudfunctions.net/api/v1/health

# Doit faire <500ms par requête
```

### ✅ 33. Sécurité Check
```bash
# Vérifier les erreurs ne leak pas les infos
curl https://...../api/v1/unauthorized

# Doit pas retourner de stack trace
```

### ✅ 34. Firestore Check
```bash
# Vérifier que documents sont bien créés
firebase firestore:list-databases
firebase firestore:count-data

# Doit montrer les collections
```

---

## 🎉 Done!

Votre backend Firebase est maintenant en production! 🚀

### Points de contact

| Composant | Console |
|-----------|---------|
| Firestore | https://console.firebase.google.com → Firestore |
| Functions | https://console.firebase.google.com → Functions |
| Logs | `firebase functions:log --follow` |
| Erreurs | Firebase Console → Errors |

### Monitoring continue

```bash
# Schedules daily check
0 9 * * * firebase functions:log > /var/log/iroko-backend.log

# Weekly backup
0 0 * * 0 gcloud firestore databases backup create
```

---

**Status**: ✅ Ready for production
**Last Updated**: 2024-02-10
**Version**: 1.0.0
