import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_store/resource/asset/app_images.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';

class ReusableTextWidget extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onPressed;

  const ReusableTextWidget({
    super.key,
    required this.title,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.blackFont),
          ),
          GestureDetector(
            onTap: onPressed,
            child: Row(
              children: [
                Text(
                  actionText,
                  style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.bluePrimary),
                ),
                const SizedBox(width: 7),
                SvgPicture.asset(AppImages.icArrowRight,width: 20,height: 20,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
