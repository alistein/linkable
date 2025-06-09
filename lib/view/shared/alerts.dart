import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackbar({required String text, IconData? icon}) {
  Get.snackbar(
    '',
    '',
    titleText: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    messageText: const Text(
      '',
      style: TextStyle(fontSize: 1),
    ),
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
    duration: const Duration(seconds: 2),
    forwardAnimationCurve: Curves.easeOutBack,
    dismissDirection: DismissDirection.up,
    icon: icon == null ? null : Icon(icon, size: 24),
    shouldIconPulse: false,
    barBlur: 3,
    onTap: (snack) => Get.closeCurrentSnackbar(),
  );
}

showSuccessSnack({String? message, required String title}) {
  Get.snackbar(title, message ?? '',
      icon: const Icon(
        Icons.done,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 3000),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      titleText: Text(title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10));
}

showErrorSnack({required String title, String? message, int? seconds}) {
  Get.snackbar(title, message ?? "",
      icon: const Icon(
        Icons.error,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: seconds ?? 10),
      backgroundColor: Colors.red,
      colorText: Colors.white,
      titleText: Text(title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10));
}

showInfoSnack({required String title, required String message}) {
  Get.snackbar('', message,
      icon: const Icon(
        Icons.error,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 10),
      backgroundColor: const Color.fromARGB(255, 208, 154, 6),
      colorText: Colors.white,
      titleText: Text(title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10));
}