import 'package:iroko/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
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

  Map<String, dynamic> toJson() => super.toJson();
}

class ProviderModel extends Provider {
  ProviderModel({
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
    List<String>? specialties,
    double? hourlyRate,
    String? location,
    List<String>? certifications,
    String? providerType,
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
    specialties: specialties,
    hourlyRate: hourlyRate,
    location: location,
    certifications: certifications,
    providerType: providerType,
  );

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

  @override
  Map<String, dynamic> toJson() => super.toJson();
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
