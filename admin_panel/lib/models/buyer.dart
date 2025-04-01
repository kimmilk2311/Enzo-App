import 'dart:convert';

class Buyer {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String image;
  final String address;
  final String password;

  Buyer({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.image,
    required this.address,
    required this.password,
  });

  // Chuyen doi doi tuong Buyer thanh Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'image': image,
      'address': address,
      'password': password,
    };
  }

  // Tao doi tuong Buyer tu Map<String, dynamic>
  factory Buyer.fromMap(Map<String, dynamic> map) {
    return Buyer(
      id: map['id']?.toString() ?? '',
      fullName: map['fullName']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
    );
  }

  // Chuyen doi doi tuong Buyer thanh chuoi JSON
  String toJson() => jsonEncode(toMap());

  // Tao doi tuong Buyer tu chuoi JSON
  factory Buyer.fromJson(String source) =>
      Buyer.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
