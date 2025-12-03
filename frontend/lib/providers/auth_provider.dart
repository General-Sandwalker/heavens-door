import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/api_client.dart';

class AuthProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  final _storage = const FlutterSecureStorage();

  User? _user;
  String? _token;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  // Check if user is already logged in
  Future<void> checkAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await _storage.read(key: 'auth_token');
      if (_token != null) {
        // Fetch user profile
        final response = await _apiClient.getProfile();
        _user = User.fromJson(response.data);
        _isAuthenticated = true;
      }
    } catch (e) {
      print('Auth check error: $e');
      await logout();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.register({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
      });

      _token = response.data['token'];
      _user = User.fromJson(response.data['user']);
      _isAuthenticated = true;

      await _storage.write(key: 'auth_token', value: _token!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Registration error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.login({
        'email': email,
        'password': password,
      });

      _token = response.data['token'];
      _user = User.fromJson(response.data['user']);
      _isAuthenticated = true;

      await _storage.write(key: 'auth_token', value: _token!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Login error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _user = null;
    _token = null;
    _isAuthenticated = false;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }

  // Update profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.updateProfile(data);
      _user = User.fromJson(response.data['user']);
      notifyListeners();
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }
}
