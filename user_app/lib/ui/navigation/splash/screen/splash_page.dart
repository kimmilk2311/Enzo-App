import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_store/resource/asset/app_images.dart';
import '../../../../common/base/widgets/base_page_widget.dart';
import '../../../../resource/theme/app_colors.dart';
import '../controller/splash_controller.dart';

class SplashPage extends BasePage<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gold50,
      body: Stack(
        children: [
          Image.asset(
            AppImages.imgBubble,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Image.asset(
              AppImages.imgBubble,
            ),
          ),
        ],
      ),
    );
  }
}
