import 'package:flutter/material.dart';
import 'package:vendor_store/resource/theme/app_colors.dart';
import 'package:vendor_store/views/screens/nav_screen/earnings_page.dart';
import 'package:vendor_store/views/screens/nav_screen/edit_page.dart';
import 'package:vendor_store/views/screens/nav_screen/orders_page.dart';
import 'package:vendor_store/views/screens/nav_screen/upload_page.dart';
import 'package:vendor_store/views/screens/nav_screen/vendor_profile_page.dart';

import '../../../common/widgets/custom_vendor_nav.dart';

class MainVendorPage extends StatefulWidget {
  const MainVendorPage({super.key});

  @override
  State<MainVendorPage> createState() => _MainVendorPageState();
}

class _MainVendorPageState extends State<MainVendorPage> {
  int _pageIndex = 0;
  List<Widget> _pages = [
   const EarningsPage(),
    const UploadPage(),
    const EditPage(),
    const OrdersPage(),
    const VendorProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white40,
      body: _pages[_pageIndex],
      bottomNavigationBar: CustomVendorNav(
        pageIndex: _pageIndex,
        onTap: (value){
          setState(() {
            _pageIndex = value;
          });
        },
      ),

    );
  }
}
