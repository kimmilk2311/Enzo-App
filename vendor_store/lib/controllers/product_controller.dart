import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");
    String? storedVendorId = prefs.getString("vendorId");

    if (vendorId.isEmpty && (storedVendorId == null || storedVendorId.isEmpty)) {
      showSnackBar(context, 'Không tìm thấy vendorId.');
      print("Không tìm thấy vendorId.");
      return;
    }

    final finalVendorId = vendorId.isNotEmpty ? vendorId : storedVendorId!;

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

      final product = Product(
        id: '',
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        description: description,
        category: category,
        vendorId: finalVendorId,
        fullName: fullName,
        subCategory: subCategory,
        images: images,
        averageRating: 0.0,
        // ✅ default rating
        totalRatings: 0, // ✅ default rating count
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

  // load product by category function
  Future<List<Product>> loadVendorProduct(String vendorId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      http.Response response = await http.get(
        Uri.parse('$uri/api/products/vendor/$vendorId'),
        headers: {
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> vendorProducts = data.map((product) => Product.fromMap(product as Map<String, dynamic>)).toList();
        return vendorProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Không tải được các sản phẩm");
      }
    } catch (e) {
      throw Exception("Lỗi tải sản phẩm: $e");
    }
  }

  Future<List<String>> uploadImagesToCloudinary(List<File>? pickedImages, Product product) async {
    final cloudinary = CloudinaryPublic("dajwnmjjf", "tb9fytch");
    List<String> uploadedImages = [];

    for (var image in pickedImages!) {
     CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path, folder: product.productName),
      );
      uploadedImages.add(cloudinaryResponse.secureUrl);
    }
    return uploadedImages;
  }

  Future<void> updateProduct({
    required Product product,
    required List<File>? pickedImages,
    required BuildContext context,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (pickedImages != null) {
      await uploadImagesToCloudinary(pickedImages, product);
    }
    final updateDateData = product.toMap();

    http.Response response = await http.put(
      Uri.parse('$uri/api/edit-product/${product.id}'),
      body: jsonEncode(updateDateData),
      headers: {
        "Content-Type": 'application/json; charset=UTF-8',
        'x-auth-token': token!,
      },
    );

    manageHttpResponse(
      response: response,
      context: context,
      onSuccess: () {
        showSnackBar(context, "Cập nhật sản phẩm thành công");
      },
    );
  }
}
