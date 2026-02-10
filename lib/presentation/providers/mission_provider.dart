import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iroko/core/utils/exceptions.dart';
import 'package:iroko/domain/entities/mission.dart';
import 'package:iroko/domain/usecases/mission_usecases.dart';

class MissionProvider extends ChangeNotifier {
  final _getIt = GetIt.instance;
  
  List<Mission> _missions = [];
  Mission? _selectedMission;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _filters = {};

  // Getters
  List<Mission> get missions => _missions;
  Mission? get selectedMission => _selectedMission;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get filters => _filters;

  // Search missions
  Future<void> searchMissions({
    String? type,
    String? location,
    String? status,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _filters = {
        if (type != null) 'type': type,
        if (location != null) 'location': location,
        if (status != null) 'status': status,
      };

      final useCase = await _getIt.getAsync<SearchMissionsUseCase>();
      final params = SearchMissionsParams(
        serviceType: _filters['type'],
        location: _filters['location'],
        page: 1,
      );
      _missions = await useCase.call(params);
      _isLoading = false;
      notifyListeners();
    } on AppException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erreur lors de la recherche des missions';
      notifyListeners();
    }
  }

  // Get mission details
  Future<void> getMissionById(String id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final useCase = await _getIt.getAsync<GetMissionByIdUseCase>();
      _selectedMission = await useCase.call(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erreur lors de la récupération des détails';
      notifyListeners();
    }
  }

  // Create mission
  Future<bool> createMission(Mission mission) async {
    try {
      _isLoading = true;
      notifyListeners();

      final useCase = await _getIt.getAsync<CreateMissionUseCase>();
      final params = CreateMissionParams(
        serviceType: mission.serviceType,
        title: mission.title,
        description: mission.description,
        category: mission.category,
        level: mission.level,
        scheduledDate: mission.scheduledDate,
        durationMinutes: mission.durationMinutes,
        price: mission.price,
        providerId: mission.providerId,
      );
      final newMission = await useCase.call(params);
      _missions.insert(0, newMission);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erreur lors de la création de la mission';
      notifyListeners();
      return false;
    }
  }

  // Accept mission
  Future<bool> acceptMission(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      final useCase = await _getIt.getAsync<AcceptMissionUseCase>();
      final mission = await useCase.call(id);
      
      final index = _missions.indexWhere((m) => m.id == id);
      if (index >= 0) {
        _missions[index] = mission;
      }
      if (_selectedMission?.id == id) {
        _selectedMission = mission;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erreur lors de l\'acceptation de la mission';
      notifyListeners();
      return false;
    }
  }

  // Complete mission
  Future<bool> completeMission(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      final useCase = await _getIt.getAsync<CompleteMissionUseCase>();
      final mission = await useCase.call(id);
      
      final index = _missions.indexWhere((m) => m.id == id);
      if (index >= 0) {
        _missions[index] = mission;
      }
      if (_selectedMission?.id == id) {
        _selectedMission = mission;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erreur lors de la finalisation de la mission';
      notifyListeners();
      return false;
    }
  }

  // Clear filters
  void clearFilters() {
    _filters.clear();
    _missions.clear();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
