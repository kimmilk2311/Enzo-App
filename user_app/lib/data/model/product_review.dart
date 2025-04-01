import 'dart:convert';

class ProductReview {
  final String id;
  final String buyerId;
  final String fullName;
  final String email;
  final String productId;
  final double rating;
  final String review;

  ProductReview({
    required this.id,
    required this.buyerId,
    required this.email,
    required this.fullName,
    required this.productId,
    required this.rating,
    required this.review,
  });

  // Chuyển đổi từ Object sang Map (Gửi API)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'buyerId': buyerId,
      'fullName':fullName,
      'email': email,
      'productId': productId,
      'rating': rating,
      'review': review,
    };
  }

  String toJson() => json.encode(toMap());

  // Chuyển đổi từ Map sang Object (Nhận API)
  factory ProductReview.fromJson(Map<String, dynamic> map) {
    return ProductReview(
      id: map['_id'] ?? '',
      buyerId: map['buyerId'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      productId: map['productId'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      review: map['review'] ?? '',
    );
  }
}
