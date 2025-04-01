import 'dart:convert';

class Category {
  final String id;
  final String name;
  final String image;
  final String banner;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.banner,
  });

  // Chuyển đổi từ Object sang Map (Gửi API)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'image': image,
      'banner': banner,
    };
  }

  String toJson() => json.encode(toMap());

  // Chuyển đổi từ Map sang Object (Nhận API)
  factory Category.fromJson(Map<String, dynamic> map) {
    return Category(
      id: map['_id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      image: map['image'] as String? ?? '',
      banner: map['banner'] as String? ?? '',
    );
  }
}
