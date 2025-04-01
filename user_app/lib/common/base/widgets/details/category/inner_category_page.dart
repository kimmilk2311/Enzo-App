import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_store/common/base/widgets/common/app_navigation_bar.dart';
import 'package:multi_store/common/base/widgets/details/category/inner_category_content_widget.dart';
import 'package:multi_store/data/model/subcategory_model.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/ui/navigation/screens/cart_page.dart';
import 'package:multi_store/ui/navigation/screens/category_page.dart';
import 'package:multi_store/ui/navigation/screens/favorite_page.dart';


import '../../../../../controller/subcategory_controller.dart';
import '../../../../../data/model/category_model.dart';
import '../../../../../ui/navigation/screens/setting_page.dart';
import '../../../../../ui/navigation/screens/store_page.dart';

class InnerCategoryPage extends StatefulWidget {
  final Category category;

  const InnerCategoryPage({super.key, required this.category});

  @override
  State<InnerCategoryPage> createState() => _InnerCategoryPageState();
}

class _InnerCategoryPageState extends State<InnerCategoryPage> {
  late Future<List<SubCategory>> _subcategories;
  final SubcategoryController _subcategoryController = SubcategoryController();

  int pageIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _subcategories = _subcategoryController.getSubCategoriesByCategoryName(widget.category.name);
    pages = [
      InnerCategoryContentWidget(category: widget.category),
      const CartPage(),
      const CategoryPage(),
      const StorePage(),
      const FavoritePage(),
       SettingPage(),
    ];
  }

  void changePage(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white40,
      body: pages[pageIndex],
      bottomNavigationBar: AppNavigationBar(
        selectedIndex: pageIndex,
        onTabSelected: (index) {
          changePage(index);
        },
      ),
    );
  }
}
