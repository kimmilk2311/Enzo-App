import 'dart:convert';

class Favorite {
  final String productId;
  final String productName;
  final int productPrice;
  final String category;
  final List<String> images;
  final String vendorId;
  final int productQuantity;
  int quantity;
  final String description;
  final String fullName;

  Favorite({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.category,
    required this.images,
    required this.vendorId,
    required this.productQuantity,
    required this.quantity,
    required this.description,
    required this.fullName,
  });

  // Chuyển từ object sang Map (dùng cho API hoặc lưu trữ)
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'category': category,
      'images': images,
      'vendorId': vendorId,
      'productQuantity': productQuantity,
      'quantity': quantity,
      'description': description,
      'fullName': fullName,
    };
  }

  // Chuyển từ Map sang JSON string
  String toJson() => json.encode(toMap());

  // Tạo object từ Map (dùng khi nhận từ API hoặc local storage)
  factory Favorite.fromJson(Map<String, dynamic> map) {
    return Favorite(
      productId: map['productId'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      productPrice: map['productPrice'] as int? ?? 0,
      category: map['category'] as String? ?? '',
      images: List<String>.from(map['images'] ?? []),
      vendorId: map['vendorId'] as String? ?? '',
      productQuantity: map['productQuantity'] as int? ?? 0,
      quantity: map['quantity'] as int? ?? 1,
      description: map['description'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
    );
  }
}
