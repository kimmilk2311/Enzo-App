import 'dart:convert';

import 'package:http/http.dart' as http;

import '../global_variables.dart';
import '../models/subcategory.dart';



class SubcategoryController {
  // load the uploaded category
  Future<List<SubCategory>> getSubCategoriesByCategoryName(String categoryName) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/category/$categoryName/subcategories'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );
      print("Phản hồi API: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          return data
              .map((subcategory) => SubCategory.fromJson(subcategory))
              .toList();
        } else {
          print("Không tìm thấy danh mục phụ");
          return [];
        }
      }else if (response.statusCode == 404){
        print("không tìm thấy các danh mục phụ");
        return [];
      }else{
        print('không thể lấy được các danh mục phụ');
        return [];
      }
    }catch(e){
      print("lỗi tìm nạp danh mục $e");
      return [];
    }
  }
}

