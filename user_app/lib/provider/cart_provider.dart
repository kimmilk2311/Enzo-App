import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/data/model/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({}) {
    _loadCartItems();
  }

  // Phương thức riêng tư đển load item từ cart
  Future<void> _loadCartItems() async {
    // Lấy sự cart để lưu trữ trong dữ liệu
    final prefs = await SharedPreferences.getInstance();
    // Nạp chuỗi Json của các cart từ cart được chia sẽ dưới key cart_items
    final cartString = prefs.getString('cart_items');
    // Kiểm tra nếu String không được null , nghĩa là data lưu trữ
    if (cartString != null) {
      // Giải mã json String vào Map of dymaic data
      final Map<String, dynamic> cartMap = jsonDecode(cartString);

      //convert the dynamic map into map of cart objsect using fromjson factory method
      final cartItems = cartMap.map((key, value) {
        final cartData = value is String ? jsonDecode(value) : value;
        return MapEntry(key, Cart.fromJson(cartData));
      });

      //updaing the state with the loaded favorites
      state = cartItems;
    }
  }

  // Phương thức riêng tư để lưu danh sách cart
  Future<void> _saveCartItems() async {
    // Lấy cart để lưu trữ trong dữ liệu
    final prefs = await SharedPreferences.getInstance();
    // Mã hoá trạng thái hiện tại (Map of favorite object) into json String
    final cartString = jsonEncode(
      state.map((key, value) => MapEntry(key, value.toMap())),
    );
    //saving the json string đến carrt được chia sẽ với the key "cart"
    await prefs.setString('cart_items', cartString);
  }

  // Ham them san pham vao gio hang
  void addProductToCart({
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
    // Kiem tra neu san pham da co trong gio hang
    if (state.containsKey(productId)) {
      state = {
        ...state, // Sao chep trang thai hien tai
        productId: Cart(
          productId: state[productId]!.productId,
          productName: state[productId]!.productName,
          productPrice: state[productId]!.productPrice,
          category: state[productId]!.category,
          images: state[productId]!.images,
          vendorId: state[productId]!.vendorId,
          productQuantity: state[productId]!.productQuantity,
          quantity: state[productId]!.quantity + 1,
          description: state[productId]!.description,
          fullName: state[productId]!.fullName,
        ),
      };
      _saveCartItems();
    } else {
      // Neu san pham chua co trong gio hang, them moi
      state = {
        ...state,
        productId: Cart(
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
        ),
      };
      _saveCartItems();
    }
  }

  // Ham tang so luong san pham
  void incrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;

      // Trang thai sau thay doi
      state = {...state};
      _saveCartItems();
    }
  }

  // Ham giam so luong san pham
  void decrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;

      // trang thai sau thay doi
      state = {...state};
      _saveCartItems();
    }
  }

  // Xoa san pham khoi gio hang
  void removeCartItem(String productId) {
    state.remove(productId);
    // trang thai  sau thay doi
    state = {...state};
    _saveCartItems();
  }

  // tinh toan tong gia sau thay doi
  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.productPrice;
    });
    return totalAmount;
  }

  Map<String, Cart> get getCartItems => state;

  // xoa gio hang
  void clearCart() {
    state = {};
    _saveCartItems();
  }
}
