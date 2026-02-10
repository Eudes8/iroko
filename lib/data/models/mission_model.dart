import 'package:iroko/domain/entities/mission.dart';

class MissionModel extends Mission {
  MissionModel({
    required super.id,
    required super.clientId,
    required super.providerId,
    required super.serviceType,
    required super.title,
    required super.description,
    super.category,
    super.level,
    required super.scheduledDate,
    required super.durationMinutes,
    required super.price,
    super.commission,
    required super.status,
    required super.paymentStatus,
    super.clientRating,
    super.clientRatingValue,
    super.providerRating,
    super.providerRatingValue,
    required super.createdAt,
    required super.updatedAt,
    super.completedAt,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      providerId: json['providerId'] as String,
      serviceType: json['serviceType'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
      level: json['level'] as String?,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      durationMinutes: json['durationMinutes'] as int,
      price: (json['price'] as num).toDouble(),
      commission: (json['commission'] as num?)?.toDouble(),
      status: json['status'] as String,
      paymentStatus: json['paymentStatus'] as String,
      clientRating: json['clientRating'] as String?,
      clientRatingValue: json['clientRatingValue'] as int?,
      providerRating: json['providerRating'] as String?,
      providerRatingValue: json['providerRatingValue'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

}
