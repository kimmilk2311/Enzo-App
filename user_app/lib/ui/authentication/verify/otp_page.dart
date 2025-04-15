import 'package:flutter/material.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';

class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Xác thực tài khoản",
                style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.blackFont),
              ),
              const SizedBox(height: 15),
              Text("Nhap OTP de xac thuc tai khoan,${widget.email}",style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.blackFont),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
