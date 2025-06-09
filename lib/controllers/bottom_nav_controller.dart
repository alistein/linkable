import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkable/utils/theme/app_colors.dart';


class BottomNavController extends GetxController {
  RxInt currentScreen = RxInt(1);

  final pageController = PageController();

  void changeTab(int index) {
    currentScreen(index);
    pageController.animateToPage(index - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

  void onFabPressed(BuildContext context) {
    // You can define any action for the + button

    // showModalBottomSheet(
    //     useSafeArea: true,
    //     showDragHandle: true,
    //     isScrollControlled: true,
    //     backgroundColor: LightColors.secondaryColor,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return GetBuilder<ReferralFormController>(
    //           init: ReferralFormController(),
    //           dispose: (_) => Get.delete<ReferralFormController>(),
    //           builder: (context) {
    //             return FormBottomSheet();
    //           });
    //     });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
