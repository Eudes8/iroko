# 📊 IROKO Backend - Database Schema

Schéma complet de la base de données PostgreSQL avec Prisma.

## 📋 Tables

### **users**
Stocke les profils des clients et providers.

```sql
CREATE TABLE users (
  id                  STRING PRIMARY KEY,
  email              STRING UNIQUE NOT NULL,
  password           STRING NOT NULL (bcrypted),
  name               STRING NOT NULL,
  phone              STRING,
  role               ENUM (CLIENT, PROVIDER, ADMIN),
  bio                TEXT,
  profileImage       STRING,
  isVerified         BOOLEAN DEFAULT false,
  averageRating      FLOAT DEFAULT 0,
  reviewCount        INT DEFAULT 0,
  
  -- Provider only
  specialties        STRING[],  -- JSON array
  hourlyRate         FLOAT,
  location           STRING,
  certifications     STRING[],  -- JSON array
  providerType       STRING,
  
  createdAt          TIMESTAMP DEFAULT now(),
  updatedAt          TIMESTAMP DEFAULT now()
);

INDEXES:
- email (UNIQUE)
- role, isVerified
- averageRating (sorting)
- createdAt (sorting)
```

### **missions**
Services à proposer.

```sql
CREATE TABLE missions (
  id                   STRING PRIMARY KEY,
  clientId            STRING NOT NULL REFERENCES users,
  providerId          STRING REFERENCES users,
  serviceType         ENUM (TUTORING, RECRUITMENT, MAINTENANCE),
  title               STRING NOT NULL,
  description         TEXT NOT NULL,
  category            STRING,
  level               STRING,  -- e.g., primary, secondary
  
  scheduledDate       TIMESTAMP NOT NULL,
  durationMinutes     INT NOT NULL,
  
  price               FLOAT NOT NULL,  -- Total price
  commission          FLOAT NOT NULL, -- 10% IROKO
  
  status              ENUM (PENDING, ACCEPTED, IN_PROGRESS, COMPLETED, CANCELLED),
  paymentStatus       ENUM (PENDING, PROCESSING, RELEASED, REFUNDED),
  
  clientRating        TEXT,
  clientRatingValue   INT,
  providerRating      TEXT,
  providerRatingValue INT,
  
  completedAt         TIMESTAMP,
  createdAt           TIMESTAMP DEFAULT now(),
  updatedAt           TIMESTAMP DEFAULT now()
);

INDEXES:
- clientId, status
- providerId, status
- serviceType, status
- createdAt DESC
- status
```

### **payments**
Paiements en escrow.

```sql
CREATE TABLE payments (
  id                    STRING PRIMARY KEY,
  missionId            STRING UNIQUE NOT NULL REFERENCES missions,
  clientId             STRING NOT NULL REFERENCES users,
  providerId           STRING NOT NULL REFERENCES users,
  
  amount               FLOAT NOT NULL,           -- Total
  commission           FLOAT NOT NULL,           -- 10% IROKO fee
  providerEarnings     FLOAT NOT NULL,          -- 90%
  
  paymentMethod        ENUM (CARD, MOBILE_MONEY, BANK_TRANSFER),
  status               ENUM (PENDING, PROCESSING, RELEASED, REFUNDED),
  escrowStatus         ENUM (HELD, RELEASED, REFUNDED),
  
  transactionId        STRING,        -- Payment provider ID
  stripePaymentIntentId STRING,
  
  completedAt          TIMESTAMP,
  createdAt            TIMESTAMP DEFAULT now(),
  updatedAt            TIMESTAMP DEFAULT now()
);

INDEXES:
- clientId, status
- providerId, status
- missionId (UNIQUE)
- createdAt DESC
```

### **ratings**
Évaluations des utilisateurs.

```sql
CREATE TABLE ratings (
  id         STRING PRIMARY KEY,
  userId     STRING NOT NULL REFERENCES users ON DELETE CASCADE,  -- Who is rated
  ratedBy    STRING NOT NULL REFERENCES users ON DELETE CASCADE,  -- Who rates
  missionId  STRING,
  
  rating     INT NOT NULL (1-5),
  review     TEXT,
  
  createdAt  TIMESTAMP DEFAULT now(),
  updatedAt  TIMESTAMP DEFAULT now()
);

UNIQUE CONSTRAINT:
- userId + ratedBy (une éval par pair)

INDEXES:
- userId (all ratings for user)
- ratedBy (ratings given by user)
- rating DESC (find top rated)
- createdAt DESC
```

### **wallet_transactions**
Transactions du portefeuille des providers.

