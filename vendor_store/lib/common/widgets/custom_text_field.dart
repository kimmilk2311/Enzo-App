import 'package:flutter/material.dart';
import 'package:vendor_store/resource/theme/app_colors.dart';
import 'package:vendor_store/resource/theme/app_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final int maxLine;
  final int? maxLength;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.maxLine = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: TextFormField(
        maxLines: maxLine,
        maxLength: maxLength,
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppStyles.STYLE_14.copyWith(color: AppColors.blackFont),
          hintText: hint,
          hintStyle: AppStyles.STYLE_14.copyWith(color: AppColors.blackFont),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}