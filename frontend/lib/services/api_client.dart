import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio _dio;
  final _storage = const FlutterSecureStorage();

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add interceptor for token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expired, clear storage
            await _storage.delete(key: 'auth_token');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
  FlutterSecureStorage get storage => _storage;

  // Auth endpoints
  Future<Response> register(Map<String, dynamic> data) {
    return _dio.post('/auth/register', data: data);
  }

  Future<Response> login(Map<String, dynamic> data) {
    return _dio.post('/auth/login', data: data);
  }

  // User endpoints
  Future<Response> getProfile() {
    return _dio.get('/users/profile');
  }

  Future<Response> updateProfile(Map<String, dynamic> data) {
    return _dio.put('/users/profile', data: data);
  }

  // Property endpoints
  Future<Response> getProperties({Map<String, dynamic>? params}) {
    return _dio.get('/properties', queryParameters: params);
  }

  Future<Response> getPropertyById(String id) {
    return _dio.get('/properties/$id');
  }

  Future<Response> createProperty(Map<String, dynamic> data) {
    return _dio.post('/properties', data: data);
  }

  Future<Response> updateProperty(String id, Map<String, dynamic> data) {
    return _dio.put('/properties/$id', data: data);
  }

  Future<Response> deleteProperty(String id) {
    return _dio.delete('/properties/$id');
  }

  Future<Response> searchProperties(String query) {
    return _dio.get('/properties/search', queryParameters: {'q': query});
  }

  // Favorite endpoints
  Future<Response> getFavorites() {
    return _dio.get('/favorites');
  }

  Future<Response> addFavorite(String propertyId) {
    return _dio.post('/favorites/$propertyId');
  }

  Future<Response> removeFavorite(String propertyId) {
    return _dio.delete('/favorites/$propertyId');
  }

  // Message endpoints
  Future<Response> getConversations() {
    return _dio.get('/messages');
  }

  Future<Response> getConversation(String userId) {
    return _dio.get('/messages/conversation/$userId');
  }

  Future<Response> sendMessage(Map<String, dynamic> data) {
    return _dio.post('/messages', data: data);
  }

  Future<Response> markAsRead(String messageId) {
    return _dio.put('/messages/$messageId/read');
  }
}
