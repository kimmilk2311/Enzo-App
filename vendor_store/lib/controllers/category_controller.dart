import 'dart:convert';


import 'package:http/http.dart' as http;

import '../global_variables.dart';
import '../models/category.dart';

class CategoryController {

  // load the uploaded category
  Future<List<Category>> loadCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<Category> categories = data.map((category) =>
            Category.fromJson(category as Map<String, dynamic>)).toList();

        return categories;
      } else {
        throw Exception('Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
        throw Exception("Error loading categories: ${e.toString()}");
    }
  }

}
