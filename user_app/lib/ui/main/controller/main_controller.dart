import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_store/ui/navigation/screens/cart_page.dart';
import 'package:multi_store/ui/navigation/screens/category_page.dart';
import 'package:multi_store/ui/navigation/screens/favorite_page.dart';
import 'package:multi_store/ui/navigation/screens/home_page.dart';
import '../../../common/base/controller/base_controller.dart';
import '../../navigation/screens/setting_page.dart';
import '../../navigation/screens/store_page.dart';

class MainController extends BaseController {
  static MainController get to => Get.find<MainController>();

 var pageIndex = 0.obs;

  final List<Widget> pages = [
    const HomePage(),
    const FavoritePage(),
    const CategoryPage(),
    const StorePage(),
    const CartPage(),
     SettingPage(),
  ];

  void changePage(int index) {
    pageIndex.value = index;
    update();
  }
}




