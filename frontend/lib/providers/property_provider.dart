import 'package:flutter/material.dart';
import '../models/property.dart';
import '../models/review.dart';
import '../services/api_service.dart';

class PropertyProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Property> _properties = [];
  Property? _selectedProperty;
  List<Review> _reviews = [];
  bool _isLoading = false;
  String? _error;
  Set<int> _savedPropertyIds = {};
  List<Property> _savedProperties = [];

  List<Property> get properties => _properties;
  Property? get selectedProperty => _selectedProperty;
  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Set<int> get savedPropertyIds => _savedPropertyIds;
  List<Property> get savedProperties => _savedProperties;

  // Load all properties
  Future<void> loadProperties({
    String? propertyType,
    double? minPrice,
    double? maxPrice,
    String? city,
    String? country,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _properties = await _apiService.getProperties(
        propertyType: propertyType,
        minPrice: minPrice,
        maxPrice: maxPrice,
        city: city,
        country: country,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load single property
  Future<void> loadProperty(int propertyId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedProperty = await _apiService.getProperty(propertyId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create property
  Future<bool> createProperty(PropertyCreate property) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newProperty = await _apiService.createProperty(property);
      _properties.insert(0, newProperty);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update property
  Future<bool> updateProperty(
    int propertyId,
    Map<String, dynamic> updates,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedProperty = await _apiService.updateProperty(
        propertyId,
        updates,
      );
      final index = _properties.indexWhere((p) => p.id == propertyId);
      if (index != -1) {
        _properties[index] = updatedProperty;
      }
      if (_selectedProperty?.id == propertyId) {
        _selectedProperty = updatedProperty;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete property
  Future<bool> deleteProperty(int propertyId) async {
    try {
      await _apiService.deleteProperty(propertyId);
      _properties.removeWhere((p) => p.id == propertyId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Update rental status
  Future<bool> updatePropertyRentalStatus(
    int propertyId, {
    required bool isRented,
    DateTime? rentalStartDate,
    DateTime? rentalEndDate,
    int? rentedToUserId,
  }) async {
    try {
      final updatedProperty = await _apiService.updateRentalStatus(
        propertyId,
        isRented: isRented,
        rentalStartDate: rentalStartDate,
        rentalEndDate: rentalEndDate,
        rentedToUserId: rentedToUserId,
      );

      final index = _properties.indexWhere((p) => p.id == propertyId);
      if (index != -1) {
        _properties[index] = updatedProperty;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Load reviews for a property
  Future<void> loadReviews(int propertyId) async {
    try {
      _reviews = await _apiService.getPropertyReviews(propertyId);
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Add review
  Future<bool> addReview(int propertyId, ReviewCreate review) async {
    try {
      final newReview = await _apiService.createReview(propertyId, review);
      _reviews.insert(0, newReview);

      // Update property rating
      if (_selectedProperty != null && _selectedProperty!.id == propertyId) {
        await loadProperty(propertyId);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Delete review
  Future<bool> deleteReview(int reviewId) async {
    try {
      await _apiService.deleteReview(reviewId);
      _reviews.removeWhere((r) => r.id == reviewId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSelectedProperty() {
    _selectedProperty = null;
    _reviews = [];
    notifyListeners();
  }

  // Toggle save property
  void toggleSaveProperty(int propertyId) {
    if (_savedPropertyIds.contains(propertyId)) {
      _savedPropertyIds.remove(propertyId);
      _savedProperties.removeWhere((p) => p.id == propertyId);
    } else {
      _savedPropertyIds.add(propertyId);
      final property = _properties.firstWhere(
        (p) => p.id == propertyId,
        orElse: () => _selectedProperty!,
      );
      _savedProperties.insert(0, property);
    }
    notifyListeners();
  }

  // Check if property is saved
  bool isPropertySaved(int propertyId) {
    return _savedPropertyIds.contains(propertyId);
  }

  // Load saved properties
  Future<void> loadSavedProperties() async {
    _isLoading = true;
    notifyListeners();

    // Filter saved properties from all properties
    _savedProperties = _properties
        .where((p) => _savedPropertyIds.contains(p.id))
        .toList();

    _isLoading = false;
    notifyListeners();
  }
}
