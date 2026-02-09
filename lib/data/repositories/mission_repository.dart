import 'package:iroko/core/constants/app_constants.dart';
import 'package:iroko/core/services/http_service.dart';
import 'package:iroko/core/utils/exceptions.dart';
import 'package:iroko/data/models/mission_model.dart';
import 'package:iroko/domain/entities/mission.dart';

abstract class MissionRepository {
  Future<List<Mission>> searchMissions({
    String? serviceType,
    String? category,
    String? level,
    String? location,
    double? minPrice,
    double? maxPrice,
    int page = 1,
  });
  
  Future<Mission> getMissionById(String id);
  
  Future<Mission> createMission({
    required String serviceType,
    required String title,
    required String description,
    String? category,
    String? level,
    required DateTime scheduledDate,
    required int durationMinutes,
    required double price,
    String? providerId,
  });
  
  Future<Mission> acceptMission(String missionId);
  Future<Mission> completeMission(String missionId);
  Future<Mission> cancelMission(String missionId);
  
  Future<Mission> rateMission({
    required String missionId,
    required int rating,
    required String comment,
  });
  
  Future<List<Mission>> getUserMissions({
    required String userId,
    required String role, // 'client' ou 'provider'
    String? status,
    int page = 1,
  });
}

class MissionRepositoryImpl implements MissionRepository {
  final HttpService _httpService;

  MissionRepositoryImpl({
    required HttpService httpService,
  }) : _httpService = httpService;

  @override
  Future<List<Mission>> searchMissions({
    String? serviceType,
    String? category,
    String? level,
    String? location,
    double? minPrice,
    double? maxPrice,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': AppConstants.pageSize,
      };

      if (serviceType != null) queryParams['serviceType'] = serviceType;
      if (category != null) queryParams['category'] = category;
      if (level != null) queryParams['level'] = level;
      if (location != null) queryParams['location'] = location;
      if (minPrice != null) queryParams['minPrice'] = minPrice;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;

      final response = await _httpService.get<Map<String, dynamic>>(
        '/missions/search',
        queryParameters: queryParams,
      );

      final missions = (response['data'] as List)
          .map((m) => MissionModel.fromJson(m as Map<String, dynamic>))
          .toList();
      
      return missions;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erreur lors de la recherche de missions',
        code: 'SEARCH_MISSIONS_FAILED',
      );
    }
  }

  @override
  Future<Mission> getMissionById(String id) async {
    try {
      final response = await _httpService.get<Map<String, dynamic>>(
        '/missions/$id',
      );

      return MissionModel.fromJson(response);
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erreur lors de la récupération de la mission',
        code: 'GET_MISSION_FAILED',
      );
    }
  }

  @override
  Future<Mission> createMission({
    required String serviceType,
    required String title,
    required String description,
    String? category,
    String? level,
    required DateTime scheduledDate,
    required int durationMinutes,
    required double price,
    String? providerId,
  }) async {
    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        '/missions',
        data: {
          'serviceType': serviceType,
          'title': title,
          'description': description,
          'category': category,
          'level': level,
          'scheduledDate': scheduledDate.toIso8601String(),
          'durationMinutes': durationMinutes,
          'price': price,
          'providerId': providerId,
        },
      );

      return MissionModel.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erreur lors de la création de la mission',
        code: 'CREATE_MISSION_FAILED',
      );
    }
  }

  @override
  Future<Mission> acceptMission(String missionId) async {
    try {
      final response = await _httpService.patch<Map<String, dynamic>>(
        '/missions/$missionId/accept',
        data: {},
      );

      return MissionModel.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erreur lors de l\'acceptation de la mission',
        code: 'ACCEPT_MISSION_FAILED',
      );
    }
  }

  @override
  Future<Mission> completeMission(String missionId) async {
    try {
      final response = await _httpService.patch<Map<String, dynamic>>(
        '/missions/$missionId/complete',
        data: {},
      );

      return MissionModel.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erreur lors de la complétion de la mission',
        code: 'COMPLETE_MISSION_FAILED',
      );
    }
  }

  @override
  Future<Mission> cancelMission(String missionId) async {
    try {
      final response = await _httpService.patch<Map<String, dynamic>>(
        '/missions/$missionId/cancel',
        data: {},
      );

      return MissionModel.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erreur lors de l\'annulation de la mission',
        code: 'CANCEL_MISSION_FAILED',
      );
    }
  }

  @override
  Future<Mission> rateMission({
    required String missionId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await _httpService.patch<Map<String, dynamic>>(
        '/missions/$missionId/rate',
        data: {
          'rating': rating,
          'comment': comment,
        },
      );

      return MissionModel.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erreur lors de l\'évaluation de la mission',
        code: 'RATE_MISSION_FAILED',
      );
    }
  }

  @override
  Future<List<Mission>> getUserMissions({
    required String userId,
    required String role,
    String? status,
    int page = 1,
  }) async {
    try {
      final endpoint = role == AppConstants.roleClient 
          ? '/missions/client' 
          : '/missions/provider';

      final queryParams = <String, dynamic>{
        'page': page,
        'limit': AppConstants.pageSize,
      };

      if (status != null) queryParams['status'] = status;

      final response = await _httpService.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParams,
      );

      final missions = (response['data'] as List)
          .map((m) => MissionModel.fromJson(m as Map<String, dynamic>))
          .toList();
      
      return missions;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erreur lors de la récupération des missions',
        code: 'GET_USER_MISSIONS_FAILED',
      );
    }
  }
}
