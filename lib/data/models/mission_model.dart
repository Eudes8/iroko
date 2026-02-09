import 'package:iroko/domain/entities/mission.dart';

class MissionModel extends Mission {
  MissionModel({
    required String id,
    required String clientId,
    required String providerId,
    required String serviceType,
    required String title,
    required String description,
    String? category,
    String? level,
    required DateTime scheduledDate,
    required int durationMinutes,
    required double price,
    double? commission,
    required String status,
    required String paymentStatus,
    String? clientRating,
    int? clientRatingValue,
    String? providerRating,
    int? providerRatingValue,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? completedAt,
  }) : super(
    id: id,
    clientId: clientId,
    providerId: providerId,
    serviceType: serviceType,
    title: title,
    description: description,
    category: category,
    level: level,
    scheduledDate: scheduledDate,
    durationMinutes: durationMinutes,
    price: price,
    commission: commission,
    status: status,
    paymentStatus: paymentStatus,
    clientRating: clientRating,
    clientRatingValue: clientRatingValue,
    providerRating: providerRating,
    providerRatingValue: providerRatingValue,
    createdAt: createdAt,
    updatedAt: updatedAt,
    completedAt: completedAt,
  );

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

  @override
  Map<String, dynamic> toJson() => super.toJson();
}
