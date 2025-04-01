import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_store/resource/theme/app_colors.dart';

class CustomVendorNav extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const CustomVendorNav({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: pageIndex,
      onTap: onTap,
      unselectedItemColor: AppColors.grey,
      selectedItemColor: AppColors.bluePrimary,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.money_dollar), label: "Earning"),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.upload_circle), label: "Upload"),
        BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Edit"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Order"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );

  }
}
