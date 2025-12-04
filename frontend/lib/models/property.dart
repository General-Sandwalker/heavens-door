class Property {
  final int id;
  final String title;
  final String? description;
  final String propertyType;
  final double price;
  final String address;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final int bedrooms;
  final int bathrooms;
  final double? area;
  final List<String> images;
  final int ownerId;
  final String? ownerUsername;
  final double? averageRating;
  final int reviewCount;
  final bool isRented;
  final DateTime? rentalStartDate;
  final DateTime? rentalEndDate;
  final int? rentedToUserId;
  final DateTime createdAt;

  Property({
    required this.id,
    required this.title,
    this.description,
    required this.propertyType,
    required this.price,
    required this.address,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.bedrooms,
    required this.bathrooms,
    this.area,
    required this.images,
    required this.ownerId,
    this.ownerUsername,
    this.averageRating,
    required this.reviewCount,
    this.isRented = false,
    this.rentalStartDate,
    this.rentalEndDate,
    this.rentedToUserId,
    required this.createdAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      propertyType: json['property_type'],
      price: (json['price'] as num).toDouble(),
      address: json['address'],
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      area: json['area'] != null ? (json['area'] as num).toDouble() : null,
      images: List<String>.from(json['images'] ?? []),
      ownerId: json['owner_id'],
      ownerUsername: json['owner_username'],
      averageRating: json['average_rating'] != null
          ? (json['average_rating'] as num).toDouble()
          : null,
      reviewCount: json['review_count'] ?? 0,
      isRented: json['is_rented'] ?? false,
      rentalStartDate: json['rental_start_date'] != null
          ? DateTime.parse(json['rental_start_date'])
          : null,
      rentalEndDate: json['rental_end_date'] != null
          ? DateTime.parse(json['rental_end_date'])
          : null,
      rentedToUserId: json['rented_to_user_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'property_type': propertyType,
      'price': price,
      'address': address,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'images': images,
      'owner_id': ownerId,
      'owner_username': ownerUsername,
      'average_rating': averageRating,
      'review_count': reviewCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get propertyTypeDisplay {
    switch (propertyType) {
      case 'apartment':
        return 'Apartment';
      case 'house':
        return 'House';
      case 'villa':
        return 'Villa';
      case 'studio':
        return 'Studio';
      case 'shop':
        return 'Shop';
      default:
        return propertyType;
    }
  }

  String get pricePerMonth => '\$${price.toStringAsFixed(0)}/month';
}

class PropertyCreate {
  final String title;
  final String? description;
  final String propertyType;
  final double price;
  final String address;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final int bedrooms;
  final int bathrooms;
  final double? area;
  final List<String> images;

  PropertyCreate({
    required this.title,
    this.description,
    required this.propertyType,
    required this.price,
    required this.address,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.bedrooms = 1,
    this.bathrooms = 1,
    this.area,
    this.images = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'property_type': propertyType,
      'price': price,
      'address': address,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'images': images,
    };
  }
}
