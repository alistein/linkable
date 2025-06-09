import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ValidationController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name cannot be empty";
    }
    return null;
  }

  String? validateSurname(String? value) {
    if (value == null || value.isEmpty) {
      return "Surname cannot be empty";
    }
    return null;
  }

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

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  String? validatePhone(value) {
    if (value.completeNumber == null) {
      return "Phone number cannot be empty";
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value.completeNumber)) {
      return "Invalid phone number format";
    }
    return null;
  }

  String? validareReferral(value) {
    if (value != null && value.isNotEmpty && value.length < 6) {
      return "Referral code must be at least 6 characters";
    }
    return null;
  }

  //Deatils Validators
  String? validateExpectedOrAgreedSalesPrice(String? value) {
    if (value == null || value.isEmpty) {
      return "Price cannot be empty";
    }
    final price = double.tryParse(value);
    if (price == null || price.isNegative || price == 0) {
      return "Invalid price";
    }
    return null;
  }

  String? validateSortCode(String? value) {
    if (value == null || value.isEmpty) {
      return "Sort code cannot be empty";
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return "Sort code must contain only digits";
    }
    return null;
  }

  String? validateAccountNo(String? value) {
    if (value == null || value.isEmpty) {
      return "Account number cannot be empty";
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return "Account Number Must Contain Only Digits";
    }
    return null;
  }

  String? validatePoints(String? value) {
    final intValue = int.tryParse(value ?? '');
    if (intValue != null && intValue > 0) {
      return "Points cannot be zero";
    }
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
}
