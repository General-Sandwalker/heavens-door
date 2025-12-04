class Review {
  final int id;
  final int propertyId;
  final int userId;
  final String username;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.username,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      propertyId: json['property_id'],
      userId: json['user_id'],
      username: json['username'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'user_id': userId,
      'username': username,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ReviewCreate {
  final int rating;
  final String? comment;

  ReviewCreate({required this.rating, this.comment});

  Map<String, dynamic> toJson() {
    return {'rating': rating, 'comment': comment};
  }
}
