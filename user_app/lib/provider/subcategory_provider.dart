import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/data/model/subcategory_model.dart';

class SubcategoryProvider extends StateNotifier<List<SubCategory>> {
  SubcategoryProvider() : super([]);

  void setSubcategories(List<SubCategory> subcategories) {
    state = subcategories;
  }
}

final subcategoryProvider = StateNotifierProvider<SubcategoryProvider, List<SubCategory>>(
  (ref) {
    return SubcategoryProvider();
  },
);
