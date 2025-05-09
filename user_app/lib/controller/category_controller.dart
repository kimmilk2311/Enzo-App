import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../data/model/category_model.dart';
import '../../../../../data/model/subcategory_model.dart';
import '../../../../../global_variables.dart';

class CategoryController {
  List<Category> categories = [];
  List<SubCategory> subcategories = [];
  bool isLoading = true;
  bool isLoadingSubcategories = false;
  Category? selectedCategory;

  final ValueNotifier<void> notifier = ValueNotifier<void>(null);

  // Load danh sách danh mục chính
  Future<List<Category>> loadCategories() async {
    try {
      isLoading = true;
      notifier.notifyListeners();

      http.Response response = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: {"Content-Type": 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        categories = data
            .map((category) => Category.fromJson(category as Map<String, dynamic>))
            .toList();
        return categories; // Trả về danh sách categories
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading categories: $e'); // Ném ngoại lệ để provider xử lý
    } finally {
      isLoading = false;
      notifier.notifyListeners();
    }
  }

  // Load subcategories cho 1 danh mục
  Future<void> loadSubCategories(String categoryName) async {
    try {
      isLoadingSubcategories = true;
      notifier.notifyListeners();

      final apiUrl = "$uri/api/category/$categoryName/subcategories";
      print("Fetching subcategories from: $apiUrl");

      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        subcategories = data
            .map((subcategory) => SubCategory.fromJson(subcategory as Map<String, dynamic>))
            .toList();
      } else {
        subcategories.clear();
      }
    } catch (e) {
      print("Error fetching subcategories: $e");
      subcategories.clear();
    } finally {
      isLoadingSubcategories = false;
      notifier.notifyListeners();
    }
  }

  // Xử lý khi chọn danh mục
  void selectCategory(Category category) {
    selectedCategory = category;
  }
}