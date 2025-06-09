import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:linkable/routes/app_routes.dart';
import 'package:linkable/services/auth_services.dart';
import 'package:linkable/view/shared/alerts.dart';

class OtpController extends GetxController {

  var isLoading = false.obs;

  TextEditingController forgetPasswordEmailController = TextEditingController();

  final AuthServices _authService = Get.find();

  Future<void> sendToTheEmail() async {
    isLoading.value = true;

    var result = await _authService
        .sendForgetPasswordCode(forgetPasswordEmailController.text);

    result.fold((success) {
      showSuccessSnack(
          title: "Your reset link has been sent!", message: success.data);
      Get.offAllNamed(AppRoutes.login);
    }, (failure) => showErrorSnack(title: "Problem", message: failure.message));

    isLoading.value = false;
  }

  Future<void> clearLoginCache() async {
    await _authService.logout();
  }

  @override
  void onInit() {

    super.onInit();
  }

  @override
  void onClose() {
    
    super.onClose();
  }


  @override
  void dispose() {
    
    forgetPasswordEmailController.dispose();
    super.dispose();
  }

  
}
