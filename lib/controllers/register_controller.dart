import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkable/models/phone_model.dart';
import 'package:linkable/models/register_model.dart';
import 'package:linkable/services/auth_services.dart';
import 'dart:async';

class RegisterController extends GetxController {
  final registerFormKey = GlobalKey<FormState>();

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  var selectedCountryCode = "994".obs;
  var phoneNumber = "".obs;
  var selectedCountry = "AZ".obs;

  var isLoading = false.obs;

  final AuthServices _authService = Get.put(AuthServices());

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final referralController = TextEditingController();

  void updatePhoneNumber(String number) {
    phoneNumber.value = number;
  }

  void changeCountryCode(String newCode) {
    selectedCountryCode.value = newCode;
  }

  void changeCountry(String country){
    selectedCountry.value = country;
  }

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

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> submitForm() async {
    bool isValid = registerFormKey.currentState?.validate() ?? false;

    if (isValid) {
      isLoading.value = true;

      RegisterModel registrationData = RegisterModel(
        email: emailController.text,
        name: nameController.text,
        password: passwordController.text,
        phoneNumber: PhoneModel(
            prefix: selectedCountryCode.value,
            number: phoneNumber.value,
            country: selectedCountry.value,
            combined: "+${selectedCountryCode.value}${phoneNumber.value}"),
        surname: surnameController.text,
        referredCode: referralController.text,
        referralCode: "000000",
        points: 0,
        totalPoints: 0,
        isNotificationEnabled: false,
        isVerified: false,
      );

      await _authService.register(registrationData);

      isLoading.value = false;

      // Get.snackbar("Success", "Registration completed!",
      //     snackPosition: SnackPosition.TOP,
      //     backgroundColor: Colors.green,
      //     colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    referralController.dispose();
    super.onClose();
  }
}
