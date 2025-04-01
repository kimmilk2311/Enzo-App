import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryProvider extends StateNotifier<List<Category>>{
  CategoryProvider(): super([]);

  void setCategories(List<Category>categories){
    state = categories;
  }
}
final categoryProvider = StateNotifierProvider<CategoryProvider, List<Category>>((ref){
  return CategoryProvider();
});