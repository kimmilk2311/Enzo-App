import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../resource/asset/app_images.dart';
import '../../../../routes/app_routes.dart';
import 'custom_search.dart';

class InnerHeaderWidget extends StatelessWidget {
  const InnerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.14,
      child: Stack(
        children: [
          Image.asset(
            AppImages.imgSearchBanner,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),

          const CustomSearch(),

        ],
      ),
    );
  }
}
