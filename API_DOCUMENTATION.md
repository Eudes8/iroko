# Documentation API - IROKO Platform

## 🌐 Point d'accès à l'API

```
Base URL: https://api.iroko.ci/v1
Socket URL: https://socket.iroko.ci
```

## 🔐 Authentification

Tous les endpoints (sauf ceux spécifiés) nécessitent un token JWT dans l'en-tête `Authorization` :

```
Authorization: Bearer <access_token>
```

### Format de réponse d'erreur

```json
{
  "success": false,
  "message": "Description de l'erreur",
  "code": "ERROR_CODE",
  "data": null
}
```

## 📋 Endpoints d'Authentification

### Login
```
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response (200):
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "name": "John Doe",
      "role": "client",
      "profileImage": "url",
      "isVerified": true,
      "averageRating": 4.5,
      "reviewCount": 10,
      "createdAt": "2025-02-09T00:00:00Z"
    },
    "accessToken": "jwt_token",
    "refreshToken": "refresh_token"
  }
}
```

### Register
```
POST /auth/register
Content-Type: application/json

{
  "email": "newuser@example.com",
  "password": "password123",
  "name": "Jane Doe",
  "role": "provider"  // "client" ou "provider"
}

Response (201): Same as login
```

### Get Current User
```
GET /auth/me
Authorization: Bearer <token>

Response (200):
{
  "success": true,
  "data": { /* User object */ }
}
```

### Update Profile
```
PUT /auth/profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "New Name",
  "bio": "New bio",
  "profileImage": "url",
  "phone": "+225xxxxxxxxxx"
}

Response (200): Updated User object
```

### Reset Password
```
POST /auth/reset-password
Content-Type: application/json

{
  "email": "user@example.com"
}

Response (200):
{
  "success": true,
  "message": "Email de réinitialisation envoyé"
}
```

### Verify Email
```
POST /auth/verify-email
Content-Type: application/json

{
  "token": "verification_token"
}

Response (200):
{
  "success": true,
  "message": "Email vérifié"
}
```

## 🎯 Endpoints des Missions

### Rechercher les missions
```
GET /missions/search?serviceType=tutoring&category=Maths&level=3ème&location=Abidjan&minPrice=4000&maxPrice=8000&page=1&limit=20
Authorization: Bearer <token>

Response (200):
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "clientId": "uuid",
      "providerId": "uuid",
      "serviceType": "tutoring",
      "title": "Cours de Maths",
      "description": "...",
      "category": "Mathématiques",
      "level": "3ème",
      "scheduledDate": "2025-02-15T09:00:00Z",
      "durationMinutes": 60,
      "price": 5000,
      "commission": 750,
      "status": "pending",
      "paymentStatus": "pending",
      "clientRatingValue": 5,
      "clientRating": "Excellent service",
      "createdAt": "2025-02-09T00:00:00Z",
      "updatedAt": "2025-02-09T00:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "pages": 8
  }
}
```

### Get Mission by ID
```
GET /missions/{missionId}
Authorization: Bearer <token>

Response (200): Mission object
```

### Create Mission
```
POST /missions
Authorization: Bearer <token>
Content-Type: application/json

{
  "serviceType": "tutoring",
  "title": "Cours de Maths",
  "description": "Aide pour les révisions",
  "category": "Mathématiques",
  "level": "3ème",
  "scheduledDate": "2025-02-15T09:00:00Z",
  "durationMinutes": 60,
  "price": 5000,
  "providerId": "uuid" // optionnel, si client cherche prestataire spécifique
}

Response (201): Created Mission object
```

### Accept Mission
```
PATCH /missions/{missionId}/accept
Authorization: Bearer <token>
Content-Type: application/json

{}

Response (200): Updated Mission with status = "accepted"
```

### Complete Mission
```
PATCH /missions/{missionId}/complete
Authorization: Bearer <token>
Content-Type: application/json

{}

Response (200): Updated Mission with status = "completed"
```

### Rate Mission
```
PATCH /missions/{missionId}/rate
Authorization: Bearer <token>
Content-Type: application/json

{
  "rating": 5,
  "comment": "Très bon service, tuteur compétent"
}

Response (200): Updated Mission with ratings
```

### Cancel Mission
```
PATCH /missions/{missionId}/cancel
Authorization: Bearer <token>
Content-Type: application/json

{}

Response (200): Updated Mission with status = "cancelled"
```

### Get User Missions
```
GET /missions/client?status=pending&page=1&limit=20
// ou
GET /missions/provider?status=accepted&page=1&limit=20
Authorization: Bearer <token>

Response (200): List of missions with pagination
```

## 👥 Endpoints des Utilisateurs/Prestataires

### Get Provider Details
```
GET /providers/{providerId}
Authorization: Bearer <token> (optionnel)

Response (200):
{
  "success": true,
  "data": {
    /* Provider object with specialties, hourlyRate, etc. */
  }
}
```

### Search Providers
```
GET /providers/search?specialties=Maths,Français&location=Abidjan&minRating=4&page=1
Authorization: Bearer <token>

Response (200):
{
  "success": true,
  "data": [ /* Array of Provider objects */ ],
  "pagination": { /* pagination info */ }
}
```

