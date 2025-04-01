import 'dart:convert';

class Vendor {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String image;
  final String password;

  Vendor({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.image,
    required this.password,
  });

  // Chuyen doi doi tuong Vendor thanh Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'image': image,
      'password': password,
    };
  }

  // Tao doi tuong Vendor tu Map<String, dynamic>
  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      id: map['id']?.toString() ?? '',
      fullName: map['fullName']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
    );
  }

  // Chuyen doi doi tuong Vendor thanh chuoi JSON
  String toJson() => jsonEncode(toMap());

  // Tao doi tuong Vendor tu chuoi JSON
  factory Vendor.fromJson(String source) =>
      Vendor.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
