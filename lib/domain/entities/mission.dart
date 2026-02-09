class Mission {
  final String id;
  final String clientId;
  final String providerId;
  final String serviceType; // 'tutoring', 'recruitment', 'maintenance'
  final String title;
  final String description;
  final String? category; // pour tutoring: matière, pour ménage: type de prestation
  final String? level; // pour tutoring: niveau scolaire
  final DateTime scheduledDate;
  final int durationMinutes;
  final double price;
  final double? commission; // montant de la commission IROKO
  final String status; // 'pending', 'accepted', 'in_progress', 'completed', 'cancelled', 'disputed'
  final String paymentStatus; // 'pending', 'escrowed', 'released', 'refunded'
  final String? clientRating;
  final int? clientRatingValue; // 1-5
  final String? providerRating;
  final int? providerRatingValue; // 1-5
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  Mission({
    required this.id,
    required this.clientId,
    required this.providerId,
    required this.serviceType,
    required this.title,
    required this.description,
    this.category,
    this.level,
    required this.scheduledDate,
    required this.durationMinutes,
    required this.price,
    this.commission,
    required this.status,
    required this.paymentStatus,
    this.clientRating,
    this.clientRatingValue,
    this.providerRating,
    this.providerRatingValue,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'providerId': providerId,
      'serviceType': serviceType,
      'title': title,
      'description': description,
      'category': category,
      'level': level,
      'scheduledDate': scheduledDate.toIso8601String(),
      'durationMinutes': durationMinutes,
      'price': price,
      'commission': commission,
      'status': status,
      'paymentStatus': paymentStatus,
      'clientRating': clientRating,
      'clientRatingValue': clientRatingValue,
      'providerRating': providerRating,
      'providerRatingValue': providerRatingValue,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  Mission copyWith({
    String? id,
    String? clientId,
    String? providerId,
    String? serviceType,
    String? title,
    String? description,
    String? category,
    String? level,
    DateTime? scheduledDate,
    int? durationMinutes,
    double? price,
    double? commission,
    String? status,
    String? paymentStatus,
    String? clientRating,
    int? clientRatingValue,
    String? providerRating,
    int? providerRatingValue,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return Mission(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      providerId: providerId ?? this.providerId,
      serviceType: serviceType ?? this.serviceType,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      level: level ?? this.level,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      price: price ?? this.price,
      commission: commission ?? this.commission,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      clientRating: clientRating ?? this.clientRating,
      clientRatingValue: clientRatingValue ?? this.clientRatingValue,
      providerRating: providerRating ?? this.providerRating,
      providerRatingValue: providerRatingValue ?? this.providerRatingValue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
