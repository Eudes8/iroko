class AppConstants {
  // API
  static const String baseUrl = 'https://api.iroko.ci/v1';
  static const String socketUrl = 'https://socket.iroko.ci';
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 secondes
  static const int receiveTimeout = 30000;
  
  // Pagination
  static const int pageSize = 20;
  
  // Services Types
  static const String serviceTypeTutoring = 'tutoring';
  static const String serviceTypeRecruitment = 'recruitment';
  static const String serviceTypeMaintenance = 'maintenance';
  
  // User Roles
  static const String roleClient = 'client';
  static const String roleProvider = 'provider';
  static const String roleAdmin = 'admin';
  
  // Mission Status
  static const String missionStatusPending = 'pending';
  static const String missionStatusAccepted = 'accepted';
  static const String missionStatusInProgress = 'in_progress';
  static const String missionStatusCompleted = 'completed';
  static const String missionStatusCancelled = 'cancelled';
  static const String missionStatusDisputed = 'disputed';
  
  // Payment Status
  static const String paymentStatusPending = 'pending';
  static const String paymentStatusEscrowed = 'escrowed';
  static const String paymentStatusReleased = 'released';
  static const String paymentStatusRefunded = 'refunded';
  
  // Storage Keys
  static const String storageKeyAuthToken = 'auth_token';
  static const String storageKeyUserRole = 'user_role';
  static const String storageKeyUserId = 'user_id';
  static const String storageKeyUserEmail = 'user_email';
  
  // Commission Rate
  static const double defaultCommissionRate = 0.15; // 15%
  
  // School Levels (Soutien Scolaire)
  static const List<String> primaryLevels = [
    'CP',
    'CE1',
    'CE2',
    'CM1',
    'CM2',
  ];
  
  static const List<String> secondaryLevel1 = [
    '6ème',
    '5ème',
    '4ème',
    '3ème',
  ];
  
  static const List<String> secondaryLevel2 = [
    '2ndeA',
    '2ndeC',
    '1ère A',
    '1ère D',
    'TleA',
    'TleD',
  ];
  
  // Subjects 
  static const List<String> subjects = [
    'Mathématiques',
    'Français',
    'Anglais',
    'Physique',
    'Chimie',
    'SVT',
    'Histoire-Géographie',
    'Philosophie',
    'Informatique',
  ];
  
  // Competencies for Recruitment
  static const List<String> competencies = [
    'Cuisine Ivoirienne',
    'Expérience ménage',
    'Discrétion',
    'Fiabilité',
    'Enseignement secondaire',
    'Gestion administrative',
    'Gardiennage',
    'Cuisine générale',
    'Repassage',
    'Nettoyage professionnel',
  ];
}
