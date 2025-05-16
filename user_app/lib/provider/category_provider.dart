import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/controller/category_controller.dart';
import 'package:multi_store/data/model/category_model.dart';
import 'package:multi_store/data/model/subcategory_model.dart';

class CategoryProvider extends StateNotifier<CategoryState> {
  CategoryProvider() : super(CategoryState()) {
    _loadCategories();
  }

  Future<void> _loadCategories({bool forceRefresh = false}) async {
    // Kiểm tra nếu không cần tải lại và đã có danh mục
    if (!forceRefresh && state.categories.isNotEmpty) {
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);
      final controller = CategoryController();
      final categories = await controller.loadCategories();
      state = state.copyWith(categories: categories, isLoading: false, error: null);

      if (categories.isNotEmpty) {
        state = state.copyWith(selectedCategory: categories[0]);
        await _loadSubCategories(categories[0].name);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Không thể tải danh mục: $e',
      );
    }
  }

  Future<void> _loadSubCategories(String categoryName, {bool forceRefresh = false}) async {
    if (state.subcategories.isNotEmpty &&
        !forceRefresh &&
        state.selectedCategory?.name == categoryName) {
      return;
    }

    try {
      state = state.copyWith(isLoadingSubcategories: true, subError: null);
      final controller = CategoryController();
      await controller.loadSubCategories(categoryName);
      state = state.copyWith(
        subcategories: controller.subcategories,
        isLoadingSubcategories: false,
        subError: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingSubcategories: false,
        subError: 'Không thể tải danh mục con: $e',
      );
    }
  }

  Future<void> refreshCategories() async {
    await _loadCategories(forceRefresh: true);
  }

  Future<void> refreshSubCategories(String categoryName) async {
    await _loadSubCategories(categoryName, forceRefresh: true);
  }

  void setCategories(List<Category> categories) {
    state = state.copyWith(categories: categories, isLoading: false, error: null);
  }

  void selectCategory(Category category) async {
    state = state.copyWith(selectedCategory: category);
    await _loadSubCategories(category.name, forceRefresh: true);
  }
}

class CategoryState {
  final List<Category> categories;
  final List<SubCategory> subcategories;
  final bool isLoading;
  final bool isLoadingSubcategories;
  final String? error;
  final String? subError;
  final Category? selectedCategory;

  CategoryState({
    this.categories = const [],
    this.subcategories = const [],
    this.isLoading = false,
    this.isLoadingSubcategories = false,
    this.error,
    this.subError,
    this.selectedCategory,
  });

  CategoryState copyWith({
    List<Category>? categories,
    List<SubCategory>? subcategories,
    bool? isLoading,
    bool? isLoadingSubcategories,
    String? error,
    String? subError,
    Category? selectedCategory,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      subcategories: subcategories ?? this.subcategories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingSubcategories: isLoadingSubcategories ?? this.isLoadingSubcategories,
      error: error ?? this.error,
      subError: subError ?? this.subError,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

final categoryProvider = StateNotifierProvider<CategoryProvider, CategoryState>((ref) {
  return CategoryProvider();
});
