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
      unselectedItemColor: AppColors.bluePrimary,
      selectedItemColor: AppColors.blackFont,
      type: BottomNavigationBarType.shifting,
      items: const [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.money_dollar), label: ""),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.upload_circle), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.edit), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
    );

  }
}
