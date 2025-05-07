import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_store/resource/asset/app_images.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.white40, AppColors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: widget.isPassword ? _isObscured : false,
        validator: widget.validator,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          filled: true,
          fillColor: Colors.transparent, // Để gradient từ Container hiển thị
          hintText: widget.hintText,
          hintStyle: AppStyles.STYLE_14.copyWith(
            color: AppColors.black80,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: widget.prefixImage.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              widget.prefixImage,
              width: 24, // Tăng kích thước icon nhẹ
              height: 24,
              color: AppColors.black80, // Đảm bảo icon rõ ràng
            ),
          )
              : null,
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
            borderSide: const BorderSide(
              color: AppColors.bluePrimary, // Màu viền nổi bật khi focus
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: AppColors.pink, // Màu viền khi có lỗi
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: AppColors.pink,
              width: 2,
            ),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: SvgPicture.asset(
              _isObscured ? AppImages.icEyes : AppImages.icEyes,
              width: 24, // Tăng kích thước icon nhẹ
              height: 24,
              color: AppColors.blackFont, // Màu icon nhẹ hơn
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}