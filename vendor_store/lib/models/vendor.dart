import 'dart:convert';

class Vendor {
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String role;
  final String password;

  Vendor({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.role,
    required this.password,
  });

  // Chuyen doi doi tuong Vendor thanh Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'role': role,
      'password': password,
    };
  }

  // Tao doi tuong Vendor tu Map<String, dynamic>
  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      id: map['id']?.toString() ?? '',
      fullName: map['fullName']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      state: map['state']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      locality: map['locality']?.toString() ?? '',
      role: map['role']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
    );
  }


  // Chuyen doi doi tuong Vendor thanh chuoi JSON
  String toJson() => jsonEncode(toMap());

  // Tao doi tuong Vendor tu chuoi JSON
  factory Vendor.fromJson(String source) => Vendor.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
