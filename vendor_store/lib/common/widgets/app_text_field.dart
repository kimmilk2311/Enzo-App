import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resource/asset/app_images.dart';
import '../../resource/theme/app_colors.dart';
import '../../resource/theme/app_styles.dart';


class AppTextField extends StatefulWidget {
  final String hintText;
  final String prefixImage;
  final bool isPassword;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.hintText,
    required this.prefixImage,
    this.isPassword = false,
    this.validator,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassword ? _isObscured : false,
      validator: widget.validator,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

        filled: true,
        fillColor: AppColors.white40,
        hintText: widget.hintText,
        hintStyle: AppStyles.STYLE_14.copyWith(color: AppColors.black80),


        prefixIcon: widget.prefixImage.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(widget.prefixImage, width: 20, height: 20),
        ) : null,


        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),


        suffixIcon: widget.isPassword
            ? IconButton(
          icon: SvgPicture.asset(
            _isObscured ? AppImages.icEyes : AppImages.icEyes,
            width: 20,
            height: 20,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        )
            : null,
      ),
    );
  }
}