import 'package:flutter/foundation.dart';
import '../services/api_client.dart';

class MessageProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<Map<String, dynamic>> _conversations = [];
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get conversations => _conversations;
  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;

  // Fetch conversations
  Future<void> fetchConversations() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.getConversations();
      _conversations = List<Map<String, dynamic>>.from(
        response.data['conversations'],
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Failed to fetch conversations: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch conversation with user
  Future<void> fetchConversation(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.getConversation(userId);
      _messages = List<Map<String, dynamic>>.from(response.data['messages']);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Failed to fetch conversation: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Send message
  Future<bool> sendMessage({
    required String receiverId,
    required String content,
    String? propertyId,
  }) async {
    try {
      await _apiClient.sendMessage({
        'receiverId': receiverId,
        'content': content,
        'propertyId': propertyId,
      });
      await fetchConversation(receiverId);
      return true;
    } catch (e) {
      print('Failed to send message: $e');
      return false;
    }
  }
}
