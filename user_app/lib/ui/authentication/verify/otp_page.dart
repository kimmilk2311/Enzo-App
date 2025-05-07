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
  List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Tự động focus vào ô đầu tiên khi trang mở
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNodes[0]);
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void verifyOtp() async {
    if (otpDigits.contains('')) {
      showSnackBar(context, "Vui lòng nhập đầy đủ mã OTP");
      return;
    }
    setState(() {
      isLoading = true;
    });

    final otp = otpDigits.join();

    await _authController
        .verifyOtp(context: context, email: widget.email, otp: otp)
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget buildOtpField(int index) {
    return Container(
      width: 48, // Giảm từ 56 xuống 48
      height: 56, // Giảm từ 64 xuống 56
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          colors: [AppColors.white40, AppColors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        validator: (value) {
          if (value!.isEmpty) {
            return " ";
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            if (value.length == 1) {
              otpDigits[index] = value;
              if (index < 5) {
                FocusScope.of(context).requestFocus(focusNodes[index + 1]);
              } else {
                FocusScope.of(context).unfocus(); // Ẩn bàn phím khi nhập ô cuối
                if (_formKey.currentState!.validate()) {
                  verifyOtp();
                }
              }
            } else if (value.isEmpty) {
              otpDigits[index] = '';
              if (index > 0) {
                FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                controllers[index - 1].selection = TextSelection.fromPosition(
                  TextPosition(offset: controllers[index - 1].text.length),
                );
              }
            }
          });
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.bluePrimary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.pink,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.pink,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
        style: AppStyles.STYLE_18_BOLD.copyWith(color: AppColors.blackFont),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.white, AppColors.white40],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Xác thực tài khoản",
                      style: AppStyles.STYLE_22_BOLD.copyWith(
                        color: AppColors.bluePrimary,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Nhập mã OTP được gửi đến:",
                      style: AppStyles.STYLE_16.copyWith(color: AppColors.greyDark),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.email,
                      style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.bluePrimary),
                    ),
                    const SizedBox(height: 40),

                    // Dãy OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, buildOtpField),
                    ),
                    const SizedBox(height: 40),

                    // Nút xác thực
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.bluePrimary, AppColors.blue600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.bluePrimary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AppButton(
                        text: "Xác thực",
                        onPressed: () {
                          verifyOtp();
                        },
                        color: Colors.transparent,
                        textColor: AppColors.white,
                        isLoading: isLoading,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Gửi lại OTP
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Gửi lại OTP",
                        style: AppStyles.STYLE_16.copyWith(
                          color: AppColors.blackFont,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.blackFont,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}