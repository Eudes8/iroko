import 'package:iroko/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.phone,
    super.profileImage,
    required super.role,
    super.bio,
    super.averageRating,
    super.reviewCount,
    required super.isVerified,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
}

class ProviderModel extends Provider {
  ProviderModel({
    required super.id,
    required super.email,
    required super.name,
    super.phone,
    super.profileImage,
    required super.role,
    super.bio,
    super.averageRating,
    super.reviewCount,
    required super.isVerified,
    required super.createdAt,
    required super.updatedAt,
    super.specialties,
    super.hourlyRate,
    super.location,
    super.certifications,
    super.providerType,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
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
      specialties: List<String>.from(json['specialties'] as List? ?? []),
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble(),
      location: json['location'] as String?,
      certifications: List<String>.from(json['certifications'] as List? ?? []),
      providerType: json['providerType'] as String?,
    );
  }
}

class AuthResponse {
  final UserModel user;
  final String accessToken;
  final String? refreshToken;

  AuthResponse({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
}
