# 🚀 IROKO Backend - Node.js + PostgreSQL

Backend professionnel pour IROKO, construit avec Node.js/Express et PostgreSQL.

## 📋 Avantages vs Firebase

| Aspect | Node.js + PostgreSQL | Firebase |
|--------|-------------------|----------|
| **Coûts** | $$$ Fixes (serveur) | $$$$ Variables |
| **Scalabilité** | ✅ Excellente | ⚠️ Limitée |
| **Contrôle** | ✅ Total | ❌ Limité |
| **Flexibilité** | ✅ Totale | ⚠️ Restreinte |
| **Customisation** | ✅ Complète | ❌ Limitée |
| **Migration data** | ✅ Facile | ❌ Difficile |
| **Offline** | ✅ Cache local | ⚠️ Firestore sync |

## 🏗️ Architecture

```
Flutter App (APK)
    ↓
HTTP REST API (Node.js/Express)
    ↓
PostgreSQL Database
```

## 🚀 Démarrage rapide

### Option 1: Docker (Recommandé)

```bash
cd backend

# Démarrer tout (DB + API)
docker-compose up

# La API est sur http://localhost:3000
# Adminer UI: http://localhost:8080 (postgres/iroko_password_dev)
```

### Option 2: Installation locale

```bash
cd backend

# Installer dépendances
npm install

# Créer .env
cp .env.example .env

# Éditer .env avec votre BD locale
DATABASE_URL=postgresql://user:password@localhost:5432/iroko_db

# Setup Prisma
npm run db:generate
npm run db:migrate

# Lancer le serveur
npm run dev

# Le serveur écoute sur http://localhost:3000
```

## 🏃 Scripts disponibles

```bash
npm run dev         # Démarrer en dev mode (avec hot reload)
npm run build       # Compiler TypeScript
npm start           # Démarrer en production
npm run db:migrate  # Appliquer migrations Prisma
npm run db:generate # Générer Prisma Client
npm run db:seed     # Seeder des données de test
npm run db:reset    # Reset la BD (attention!)
npm run lint        # Linter le code
npm test            # Lancer les tests
```

## 📚 Endpoints API

### Auth
- `POST /api/v1/auth/sign-up` - Créer compte
- `POST /api/v1/auth/login` - Se connecter
- `POST /api/v1/auth/verify-token` - Vérifier token

### Missions
- `POST /api/v1/missions/create` - Créer mission
- `GET /api/v1/missions` - Lister missions
- `GET /api/v1/missions/:id` - Détails
- `POST /api/v1/missions/:id/accept` - Accepter
- `POST /api/v1/missions/:id/complete` - Compléter

### Utilisateurs
- `GET /api/v1/users/:userId` - Profil
- `PATCH /api/v1/users/:userId` - Modifier profil
- `GET /api/v1/users` - Lister providers
- `POST /api/v1/users/:userId/rate` - Évaluer

### Paiements
- `POST /api/v1/payments/create` - Créer paiement
- `GET /api/v1/payments/:id` - Détails paiement
- `POST /api/v1/payments/:id/release` - Libérer escrow
- `GET /api/v1/payments/wallet/balance` - Solde wallet

## 🗄️ Database Schema

Voir [BACKEND_DATABASE.md](./BACKEND_DATABASE.md) pour le schéma Prisma complet.

**Collections principales**:
- `users` - Clients & Providers
- `missions` - Services
- `payments` - Paiements en escrow
- `ratings` - Évaluations
- `wallet_transactions` - Solde providers
- `messages` - Chat

## 🔐 Authentification

- JWT tokens (7 jours par défaut)
- Passwords hashés avec bcryptjs
- Middleware `authenticate` pour routes protégées

```typescript
// Utiliser le middleware
router.get('/protected', authenticate, controller);

// Dans le controller
const userId = req.user?.id;
```

## 🚢 Déploiement

### Heroku (Gratuit avec limitations)

```bash
# Installer Heroku CLI
verifyNpm install -g heroku

# Login
heroku login

# Créer app
heroku create iroko-backend

# Set environment
heroku config:set NODE_ENV=production
heroku config:set JWT_SECRET=your_super_secret_key
heroku config:set DATABASE_URL=postgresql://...

# Deploy
git push heroku main
```

### Railway.app (Recommandé)

1. Connecter GitHub
2. Sélectionner repo
3. Railway détecte Node.js automatiquement
4. Database PostgreSQL fournie
5. Auto-deploy à chaque push

Voir [DEPLOYMENT.md](./DEPLOYMENT.md) pour plus de détails.

## 📦 Stack

- **Runtime**: Node.js 18+
- **Language**: TypeScript
- **Framework**: Express.js
- **ORM**: Prisma
- **Database**: PostgreSQL
- **Authentication**: JWT + bcrypt
- **Docker**: Multi-stage build

## 🧪 Testing

```bash
# Lancer tests
npm test

# Watch mode
npm run test:watch

# Coverage
npm test -- --coverage
```

## 🐛 Debugging

```bash
# Voir les logs
npm run dev

# Ouvrir Prisma Studio (GUI pour BD)
npm run prisma:studio

# API test avec curl
curl http://localhost:3000/health
```

## 🔒 Sécurité

- ✅ Input validation
- ✅ SQL injection protection (Prisma)
- ✅ CORS configuré
- ✅ JWT token expiry
- ✅ Passwords hachés
- ✅ Rate limiting (optionnel)
- ✅ Error messages sans détails en prod

## 📝 Structure du projet

```
backend/
├── src/
│   ├── server.ts              # Server principal
│   ├── routes/                # Définitions routes
│   │   ├── auth.routes.ts
│   │   ├── mission.routes.ts
│   │   ├── user.routes.ts
│   │   └── payment.routes.ts
│   ├── controllers/           # Logic métier
│   │   ├── auth.controller.ts
│   │   ├── mission.controller.ts
│   │   ├── user.controller.ts
│   │   └── payment.controller.ts
│   ├── middleware/            # Middleware
│   │   ├── auth.ts
│   │   └── errorHandler.ts
│   └── utils/                 # Utilitaires
│       └── helpers.ts
├── prisma/
│   ├── schema.prisma          # Schéma BD
│   └── seed.ts                # Données de test
├── docker-compose.yml         # Docker setup
├── Dockerfile                 # Production image
└── package.json
```

## 🔄 Workflow développement

1. Modifier le schéma Prisma
2. `npm run db:migrate -- --name description`
3. `npm run db:generate`
4. Écrire le code
5. Tester avec curl/Postman
6. Commit et push

## 📖 Documentation détaillée

- [Database Schema](./BACKEND_DATABASE.md) - Schéma complet
- [Deployment Guide](./DEPLOYMENT.md) - Deploy production
- [API Reference](./API.md) - Détails endpoints

## 🆘 Troubleshooting

### Port 3000 déjà utilisé
```bash
lsof -i :3000
kill -9 <PID>
```

### Database connection error
```bash
# Vérifier DATABASE_URL dans .env
echo $DATABASE_URL

# Tester la connexion
psql $DATABASE_URL
```

### Migrations failed
```bash
npm run db:reset      # Reset (attention - perte de données!)
npm run db:migrate
```

## 📞 Support

Pour des questions n'hésitez pas à ouvrir une issue sur GitHub.

---

**Status**: ✅ Production Ready
**Version**: 1.0.0
**Last Updated**: 2024-02-10
