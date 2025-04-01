import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/data/model/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, Favorite>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<Map<String, Favorite>> {
  FavoriteNotifier() : super({}) {
    _loadFavorite();
  }
  // Phương thức riêng tư đển load item từ danh sách yêu thích
  Future<void> _loadFavorite() async {
    // Lấy sự yêu thích để lưu trữ trong dữ liệu
    final prefs = await SharedPreferences.getInstance();
    // Nạp chuỗi Json của các mục yêu thích từ danh sách yêu thích được chia sẽ dưới key favorite
    final favoriteString = prefs.getString('favorites');
    // Kiểm tra nếu String không được null , nghĩa là data lưu trữ
    if (favoriteString != null) {
      // Giải mã json String vào Map of dymaic data
      final Map<String, dynamic> favoriteMap = jsonDecode(favoriteString);

      //convert the dynamic map into map of favorite objsect using fromjson factory method
      final favorites = favoriteMap.map((key, value) {
        final favoriteData = value is String ? jsonDecode(value) : value;
        return MapEntry(key, Favorite.fromJson(favoriteData));
      });

      //updaing the state with the loaded favorites
      state = favorites;
    }
  }

  // Phương thức riêng tư để lưu danh sách hiện tại yêu thích
  Future<void> _saveFavorites() async {
    // Lấy sự yêu thích để lưu trữ trong dữ liệu
    final prefs = await SharedPreferences.getInstance();
    // Mã hoá trạng thái hiện tại (Map of favorite object) into json String
    final favoriteString = jsonEncode(
      state.map((key, value) => MapEntry(key, value.toMap())),
    );
    //saving the json string đến sở thích được chia sẽ với the key "favorites"
    await prefs.setString('favorites', favoriteString);
  }

  void addProductToFavorite({
    required String productId,
    required String productName,
    required int productPrice,
    required String category,
    required List<String> images,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String description,
    required String fullName,
  }) {
    state[productId] = Favorite(
        productId: productId,
        productName: productName,
        productPrice: productPrice,
        category: category,
        images: images,
        vendorId: vendorId,
        productQuantity: productQuantity,
        quantity: quantity,
        description: description,
        fullName: fullName);

    // thông báo cho người dùng trạng thái đã thay đổi
    state = {...state};
    _saveFavorites();
  }

  // Xoa san pham khoi gio hang
  void removeFavoriteItem(String productId) {
    state.remove(productId);
    // trang thai  sau thay doi
    state = {...state};
    _saveFavorites();
  }

  Map<String, Favorite> get getFavortiteItems => state;
}
