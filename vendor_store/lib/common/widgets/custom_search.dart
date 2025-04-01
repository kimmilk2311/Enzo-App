import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resource/asset/app_images.dart';
import '../../resource/theme/app_colors.dart';
import '../../resource/theme/app_styles.dart';

class CustomSearch extends StatelessWidget {
  const CustomSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 4,
      top: 65,
      child: SizedBox(
        width: 250,
        height: 40,
        child: TextField(
          decoration: InputDecoration(
            hintText: "search",
            hintStyle: AppStyles.STYLE_14.copyWith(color: AppColors.greyDark),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            suffixIcon: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  AppImages.icCamera,
                  width: 10,
                  height: 10,
                ),
              ),
              onTap: (){},
            ),
            fillColor: AppColors.white40,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
