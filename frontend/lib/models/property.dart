class Property {
  final String id;
  final String title;
  final String description;
  final String propertyType;
  final String listingType;
  final double price;
  final String address;
  final String city;
  final String? state;
  final String country;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final int? bedrooms;
  final double? bathrooms;
  final int? areaSqft;
  final int? yearBuilt;
  final String status;
  final List<String> images;
  final List<String> amenities;
  final int viewsCount;
  final int favoriteCount;
  final bool isFavorited;
  final PropertyOwner owner;
  final DateTime createdAt;
  final DateTime updatedAt;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.propertyType,
    required this.listingType,
    required this.price,
    required this.address,
    required this.city,
    this.state,
    required this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.bedrooms,
    this.bathrooms,
    this.areaSqft,
    this.yearBuilt,
    required this.status,
    required this.images,
    required this.amenities,
    required this.viewsCount,
    required this.favoriteCount,
    this.isFavorited = false,
    required this.owner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      propertyType: json['propertyType'],
      listingType: json['listingType'],
      price: (json['price'] as num).toDouble(),
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'] != null
          ? (json['bathrooms'] as num).toDouble()
          : null,
      areaSqft: json['areaSqft'],
      yearBuilt: json['yearBuilt'],
      status: json['status'],
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      viewsCount: json['viewsCount'] ?? 0,
      favoriteCount: json['favoriteCount'] ?? 0,
      isFavorited: json['isFavorited'] ?? false,
      owner: PropertyOwner.fromJson(json['owner']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  String get priceFormatted => '\$${price.toStringAsFixed(0)}';
  String get fullAddress => '$address, $city, $country';
  bool get hasLocation => latitude != null && longitude != null;
}

class PropertyOwner {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? bio;

  PropertyOwner({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.bio,
  });

  factory PropertyOwner.fromJson(Map<String, dynamic> json) {
    return PropertyOwner(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
    );
  }

  String get fullName => '$firstName $lastName';
}
