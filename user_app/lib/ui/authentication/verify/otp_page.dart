import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:multi_store/common/base/widgets/common/app_button.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';

import '../../../controller/auth_controller.dart';
import '../../../services/manage_http_response.dart';

class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final AuthController _authController = AuthController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> otpDigits = List.filled(6, '');
  bool isLoading= false;
  void verifyOtp() async{
    if(otpDigits.contains('')){
      showSnackBar(context, "Vui lòng nhập đầy đủ mã OTP");
      return;
    }
    setState(() {
      isLoading = true;
    });

    final otp = otpDigits.join();

    await _authController.verifyOtp(context: context, email: widget.email, otp: otp).then((value){
     setState(() {
       isLoading = false;
     });
    });

  }
  Widget buildOtpField(int index) {
    return SizedBox(
      width: 50,
      height: 60,
      child: TextFormField(
        validator: (value){
          if(value!.isEmpty){
            return "Vui lòng nhập mã OTP";
          }
          return null;
        },
        onChanged: (value) {
          if (value.isNotEmpty && value.length == 1) {
            otpDigits[index] = value;
            if (index < 5) {
              FocusScope.of(context).nextFocus();
            }
          } else {
            otpDigits[index] = '';
            if (index > 0) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
        onFieldSubmitted: (value) {
          if(index == 5 && _formKey.currentState!.validate()){
            verifyOtp();
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.white40,
        ),
        style: AppStyles.STYLE_18_BOLD.copyWith(color: AppColors.blackFont),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Xác thực tài khoản",
                    style: AppStyles.STYLE_22_BOLD.copyWith(color: AppColors.bluePrimary),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Nhập mã OTP được gửi đến:",
                    style: AppStyles.STYLE_16.copyWith(color: AppColors.greyDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.email,
                    style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.bluePrimary),
                  ),
                  const SizedBox(height: 30),

                  // Dãy OTP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, buildOtpField),
                  ),
                  const SizedBox(height: 32),

                  // Nút xác thực
                  AppButton(
                    text: "Xác thực",
                    onPressed: () {
                      verifyOtp();
                    },
                    color: AppColors.bluePrimary,
                    textColor: AppColors.white,
                  ),
                  const SizedBox(height: 12),

                  // Gửi lại OTP
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Gửi lại OTP",
                      style: AppStyles.STYLE_16.copyWith(
                        color: AppColors.blackFont,
                        decoration: TextDecoration.underline,
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
