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

  Future<void> _loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteString = prefs.getString('favorites');
    if (favoriteString != null) {
      final Map<String, dynamic> favoriteMap = jsonDecode(favoriteString);
      final favorites = favoriteMap.map((key, value) {
        final favoriteData = value is String ? jsonDecode(value) : value;
        return MapEntry(key, Favorite.fromJson(favoriteData));
      });
      state = favorites;
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteString = jsonEncode(
      state.map((key, value) => MapEntry(key, value.toMap())),
    );
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
      fullName: fullName,
    );
    state = {...state};
    _saveFavorites();
  }

  void removeFavoriteItem(String productId) {
    state.remove(productId);
    state = {...state};
    _saveFavorites();
  }

  void resetFavorites() async {
    state = {};
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorites');
  }

  Map<String, Favorite> get getFavortiteItems => state;
}
