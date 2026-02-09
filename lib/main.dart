import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iroko/core/services/http_service.dart';
import 'package:iroko/core/theme/app_theme.dart';
import 'package:iroko/data/repositories/auth_repository.dart';
import 'package:iroko/data/repositories/mission_repository.dart';
import 'package:iroko/domain/usecases/auth_usecases.dart';
import 'package:iroko/domain/usecases/mission_usecases.dart';
import 'package:iroko/presentation/auth/login_screen.dart';
import 'package:iroko/presentation/home/home_screen.dart';

// Service Locator
final getIt = GetIt.instance;

void setupServiceLocator() {
  // External
  getIt.registerSingleton<Dio>(Dio());

  // SharedPreferences (async)
  getIt.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );

  // HTTP Service (depends on SharedPreferences)
  getIt.registerSingletonAsync<HttpService>(() async {
    final prefs = await getIt.getAsync<SharedPreferences>();
    return HttpService(dio: getIt<Dio>(), prefs: prefs);
  }, dependsOn: [SharedPreferences]);

  // Repositories (async to wait for services)
  getIt.registerSingletonAsync<AuthRepository>(() async {
    final http = await getIt.getAsync<HttpService>();
    final prefs = await getIt.getAsync<SharedPreferences>();
    return AuthRepositoryImpl(httpService: http, prefs: prefs);
  }, dependsOn: [HttpService, SharedPreferences]);

  getIt.registerSingletonAsync<MissionRepository>(() async {
    final http = await getIt.getAsync<HttpService>();
    return MissionRepositoryImpl(httpService: http);
  }, dependsOn: [HttpService]);

  // UseCases (register after repositories are ready)
  getIt.registerSingletonAsync<LoginUseCase>(() async {
    final authRepo = await getIt.getAsync<AuthRepository>();
    return LoginUseCase(authRepo);
  }, dependsOn: [AuthRepository]);

  getIt.registerSingletonAsync<RegisterUseCase>(() async {
    final authRepo = await getIt.getAsync<AuthRepository>();
    return RegisterUseCase(authRepo);
  }, dependsOn: [AuthRepository]);

  getIt.registerSingletonAsync<GetCurrentUserUseCase>(() async {
    final authRepo = await getIt.getAsync<AuthRepository>();
    return GetCurrentUserUseCase(authRepo);
  }, dependsOn: [AuthRepository]);

  getIt.registerSingletonAsync<LogoutUseCase>(() async {
    final authRepo = await getIt.getAsync<AuthRepository>();
    return LogoutUseCase(authRepo);
  }, dependsOn: [AuthRepository]);

  getIt.registerSingletonAsync<UpdateProfileUseCase>(() async {
    final authRepo = await getIt.getAsync<AuthRepository>();
    return UpdateProfileUseCase(authRepo);
  }, dependsOn: [AuthRepository]);

  getIt.registerSingletonAsync<ResetPasswordUseCase>(() async {
    final authRepo = await getIt.getAsync<AuthRepository>();
    return ResetPasswordUseCase(authRepo);
  }, dependsOn: [AuthRepository]);

  // Mission UseCases
  getIt.registerSingletonAsync<SearchMissionsUseCase>(() async {
    final repo = await getIt.getAsync<MissionRepository>();
    return SearchMissionsUseCase(repo);
  }, dependsOn: [MissionRepository]);

  getIt.registerSingletonAsync<GetMissionByIdUseCase>(() async {
    final repo = await getIt.getAsync<MissionRepository>();
    return GetMissionByIdUseCase(repo);
  }, dependsOn: [MissionRepository]);

  getIt.registerSingletonAsync<CreateMissionUseCase>(() async {
    final repo = await getIt.getAsync<MissionRepository>();
    return CreateMissionUseCase(repo);
  }, dependsOn: [MissionRepository]);

  getIt.registerSingletonAsync<AcceptMissionUseCase>(() async {
    final repo = await getIt.getAsync<MissionRepository>();
    return AcceptMissionUseCase(repo);
  }, dependsOn: [MissionRepository]);

  getIt.registerSingletonAsync<CompleteMissionUseCase>(() async {
    final repo = await getIt.getAsync<MissionRepository>();
    return CompleteMissionUseCase(repo);
  }, dependsOn: [MissionRepository]);

  getIt.registerSingletonAsync<CancelMissionUseCase>(() async {
    final repo = await getIt.getAsync<MissionRepository>();
    return CancelMissionUseCase(repo);
  }, dependsOn: [MissionRepository]);

  getIt.registerSingletonAsync<RateMissionUseCase>(() async {
    final repo = await getIt.getAsync<MissionRepository>();
    return RateMissionUseCase(repo);
  }, dependsOn: [MissionRepository]);

  getIt.registerSingletonAsync<GetUserMissionsUseCase>(() async {
    final repo = await getIt.getAsync<MissionRepository>();
    return GetUserMissionsUseCase(repo);
  }, dependsOn: [MissionRepository]);
}


// Router Configuration
GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      // Add more routes as needed
    ],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await getIt.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'IROKO - Plateforme de Services',
      theme: AppTheme.lightTheme(),
      localizationsDelegates: const [
        // Add localization delegates if needed
      ],
      routerConfig: createRouter(),
      debugShowCheckedModeBanner: false,
    );
  }
}
