import 'dart:convert';

import 'package:multi_store/global_variables.dart';

import '../data/model/product.dart';
import 'package:http/http.dart' as http;

class ProductController {
  Future<List<Product>> loadAllProducts() async {
    try {
      final response = await http.get(Uri.parse("$uri/api/products")).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.map((product) {
            if (product is Map<String, dynamic>) {
              return Product.fromMap(product);
            }
            throw Exception("Dữ liệu sản phẩm không hợp lệ");
          }).toList();
        }
        throw Exception("Dữ liệu không phải danh sách");
      } else if (response.statusCode == 404) {
        return [];
      } else {
        final error = json.decode(response.body)['error'] ?? 'Không tải được sản phẩm';
        throw Exception(error);
      }
    } catch (e) {
      print("Lỗi tải sản phẩm: $e");
      throw Exception("Lỗi tải sản phẩm: $e");
    }
  }

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

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response =
      await http.get(Uri.parse('$uri/api/search-products?query=$query'), headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> searchedProducts =
        data.map((product) => Product.fromMap(product as Map<String, dynamic>)).toList();
        return searchedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Không tìm thấy sản phẩm");
      }
    } catch (e) {
      throw Exception("Lỗi tải sản phẩm: $e");
    }
  }


  Future<List<Product>> loadProductBySubCategory(String subCategory) async {
    try {
      final response = await http.get(Uri.parse('$uri/api/products-by-subcategory/$subCategory'), headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> subCategoryProducts =
        data.map((product) => Product.fromMap(product as Map<String, dynamic>)).toList();
        return subCategoryProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Không tải được danh mục con sản phẩm");
      }
    } catch (e) {
      throw Exception("Lỗi tải sản phẩm: $e");
    }
  }

  Future<List<Product>> loadVendorProducts(String vendorId) async {
    try {
      final response = await http.get(Uri.parse('$uri/api/products/vendor/$vendorId'), headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> vendorProducts =
        data.map((product) => Product.fromMap(product as Map<String, dynamic>)).toList();
        return vendorProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Không tải được sản phẩm nhà cung cấp");
      }
    } catch (e) {
      throw Exception("Lỗi tải sản phẩm: $e");
    }
  }
}