import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkable/controllers/profile_controller.dart';
import 'package:linkable/utils/theme/app_colors.dart';

class CustomSwitch extends StatelessWidget {
  final ProfileController controller;

  const CustomSwitch({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => {}, //controller.toggleSwitch,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: controller.isSwitched.value ? LightColors.background : Colors.grey.shade400,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              bottom: 5,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: controller.isSwitched.value ? 30 : 0,
              right: controller.isSwitched.value ? 0 : 30,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}