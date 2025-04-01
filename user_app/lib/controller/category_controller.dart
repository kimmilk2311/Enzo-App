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
  Future<void> loadCategories() async {
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
        final hasAll = categories.any((cat) => cat.id == 'all');
        if (!hasAll) {
          categories.insert(
            0,
            Category(
              id: 'all',
              name: 'Tất cả',
              image: '',
              banner: '',
            ),
          );
        }
      } else {
        throw Exception('Failed to load categories.');
      }
    } catch (e) {
      print("Error loading categories: $e");
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

  // ✅ Load tất cả subcategories từ các danh mục (trừ "Tất cả")
  Future<void> loadAllSubCategories() async {
    try {
      isLoadingSubcategories = true;
      notifier.notifyListeners();

      List<SubCategory> allSubs = [];

      for (var cat in categories) {
        if (cat.id != 'all') {
          final apiUrl = "$uri/api/category/${cat.name}/subcategories";
          final response = await http.get(
            Uri.parse(apiUrl),
            headers: {"Content-Type": "application/json; charset=UTF-8"},
          );

          if (response.statusCode == 200) {
            final List<dynamic> data = jsonDecode(response.body);
            final subs = data
                .map((e) => SubCategory.fromJson(e as Map<String, dynamic>))
                .toList();
            allSubs.addAll(subs);
          }
        }
      }

      subcategories = allSubs;
    } catch (e) {
      print("Error fetching all subcategories: $e");
      subcategories.clear();
    } finally {
      isLoadingSubcategories = false;
      notifier.notifyListeners();
    }
  }

  // ✅ Xử lý khi chọn danh mục
  void selectCategory(Category category) {
    selectedCategory = category;
  }
}
