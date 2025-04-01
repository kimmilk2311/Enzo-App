import 'dart:convert';

class Order {
  final String id;
  final String fullName;
  final String email;
  final String address;
  final String productName;
  final int productPrice;
  final int quantity;
  final String category;
  final String image;
  final String phone;
  final String buyerId;
  final String vendorId;
  final bool processing;
  final bool delivered;

  Order({
    required this.id,
    required this.fullName,
    required this.email,
    required this.address,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.category,
    required this.image,
    required this.phone,
    required this.buyerId,
    required this.vendorId,
    required this.processing,
    required this.delivered,
  });

  // Chuyen object sang Map (gui API)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'fullName': fullName,
      'email': email,
      'address': address,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'category': category,
      'image': image,
      'phone': phone,
      'buyerId': buyerId,
      'vendorId': vendorId,
      'processing': processing,
      'delivered': delivered,
    };
  }

  // Chuyen object sang chuoi JSON
  String toJson() => json.encode(toMap());

  // Chuyen Map sang object (nhan tu API)
  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      address: map['address'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      productPrice: map['productPrice'] as int? ?? 0,
      quantity: map['quantity'] as int? ?? 0,
      category: map['category'] as String? ?? '',
      image: map['image'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      buyerId: map['buyerId'] as String? ?? '',
      vendorId: map['vendorId'] as String? ?? '',
      processing: map['processing'] as bool? ?? false,
      delivered: map['delivered'] as bool? ?? false,
    );
  }
}
