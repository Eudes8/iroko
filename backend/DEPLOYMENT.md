# 📦 IROKO Backend - Deployment Guide

Guide complet pour déployer le backend sur des serveurs cloud.

## 🚀 Options de déploiement

### 1. **Railway.app** (Recommandé - Très facile)

**Avantages**:
- ✅ Database PostgreSQL incluse
- ✅ Auto-deploy GitHub
- ✅ Environment variables management
- ✅ $5/mois gratuit
- ✅ Support Prisma

**Étapes**:

1. Créer compte sur [Railway.app](https://railway.app)

2. Connecter GitHub:
   - Cliquer "New Project"
   - "Deploy from GitHub repo"
   - Sélectionner le repo

3. Railway détecte Node.js, crée automatiquement:
   - PostgreSQL Database
   - Node.js App

4. Configurer variables d'environnement:
   ```
   NODE_ENV=production
   JWT_SECRET=your_production_secret_here
   CORS_ORIGIN=https://votre-domaine.com
   ```

5. Migrations Prisma:
   - Dans Railway UI → "Deploy" → Ajouter command:
   ```bash
   npm run db:migrate && npm start
   ```

6. Déployer:
   - Push sur GitHub → Railway auto-deploy

URL du serveur: `https://projet.up.railway.app`

---

### 2. **Heroku** (Gratuit avec limitations)

**Avantages**:
- ✅ Free tier disponible (avec limitations)
- ✅ Easy deployment
- ✅ Auto-scaling

**Étapes**:

```bash
# 1. Installer Heroku CLI
npm install -g heroku

# 2. Login
heroku login

# 3. Créer app
heroku create iroko-backend

# 4. Ajouter PostgreSQL
heroku addons:create heroku-postgresql:hobby-dev

# 5. Variables d'environnement
heroku config:set NODE_ENV=production
heroku config:set JWT_SECRET=your_secret_key
heroku config:set CORS_ORIGIN=https://votre-domaine.com

# 6. Database URL est auto-set comme DATABASE_URL

# 7. Déployer
git push heroku main

# 8. Voir les logs
heroku logs --tail
```

URL: `https://iroko-backend.herokuapp.com`

---

### 3. **DigitalOcean App Platform** (Professionnel)

**Avantages**:
- ✅ Database PostgreSQL managée
- ✅ Un-click deployment
- ✅ $12/mois pour app + DB
- ✅ Full control

**Étapes**:

1. Créer compte [DigitalOcean](https://digitalocean.com)

2. "App Platform" → "Create App"

3. Connecter GitHub repo

4. Service type: "Node.js"

5. Database: "PostgreSQL"

6. Environment variables:
   ```
   NODE_ENV=production
   JWT_SECRET=...
   CORS_ORIGIN=...
   DATABASE_URL=${db.name}
   ```

7. Deploy

---

### 4. **AWS EC2** (DIY - Plus contrôle)

**Prerequisites**:
- Instance EC2 (t2.micro = gratuit 1 an)
- Ubuntu 24.04

**Setup**:

```bash
# 1. SSH dans l'instance
ssh -i key.pem ubuntu@your-instance-ip

# 2. Update system
sudo apt update && sudo apt upgrade -y

# 3. Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# 4. Install PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# 5. Create database
sudo -u postgres createdb iroko_db
sudo -u postgres createuser iroko_user
sudo -u postgres psql -c "ALTER USER iroko_user WITH PASSWORD 'secure_password';"

# 6. Clone repo
cd /opt
sudo git clone https://github.com/Eudes8/iroko.git
cd iroko/backend

# 7. Install dependencies
npm ci --production

# 8. Setup environment
nano .env
# DATABASE_URL=postgresql://iroko_user:password@localhost:5432/iroko_db
# JWT_SECRET=...

# 9. Run migrations
npm run db:migrate

# 10. Build
npm run build

# 11. Run with PM2
npm install -g pm2
pm2 start dist/server.js --name "iroko-api"
pm2 startup
pm2 save
```

---

### 5. **Docker Hub + Container Registry**

Créer image Docker réutilisable:

```bash
# 1. Build image
docker build -t eudes8/iroko-backend:latest .

# 2. Login Docker Hub
docker login

# 3. Push
docker push eudes8/iroko-backend:latest

# 4. Pull et run n'importe où
docker run -e DATABASE_URL=postgresql://... eudes8/iroko-backend:latest
```

---

## 🔧 Configuration Environnement

### development.env
```
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://user:password@localhost:5432/iroko_db
JWT_SECRET=dev_secret_change_me
JWT_EXPIRY=7d
CORS_ORIGIN=http://localhost,http://localhost:3000,http://localhost:8080
LOG_LEVEL=debug
```

### production.env
```
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://user:secure_password@db.railway.app:5432/iroko_db
JWT_SECRET=super_secure_random_string_min_32_chars
JWT_EXPIRY=7d
CORS_ORIGIN=https://iroko.ci,https://app.iroko.ci
LOG_LEVEL=info
```

---

## 📱 Configuration Flutter APK

Mettre à jour [lib/core/constants/app_constants.dart](../../lib/core/constants/app_constants.dart):

```dart
class AppConstants {
  // Utiliser le backend déployé au lieu de Firebase
  static const String baseUrl = 'https://iroko-backend.railway.app/api/v1';
  
  // Plus besoin de Firebase constants
  // static const String firebaseProjectId = '...'; ❌
  
  // JWT token management
  static const String storageKeyAuthToken = 'auth_token';
  static const String storageKeyUserId = 'user_id';
}
```

Mettre à jour le service HTTP:

```dart
// lib/core/services/http_service.dart
class HttpService {
  Future<T> get<T>(String path, ...) async {
    try {
      // Récupérer le token stocké
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.storageKeyAuthToken);
      
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data as T;
    } catch (e) {
      rethrow;
    }
  }
}
```

---

## 📊 Monitoring Production

### Logs

```bash
# Railway
railway logs

# Heroku
heroku logs --tail

# AWS EC2
pm2 logs
journalctl -u iroko-api.service -f

# Docker
docker logs -f container_name
```

### Health Check

```bash
# Tester l'endpoint health
curl https://iroko-backend.railway.app/health

# Expected response:
{
  "status": "ok",
  "message": "IROKO Backend is running",
  "timestamp": "2024-02-10T...",
  "uptime": 12345
}
```

### Database Health

```bash
# Connexion test
psql $DATABASE_URL -c "SELECT COUNT(*) FROM users;"

# Backup automated
pg_dump $DATABASE_URL > backup-$(date +%Y%m%d).sql
```

---

## 🔐 SSL/HTTPS

### Automatic (Railway/Heroku)
- ✅ On crée automatiquement

### Custom domain
```bash
# Railway
railway domain add iroko-api.example.com

# Heroku
heroku domains:add api.iroko.ci

# Puis mettre à jour DNS
# CNAME → votre-heroku-app.herokuapp.com
```

---

## 💾 Backups

### PostgreSQL
```bash
# Backup local
pg_dump $DATABASE_URL > iroko_backup.sql

# Restore
psql $DATABASE_URL < iroko_backup.sql

# Avec compression
pg_dump $DATABASE_URL | gzip > iroko_backup.sql.gz
gunzip < iroko_backup.sql.gz | psql $DATABASE_URL
```

### Automated Daily
Configurer avec `pgbackup.com` ou similar:
```
Schedule: 0 2 * * *  (2:00 AM daily)
Retention: 30 days
```

---

## 🚨 Scaling

### Si trop de requêtes

**Option 1**: Augmenter resources
```bash
# Railway
railway up --plan pro

# Heroku
heroku dynos:type performance-l
```

**Option 2**: Ajouter cache (Redis)
```bash
# Installer Redis
npm install redis

# Cacher les providers
const providers = await redis.get('providers:all');
if (!providers) {
  const data = await db.user.findMany(...);
  await redis.set('providers:all', JSON.stringify(data), 'EX', 3600);
}
```

**Option 3**: Load balancer + multiples instances
- Railway: auto-scales
- Heroku: formations multiple dynos
- AWS: ALB + ASG

---

## 📝 Maintenance

### Weekly
- [ ] Check logs pour errors
- [ ] Vérifier health endpoint
- [ ] Database size (`SELECT pg_size_pretty(pg_database_size(current_database()));`)

### Monthly
- [ ] Database backup test (restore sur staging)
- [ ] Update dependencies (`npm outdated`)
- [ ] Review API usage patterns

### Quarterly
- [ ] Security audit
- [ ] Performance optimization
- [ ] Database vacuum (`VACUUM ANALYZE;`)

---

## 🆘 Troubleshooting

### App crashes after deployment
```bash
# Vérifier migrations
npm run db:migrate

# Vérifier compilation
npm run build

# Vérifier environment variables
heroku config  # ou railway config
```

### Database connection timeout
```bash
# Vérifier DATABASE_URL
echo $DATABASE_URL

# Tester avec psql
psql -d postgres://...your-url...

# Augmenter timeout
DATABASE_URL="postgresql://...?connectTimeoutMs=5000"
```

### High memory usage
```bash
# Héros
heroku logs --tail

# Chercher memory leaks
# Peut être dû à:
# - Requests qui traînent
# - Listeners non fermés
# - Large responses
```

---

## ✅ Pre-Launch Checklist

- [ ] Health endpoint responding
- [ ] Database migrations running
- [ ] Auth endpoints working
- [ ] Missions CRUD working
- [ ] Payments escrow working
- [ ] SSL/HTTPS enabled
- [ ] CORS configuré correctement
- [ ] JWT secret strong (32+ chars)
- [ ] Database backups automated
- [ ] Monitoring/alerts configuré
- [ ] Logs aggregation setup
- [ ] APK Flutter pointant bon URL
- [ ] Load test effectué (avec Artillery)
- [ ] Security audit fait

---

**Deployment Status**: ✅ Ready
**Recommended Platform**: Railway.app
**Estimated Cost**: $5-20/month
