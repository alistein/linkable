import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkable/services/auth_services.dart';

class LoginController extends GetxController {

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthServices _authService = Get.put(AuthServices());

  String? validateEmail(String? value) {
    if (!GetUtils.isEmail(value ?? "")) {
      return "Invalid email address";
    }
    return null;
  }


  String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> submitForm(GlobalKey<FormState> loginFormKey) async {
      
    bool isValid = loginFormKey.currentState?.validate() ?? false;

    if (isValid) {

      isLoading.value = true;

      await _authService.login(emailController.text, passwordController.text);

      isLoading.value = false;
    }
  }

  @override
  void dispose() {

    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}