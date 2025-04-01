import 'dart:convert';

class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String image;
  final String address;
  final String token;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.image,
    required this.address,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'image': image,
      'address': address,
      'token': token,
    };
  }

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      image: map['image'] as String? ?? '',
      address: map['address'] as String? ?? '',
      token: map['token'] as String? ?? '',
    );
  }

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
