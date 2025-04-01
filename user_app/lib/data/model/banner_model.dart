import 'dart:convert';

class BannerModel {
  final String id;
  final String image;

  BannerModel({required this.id, required this.image});

  // Chuyển đổi từ Object sang Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
    };
  }

  // Chuyển đổi từ Map sang Object
  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      id: map['id'] as String? ?? '',
      image: map['image'] as String? ?? '',
    );
  }

  // Chuyển đổi từ Object sang chuỗi JSON
  String toJson() => json.encode(toMap());

  // Chuyển đổi từ chuỗi JSON sang Object
  factory BannerModel.fromJson(dynamic source) {
    if (source is String) {
      return BannerModel.fromMap(json.decode(source) as Map<String, dynamic>);
    } else if (source is Map<String, dynamic>) {
      return BannerModel.fromMap(source);
    } else {
      throw Exception("Invalid JSON format for BannerModel");
    }
  }

}
