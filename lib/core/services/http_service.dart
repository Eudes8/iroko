import 'package:dio/dio.dart';
import 'package:iroko/core/constants/app_constants.dart';
import 'package:iroko/core/utils/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  final Dio _dio;
  final SharedPreferences _prefs;

  HttpService({
    required Dio dio,
    required SharedPreferences prefs,
  })  : _dio = dio,
        _prefs = prefs {
    _setupDio();
  }

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectionTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      contentType: 'application/json',
    );

    _dio.interceptors.add(_AuthInterceptor(_prefs));
    _dio.interceptors.add(_ErrorInterceptor());
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return response.data as T;
    } catch (e) {
      rethrow;
    }
  }

  Future<T> post<T>(
    String path, {
    required data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data as T;
    } catch (e) {
      rethrow;
    }
  }

  Future<T> put<T>(
    String path, {
    required data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data as T;
    } catch (e) {
      rethrow;
    }
  }

  Future<T> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return response.data as T;
    } catch (e) {
      rethrow;
    }
  }

  Future<T> patch<T>(
    String path, {
    required data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data as T;
    } catch (e) {
      rethrow;
    }
  }

  String? getAuthToken() {
    return _prefs.getString(AppConstants.storageKeyAuthToken);
  }

  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(AppConstants.storageKeyAuthToken, token);
  }

  Future<void> clearAuthToken() async {
    await _prefs.remove(AppConstants.storageKeyAuthToken);
  }
}

class _AuthInterceptor extends QueuedInterceptor {
  final SharedPreferences _prefs;

  _AuthInterceptor(this._prefs);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = _prefs.getString(AppConstants.storageKeyAuthToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type == DioExceptionType.connectionTimeout) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException(
            message: 'Délai d\'expiration de la connexion',
            code: 'CONNECTION_TIMEOUT',
          ),
        ),
      );
    } else if (err.type == DioExceptionType.receiveTimeout) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException(
            message: 'Délai d\'expiration de la réception',
            code: 'RECEIVE_TIMEOUT',
          ),
        ),
      );
    } else if (err.response != null) {
      final statusCode = err.response?.statusCode ?? 0;
      final data = err.response?.data as Map<String, dynamic>?;
      final message = data?['message'] as String? ?? 'Une erreur est survenue';

      switch (statusCode) {
        case 400:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ValidationException(
                message: message,
                code: 'VALIDATION_ERROR',
              ),
            ),
          );
          break;
        case 401:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: AuthenticationException(
                message: message,
                code: 'UNAUTHORIZED',
              ),
            ),
          );
          break;
        case 403:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: AuthorizationException(
                message: message,
                code: 'FORBIDDEN',
              ),
            ),
          );
          break;
        case 404:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: NotFoundException(
                message: message,
                code: 'NOT_FOUND',
              ),
            ),
          );
          break;
        case 409:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ConflictException(
                message: message,
                code: 'CONFLICT',
              ),
            ),
          );
          break;
        default:
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ServerException(
                message: message,
                code: 'SERVER_ERROR_$statusCode',
              ),
            ),
          );
      }
    } else {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException(
            message: 'Erreur réseau: ${err.message}',
            code: 'NETWORK_ERROR',
          ),
        ),
      );
    }
  }
}
