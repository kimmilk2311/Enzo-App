import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resource/asset/app_images.dart';
import '../../resource/theme/app_colors.dart';
import '../../resource/theme/app_styles.dart';


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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                SvgPicture.asset(AppImages.icArrowRight),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
