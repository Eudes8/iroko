import 'package:iroko/data/repositories/mission_repository.dart';
import 'package:iroko/domain/entities/mission.dart';
import 'package:iroko/domain/usecases/auth_usecases.dart';

// Search Missions UseCase
class SearchMissionsUseCase 
    implements UseCase<List<Mission>, SearchMissionsParams> {
  final MissionRepository repository;

  SearchMissionsUseCase(this.repository);

  @override
  Future<List<Mission>> call(SearchMissionsParams params) async {
    return await repository.searchMissions(
      serviceType: params.serviceType,
      category: params.category,
      level: params.level,
      location: params.location,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      page: params.page,
    );
  }
}

class SearchMissionsParams {
  final String? serviceType;
  final String? category;
  final String? level;
  final String? location;
  final double? minPrice;
  final double? maxPrice;
  final int page;

  SearchMissionsParams({
    this.serviceType,
    this.category,
    this.level,
    this.location,
    this.minPrice,
    this.maxPrice,
    this.page = 1,
  });
}

// Get Mission By ID UseCase
class GetMissionByIdUseCase implements UseCase<Mission, String> {
  final MissionRepository repository;

  GetMissionByIdUseCase(this.repository);

  @override
  Future<Mission> call(String id) async {
    return await repository.getMissionById(id);
  }
}

// Create Mission UseCase
class CreateMissionUseCase 
    implements UseCase<Mission, CreateMissionParams> {
  final MissionRepository repository;

  CreateMissionUseCase(this.repository);

  @override
  Future<Mission> call(CreateMissionParams params) async {
    return await repository.createMission(
      serviceType: params.serviceType,
      title: params.title,
      description: params.description,
      category: params.category,
      level: params.level,
      scheduledDate: params.scheduledDate,
      durationMinutes: params.durationMinutes,
      price: params.price,
      providerId: params.providerId,
    );
  }
}

class CreateMissionParams {
  final String serviceType;
  final String title;
  final String description;
  final String? category;
  final String? level;
  final DateTime scheduledDate;
  final int durationMinutes;
  final double price;
  final String? providerId;

  CreateMissionParams({
    required this.serviceType,
    required this.title,
    required this.description,
    this.category,
    this.level,
    required this.scheduledDate,
    required this.durationMinutes,
    required this.price,
    this.providerId,
  });
}

// Accept Mission UseCase
class AcceptMissionUseCase implements UseCase<Mission, String> {
  final MissionRepository repository;

  AcceptMissionUseCase(this.repository);

  @override
  Future<Mission> call(String missionId) async {
    return await repository.acceptMission(missionId);
  }
}

// Complete Mission UseCase
class CompleteMissionUseCase implements UseCase<Mission, String> {
  final MissionRepository repository;

  CompleteMissionUseCase(this.repository);

  @override
  Future<Mission> call(String missionId) async {
    return await repository.completeMission(missionId);
  }
}

// Cancel Mission UseCase
class CancelMissionUseCase implements UseCase<Mission, String> {
  final MissionRepository repository;

  CancelMissionUseCase(this.repository);

  @override
  Future<Mission> call(String missionId) async {
    return await repository.cancelMission(missionId);
  }
}

// Rate Mission UseCase
class RateMissionUseCase implements UseCase<Mission, RateMissionParams> {
  final MissionRepository repository;

  RateMissionUseCase(this.repository);

  @override
  Future<Mission> call(RateMissionParams params) async {
    return await repository.rateMission(
      missionId: params.missionId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class RateMissionParams {
  final String missionId;
  final int rating;
  final String comment;

  RateMissionParams({
    required this.missionId,
    required this.rating,
    required this.comment,
  });
}

// Get User Missions UseCase
class GetUserMissionsUseCase 
    implements UseCase<List<Mission>, GetUserMissionsParams> {
  final MissionRepository repository;

  GetUserMissionsUseCase(this.repository);

  @override
  Future<List<Mission>> call(GetUserMissionsParams params) async {
    return await repository.getUserMissions(
      userId: params.userId,
      role: params.role,
      status: params.status,
      page: params.page,
    );
  }
}

class GetUserMissionsParams {
  final String userId;
  final String role;
  final String? status;
  final int page;

  GetUserMissionsParams({
    required this.userId,
    required this.role,
    this.status,
    this.page = 1,
  });
}
