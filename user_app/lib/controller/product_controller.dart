import 'dart:convert';

import 'package:multi_store/global_variables.dart';

import '../data/model/product.dart';
import 'package:http/http.dart' as http;

class ProductController {
  Future<List<Product>> loadPopularProducts() async {
    try {
      http.Response response = await http.get(Uri.parse("$uri/api/popular-products"), headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8',
      });
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> products = data.map((product) => Product.fromMap(product as Map<String, dynamic>)).toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Không tải được các sản phẩm phổ biến");
      }
    } catch (e) {
      throw Exception("Lỗi tải sản phẩm: $e");
    }
  }

  // load product by category function
  Future<List<Product>> loadProductByCategory(String category) async {
    try {
      http.Response response =
          await http.get(Uri.parse('$uri/api/products-by-category/$category'), headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> products = data.map((product) => Product.fromMap(product as Map<String, dynamic>)).toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Không tải được các sản phẩm danh mục");
      }
    } catch (e) {
      throw Exception("Lỗi tải sản phẩm: $e");
    }
  }

  // display related products by subcategory
  Future<List<Product>> loadRelatedProductsBySubcategory(String productId) async {
    try {
      final response =
          await http.get(Uri.parse('$uri/api/related-products-by-subcategory/$productId'), headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> relatedProducts =
            data.map((product) => Product.fromMap(product as Map<String, dynamic>)).toList();
        return relatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Không tải được các sản phẩm liên quan");
      }
    } catch (e) {
      throw Exception("Lỗi tải sản phẩm: $e");
    }
  }

  // display top rate products function
  Future<List<Product>> loadTopRatedProducts(String productId) async {
    try {
      final response = await http.get(Uri.parse('$uri/api/top-rated-products'), headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> topRatedProducts =
            data.map((product) => Product.fromMap(product as Map<String, dynamic>)).toList();
        return topRatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Không tải được top sản phẩm");
      }
    } catch (e) {
      throw Exception("Lỗi tải sản phẩm: $e");
    }
  }
}
