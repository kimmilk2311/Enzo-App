import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_store/models/product.dart';
import 'package:vendor_store/services/manage_http_response.dart';
import '../global_variables.dart';

class ProductController {
  Future<void> uploadProduct({
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<File>? pickedImages,
    required context,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("auth_token");
    String? storedVendorId = sharedPreferences.getString("vendorId");

    // ✅ Lấy vendorId từ SharedPreferences nếu không có từ tham số
    if (vendorId.isEmpty && (storedVendorId == null || storedVendorId.isEmpty)) {
      showSnackBar(context, 'Không tìm thấy vendorId.');
      print("Không tìm thấy vendorId.");
      return;
    }

    final finalVendorId = vendorId.isEmpty ? storedVendorId : vendorId;

    try {
      if (pickedImages == null || pickedImages.isEmpty) {
        showSnackBar(context, 'Vui lòng chọn hình ảnh');
        return;
      }

      final cloudinary = CloudinaryPublic("dajwnmjjf", "tb9fytch");
      List<String> images = [];

      for (var i = 0; i < pickedImages.length; i++) {
        try {
          CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(pickedImages[i].path, folder: productName),
          );
          images.add(cloudinaryResponse.secureUrl);
        } catch (e) {
          showSnackBar(context, "Lỗi khi tải ảnh lên Cloudinary: $e");
          return;
        }
      }

      final Product product = Product(
        id: '',
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        description: description,
        category: category,
        vendorId: finalVendorId!,
        fullName: fullName,
        subCategory: subCategory,
        images: images,
      );

      final response = await http.post(
        Uri.parse("$uri/api/add-products"),
        body: product.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Tải sản phẩm thành công");
        },
      );
    } catch (e) {
      showSnackBar(context, "Đã xảy ra lỗi, vui lòng thử lại: $e");
    }
  }
}
