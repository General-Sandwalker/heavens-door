import 'package:flutter/foundation.dart';
import '../models/property.dart';
import '../services/api_client.dart';

class FavoriteProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<Property> _favorites = [];
  bool _isLoading = false;

  List<Property> get favorites => _favorites;
  bool get isLoading => _isLoading;

  // Fetch favorites
  Future<void> fetchFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.getFavorites();
      _favorites = (response.data['favorites'] as List)
          .map((json) => Property.fromJson(json))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Failed to fetch favorites: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add favorite
  Future<bool> addFavorite(String propertyId) async {
    try {
      await _apiClient.addFavorite(propertyId);
      await fetchFavorites();
      return true;
    } catch (e) {
      print('Failed to add favorite: $e');
      return false;
    }
  }

  // Remove favorite
  Future<bool> removeFavorite(String propertyId) async {
    try {
      await _apiClient.removeFavorite(propertyId);
      _favorites.removeWhere((p) => p.id == propertyId);
      notifyListeners();
      return true;
    } catch (e) {
      print('Failed to remove favorite: $e');
      return false;
    }
  }

  // Toggle favorite
  Future<bool> toggleFavorite(String propertyId, bool currentStatus) async {
    if (currentStatus) {
      return await removeFavorite(propertyId);
    } else {
      return await addFavorite(propertyId);
    }
  }

  bool isFavorite(String propertyId) {
    return _favorites.any((p) => p.id == propertyId);
  }
}
