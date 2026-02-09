class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? profileImage;
  final String role; // 'client' ou 'provider'
  final String? bio;
  final double? averageRating;
  final int? reviewCount;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.profileImage,
    required this.role,
    this.bio,
    this.averageRating,
    this.reviewCount,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String?,
      role: json['role'] as String,
      bio: json['bio'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int?,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profileImage': profileImage,
      'role': role,
      'bio': bio,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profileImage,
    String? role,
    String? bio,
    double? averageRating,
    int? reviewCount,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Provider extends User {
  final List<String>? specialties; // Pour tuteurs: matières, pour ménage: types de prestations
  final double? hourlyRate;
  final String? location;
  final List<String>? certifications;
  final String? providerType; // 'tutor', 'housekeeping', 'recruiter'

  Provider({
    required String id,
    required String email,
    required String name,
    String? phone,
    String? profileImage,
    required String role,
    String? bio,
    double? averageRating,
    int? reviewCount,
    required bool isVerified,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.specialties,
    this.hourlyRate,
    this.location,
    this.certifications,
    this.providerType,
  }) : super(
    id: id,
    email: email,
    name: name,
    phone: phone,
    profileImage: profileImage,
    role: role,
    bio: bio,
    averageRating: averageRating,
    reviewCount: reviewCount,
    isVerified: isVerified,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory Provider.fromJson(Map<String, dynamic> json) {
    final user = User.fromJson(json);
    return Provider(
      id: user.id,
      email: user.email,
      name: user.name,
      phone: user.phone,
      profileImage: user.profileImage,
      role: user.role,
      bio: user.bio,
      averageRating: user.averageRating,
      reviewCount: user.reviewCount,
      isVerified: user.isVerified,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      specialties: List<String>.from(json['specialties'] as List? ?? []),
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble(),
      location: json['location'] as String?,
      certifications: List<String>.from(json['certifications'] as List? ?? []),
      providerType: json['providerType'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'specialties': specialties,
      'hourlyRate': hourlyRate,
      'location': location,
      'certifications': certifications,
      'providerType': providerType,
    };
  }
}
