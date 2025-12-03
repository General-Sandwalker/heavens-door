import 'package:flutter/foundation.dart';
import '../models/property.dart';
import '../services/api_client.dart';

class PropertyProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<Property> _properties = [];
  Property? _selectedProperty;
  bool _isLoading = false;
  String? _error;

  List<Property> get properties => _properties;
  Property? get selectedProperty => _selectedProperty;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all properties
  Future<void> fetchProperties({Map<String, dynamic>? filters}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.getProperties(params: filters);
      _properties = (response.data['properties'] as List)
          .map((json) => Property.fromJson(json))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch properties: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch property by ID
  Future<void> fetchPropertyById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.getPropertyById(id);
      _selectedProperty = Property.fromJson(response.data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch property: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search properties
  Future<void> searchProperties(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.searchProperties(query);
      _properties = (response.data['properties'] as List)
          .map((json) => Property.fromJson(json))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Search failed: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create property
  Future<bool> createProperty(Map<String, dynamic> data) async {
    try {
      await _apiClient.createProperty(data);
      await fetchProperties(); // Refresh list
      return true;
    } catch (e) {
      _error = 'Failed to create property: $e';
      notifyListeners();
      return false;
    }
  }

  // Update property
  Future<bool> updateProperty(String id, Map<String, dynamic> data) async {
    try {
      await _apiClient.updateProperty(id, data);
      await fetchProperties(); // Refresh list
      return true;
    } catch (e) {
      _error = 'Failed to update property: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete property
  Future<bool> deleteProperty(String id) async {
    try {
      await _apiClient.deleteProperty(id);
      _properties.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete property: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
