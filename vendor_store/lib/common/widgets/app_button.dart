
import 'package:flutter/material.dart';
import 'package:vendor_store/resource/theme/app_colors.dart';

import '../../resource/theme/app_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double borderRadius;
  final double height;
  final double width;
  final bool isLoading;
  final double fontSize;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.borderRadius = 20.0,
    this.height = 61.0,
    this.width = double.infinity,
    this.isLoading = false,
    this.fontSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 2,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        )
            : Text(
          text,
          style: AppStyles.STYLE_20.copyWith(fontSize: fontSize,color: AppColors.white),
        ),
      ),
    );
  }
}
