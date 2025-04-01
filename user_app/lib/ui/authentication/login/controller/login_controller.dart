import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_store/common/base/controller/base_controller.dart';
import 'package:multi_store/controller/auth_controller.dart';

class LoginController extends BaseController {
  final AuthController _authController = AuthController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String loginInput = "";
  String password = "";
  var isLoading = false.obs;
  void loginUser(BuildContext context) async {

    isLoading.value = true;

    await _authController.signInUsers(
      context: context,
      loginInput: loginInput,
      password: password,
    ).whenComplete(() {
      isLoading.value = false;
    });
  }
}