### Update Provider Info
```
PUT /providers/me
Authorization: Bearer <token>
Content-Type: application/json

{
  "specialties": ["Mathématiques", "Physique"],
  "hourlyRate": 5000,
  "location": "Abidjan, Cocody",
  "certifications": ["Bac+2", "Expérience 5 ans"],
  "providerType": "tutor"
}

Response (200): Updated Provider object
```

## 💳 Endpoints de Paiement

### Initiate Payment
```
POST /payments/initiate
Authorization: Bearer <token>
Content-Type: application/json

{
  "missionId": "uuid",
  "amount": 5750, // price + commission
  "paymentMethod": "mobile_money", // ou "credit_card"
  "phoneNumber": "+225xxxxxxxxxx" // pour mobile money
}

Response (200):
{
  "success": true,
  "data": {
    "paymentId": "uuid",
    "missionId": "uuid",
    "amount": 5750,
    "status": "pending",
    "redirectUrl": "https://..." // pour paiement
  }
}
```

### Confirm Payment
```
POST /payments/{paymentId}/confirm
Authorization: Bearer <token>
Content-Type: application/json

{
  "transactionId": "mobile_money_transaction_id"
}

Response (200):
{
  "success": true,
  "data": {
    "paymentId": "uuid",
    "status": "escrowed",
    "amount": 5750
  }
}
```

### Get Wallet Info
```
GET /wallet/me
Authorization: Bearer <token>

Response (200):
{
  "success": true,
  "data": {
    "providerId": "uuid",
    "balance": 45000,
    "escrowedAmount": 10000,
    "totalEarnings": 100000,
    "currency": "XOF"
  }
}
```

### Withdraw Funds
```
POST /wallet/withdraw
Authorization: Bearer <token>
Content-Type: application/json

{
  "amount": 20000,
  "method": "mobile_money", // ou "bank_transfer"
  "phoneNumber": "+225xxxxxxxxxx" // pour mobile money
}

Response (200):
{
  "success": true,
  "data": {
    "withdrawalId": "uuid",
    "amount": 20000,
    "status": "pending",
    "estimatedArrival": "2025-02-10"
  }
}
```

## 💬 Endpoints de Messagerie

### Get Conversations
```
GET /messages/conversations?page=1&limit=20
Authorization: Bearer <token>

Response (200):
{
  "success": true,
  "data": [
    {
      "conversationId": "uuid",
      "participantId": "uuid",
      "participantName": "John Doe",
      "lastMessage": "Merci beaucoup!",
      "lastMessageTime": "2025-02-09T15:30:00Z",
      "unreadCount": 2
    }
  ]
}
```

### Get Messages
```
GET /messages/conversations/{conversationId}?page=1&limit=50
Authorization: Bearer <token>

Response (200):
{
  "success": true,
  "data": [
    {
      "messageId": "uuid",
      "conversationId": "uuid",
      "senderId": "uuid",
      "senderName": "Jane Doe",
      "content": "Bonjour, êtes-vous disponible?",
      "timestamp": "2025-02-09T15:30:00Z",
      "isRead": true
    }
  ]
}
```

### Send Message
```
POST /messages/send
Authorization: Bearer <token>
Content-Type: application/json

{
  "conversationId": "uuid", // ou créer new si null
  "recipientId": "uuid",
  "content": "Bonjour, êtes-vous disponible?",
  "missionId": "uuid" // optionnel
}

Response (201):
{
  "success": true,
  "data": {
    "messageId": "uuid",
    "conversationId": "uuid",
    "content": "...",
    "timestamp": "2025-02-09T15:30:00Z"
  }
}
```

## 🔔 WebSocket Events (Socket.IO)

### Connection
```
const io = require('socket.io-client');
const socket = io('https://socket.iroko.ci', {
  auth: {
    token: 'jwt_token'
  }
});

socket.on('connect', () => {
  console.log('Connected');
});
```

### Events à écouter
```
socket.on('mission:created', (mission) => { }); // Nouvelle mission
socket.on('mission:accepted', (mission) => { }); // Mission acceptée
socket.on('message:new', (message) => { }); // Nouveau message
socket.on('payment:confirmed', (payment) => { }); // Paiement confirmé
socket.on('notification:new', (notification) => { }); // Notification
```

### Events à émettre
```
socket.emit('typing', { conversationId: 'uuid' });
socket.emit('message:read', { messageId: 'uuid' });
```

## ⚙️ Codes d'erreur

| Code | Signification |
|------|---------------|
| 400 | Requête invalide |
| 401 | Non authentifié |
| 403 | Non autorisé |
| 404 | Ressource non trouvée |
| 409 | Conflit (ex: email déjà utilisé) |
| 500 | Erreur serveur |

## 📝 Notes importantes

1. Les dates sont toujours en ISO 8601 UTC
2. Les montants sont en FCFA (XOF)
3. Les tokens JWT expirent après 24h
4. Les refresh tokens expirent après 30 jours
5. La commission IROKO est prélevée automatiquement (15% par défaut)
6. Les WebSockets nécessitent une authentification avec un JWT

---

**Dernière mise à jour:** 9 février 2025
