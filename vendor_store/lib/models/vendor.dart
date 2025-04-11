import 'dart:convert';

class Vendor {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String image;
  final String address;
  final String role;
  final String password;

  Vendor({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.image,
    required this.address,
    required this.role,
    required this.password,
  });

  // Chuyển đổi từ Object sang Map (Gửi API)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'image': image,
      'address': address,
      'role': role,
      'password': password,
    };
  }

  // Chuyển đổi từ Map sang JSON (Gửi API)
  String toJson() => json.encode(toMap());

  // Chuyển đổi từ Map sang Object (Nhận API)
  factory Vendor.fromJson(Map<String, dynamic> map) {
    return Vendor(
      id: map['_id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      image: map['image'] as String? ?? '',
      address: map['address'] as String? ?? '',
      role: map['role'] as String? ?? '',
      password: map['password'] as String? ?? '',
    );
  }

  // Chuyển đổi từ JSON sang Object (Nhận API)
  factory Vendor.fromJsonString(String source) => Vendor.fromJson(json.decode(source) as Map<String, dynamic>);
}
