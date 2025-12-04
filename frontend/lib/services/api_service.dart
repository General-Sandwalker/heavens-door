import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/property.dart';
import '../models/review.dart';
import '../models/message.dart';

class ApiService {
  // Use 10.0.2.2 for Android emulator to access host machine's localhost
  // Use localhost for web/desktop or change to your actual IP for physical device
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Get stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Save token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Remove token
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Sign up
  Future<AuthResponse> signup({
    required String email,
    required String username,
    required String password,
    String? fullName,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
        'full_name': fullName,
      }),
    );

    if (response.statusCode == 201) {
      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
      await saveToken(authResponse.accessToken);
      return authResponse;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Signup failed');
    }
  }

  // Login
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
      await saveToken(authResponse.accessToken);
      return authResponse;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Login failed');
    }
  }

  // Get current user
  Future<User> getCurrentUser() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user info');
    }
  }

  // Verify token
  Future<bool> verifyToken() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/verify-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await removeToken();
  }

  // ========== Property Methods ==========

  // Get all properties
  Future<List<Property>> getProperties({
    String? propertyType,
    double? minPrice,
    double? maxPrice,
    String? city,
    String? country,
  }) async {
    final queryParams = <String, String>{};
    if (propertyType != null) queryParams['property_type'] = propertyType;
    if (minPrice != null) queryParams['min_price'] = minPrice.toString();
    if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();
    if (city != null && city.isNotEmpty) queryParams['city'] = city;
    if (country != null && country.isNotEmpty) queryParams['country'] = country;

    final uri = Uri.parse(
      '$baseUrl/properties',
    ).replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Property.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load properties');
    }
  }

  // Get property by ID
  Future<Property> getProperty(int propertyId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/properties/$propertyId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Property.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load property');
    }
  }

  // Create property
  Future<Property> createProperty(PropertyCreate property) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final propertyJson = property.toJson();
    print('Creating property with data: $propertyJson');

    final response = await http.post(
      Uri.parse('$baseUrl/properties/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(propertyJson),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      return Property.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to create property');
    }
  }

  // Update property
  Future<Property> updateProperty(
    int propertyId,
    Map<String, dynamic> updates,
  ) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.put(
      Uri.parse('$baseUrl/properties/$propertyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      return Property.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to update property');
    }
  }

  // Delete property
  Future<void> deleteProperty(int propertyId) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.delete(
      Uri.parse('$baseUrl/properties/$propertyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to delete property');
    }
  }

  // ========== Review Methods ==========

  // Get property reviews
  Future<List<Review>> getPropertyReviews(int propertyId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/properties/$propertyId/reviews'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  // Create review
  Future<Review> createReview(int propertyId, ReviewCreate review) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.post(
      Uri.parse('$baseUrl/properties/$propertyId/reviews'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(review.toJson()),
    );

    if (response.statusCode == 201) {
      return Review.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to create review');
    }
  }

  // Delete review
  Future<void> deleteReview(int reviewId) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.delete(
      Uri.parse('$baseUrl/properties/reviews/$reviewId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to delete review');
    }
  }

  // ===== Messages =====

  // Send message
  Future<Message> sendMessage(MessageCreate message) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.post(
      Uri.parse('$baseUrl/messages/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode == 200) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to send message');
    }
  }

  // Get conversations
  Future<List<Conversation>> getConversations() async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/messages/conversations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Conversation.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized - please log in again');
    } else {
      throw Exception('Failed to load conversations');
    }
  }

  // Get conversation with specific user
  Future<List<Message>> getConversation(
    int otherUserId, {
    int? propertyId,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final uri = propertyId != null
        ? Uri.parse(
            '$baseUrl/messages/conversation/$otherUserId?property_id=$propertyId',
          )
        : Uri.parse('$baseUrl/messages/conversation/$otherUserId');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Message.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized - please log in again');
    } else {
      throw Exception('Failed to load conversation');
    }
  }

  // Get unread message count
  Future<int> getUnreadMessageCount() async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/messages/unread-count'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['unread_count'];
    } else {
      throw Exception('Failed to get unread count');
    }
  }

  // Delete message
  Future<void> deleteMessage(int messageId) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.delete(
      Uri.parse('$baseUrl/messages/$messageId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to delete message');
    }
  }

  // Update rental status
  Future<Property> updateRentalStatus(
    int propertyId, {
    required bool isRented,
    DateTime? rentalStartDate,
    DateTime? rentalEndDate,
    int? rentedToUserId,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final Map<String, dynamic> body = {'is_rented': isRented};

    if (rentalStartDate != null) {
      body['rental_start_date'] = rentalStartDate.toIso8601String().split(
        'T',
      )[0];
    }
    if (rentalEndDate != null) {
      body['rental_end_date'] = rentalEndDate.toIso8601String().split('T')[0];
    }
    if (rentedToUserId != null) {
      body['rented_to_user_id'] = rentedToUserId;
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/properties/$propertyId/rental-status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return Property.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 403) {
      throw Exception('Only the owner can update rental status');
    } else {
      throw Exception('Failed to update rental status');
    }
  }
}