```sql
CREATE TABLE wallet_transactions (
  id          STRING PRIMARY KEY,
  userId      STRING NOT NULL REFERENCES users ON DELETE CASCADE,
  paymentId   STRING,
  missionId   STRING,
  
  type        ENUM (CREDIT, DEBIT),
  amount      FLOAT NOT NULL,
  description TEXT,
  status      STRING DEFAULT 'completed',
  
  createdAt   TIMESTAMP DEFAULT now(),
  updatedAt   TIMESTAMP DEFAULT now()
);

INDEXES:
- userId, createdAt DESC (wallet statement)
- status (pending transactions)
```

### **messages**
Chat entre utilisateurs.

```sql
CREATE TABLE messages (
  id          STRING PRIMARY KEY,
  missionId   STRING NOT NULL REFERENCES missions ON DELETE CASCADE,
  senderId    STRING NOT NULL REFERENCES users ON DELETE CASCADE,
  recipientId STRING NOT NULL REFERENCES users ON DELETE CASCADE,
  
  content     TEXT NOT NULL,
  isRead      BOOLEAN DEFAULT false,
  readAt      TIMESTAMP,
  
  createdAt   TIMESTAMP DEFAULT now(),
  updatedAt   TIMESTAMP DEFAULT now()
);

INDEXES:
- missionId, createdAt DESC (mission chat)
- recipientId, isRead (unread messages)
- senderId
- createdAt DESC
```

## 🔄 Relationships (Relations)

```
users (1) ──── (many) missions (client)
users (1) ──── (many) missions (provider)
missions (1) ──── (1) payments
users (1) ──── (many) ratings (rated)
users (1) ──── (many) ratings (ratedBy)
users (1) ──── (many) wallet_transactions
users (1) ──── (many) messages (sender)
users (1) ──── (many) messages (recipient)
missions (1) ──── (many) messages
```

## 📈 Example Queries

### Trouver tous les tuteurs de mathématiques vérifiés
```sql
SELECT * FROM users 
WHERE role = 'PROVIDER' 
  AND isVerified = true 
  AND specialties LIKE '%mathematics%'
ORDER BY averageRating DESC;
```

### Revenus IROKO ce mois
```sql
SELECT SUM(commission) as revenue FROM payments
WHERE status = 'RELEASED' 
  AND createdAt >= DATE_TRUNC('month', NOW());
```

### Paiements en attente de libération
```sql
SELECT p.* FROM payments p
JOIN missions m ON p.missionId = m.id
WHERE p.escrowStatus = 'HELD' 
  AND m.status = 'COMPLETED';
```

### Solde du wallet d'un provider
```sql
SELECT 
  userId,
  SUM(CASE WHEN type = 'CREDIT' THEN amount ELSE -amount END) as balance
FROM wallet_transactions
WHERE userId = 'provider_id'
GROUP BY userId;
```

### Utilisateurs les plus populaires
```sql
SELECT 
  userId,
  AVG(rating) as avg_rating,
  COUNT(*) as review_count
FROM ratings
GROUP BY userId
ORDER BY avg_rating DESC
LIMIT 10;
```

## 🔒 Data Retention Policy

| Table | Retention | Action |
|-------|-----------|--------|
| users | Forever | Anonymize if deleted |
| missions | Forever | Keep for disputes |
| payments | Forever | Keep for audits |
| ratings | Forever | Keep for history |
| wallet_transactions | Forever | Keep for statements |
| messages | 7 years | Delete after |

## 💾 Backup & Recovery

```bash
# Backup
pg_dump iroko_db > backup.sql

# Restore
psql iroko_db < backup.sql

# Remote (avec Docker)
docker-compose exec postgres pg_dump -U iroko_user iroko_db > backup.sql
```

## ⚡ Performance Indexes

Toutes les colonnes utilisées en WHERE/JOIN/ORDER BY ont des indexes.

```
users:
- email (UNIQUE)
- (role, isVerified) - composite
- averageRating
- createdAt

missions:
- (clientId, status) - composite
- (providerId, status) - composite
- (serviceType, status) - composite
- createdAt DESC

payments:
- (clientId, status) - composite
- (providerId, status) - composite
- missionId (UNIQUE)
- createdAt DESC

ratings:
- (userId, ratedBy) - UNIQUE
- userId
- rating DESC

wallet_transactions:
- (userId, createdAt) - composite
- status
```

## 🚀 Migration Strategy

Utiliser Prisma migrations:

```bash
# Créer migration
npx prisma migrate dev --name add_new_field

# Vérifier migration
npx prisma migrate status

# Production
npx prisma migrate deploy
```

## 📊 Sample Data (Seed)

Voir [seed.ts](./seed.ts) pour les données d'exemple.

```typescript
// Users de test
client@test.com (client)
provider@test.com (provider - tuteur maths)

// Missions de test
Cours de maths - Préparation bac
```

---

**Compatible avec**: PostgreSQL 12+
**ORM**: Prisma 5.x
**Last Updated**: 2024-02-10
