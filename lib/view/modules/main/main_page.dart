import 'package:linkable/controllers/notification_controller.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkable/controllers/bottom_nav_controller.dart';
import 'package:linkable/view/modules/home/home_page.dart';
import 'package:linkable/view/modules/links/links_page.dart';
import 'package:linkable/view/modules/profile/profile_page.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final BottomNavController bottomNavController = Get.isRegistered<BottomNavController>() 
      ? Get.find<BottomNavController>() 
      : Get.put(BottomNavController());
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.background,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: bottomNavController.pageController,
              children: [
                HomePage(),
                LinksPage(),
                ProfilePage(),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 34,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: LightColors.navBackground,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home_outlined, Icons.home, 1),
                  _buildNavItem(Icons.notes_outlined, Icons.notes, 2),
                  _buildNavItem(Icons.person_outline, Icons.person, 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData outlineIcon, IconData filledIcon, int index) {
    return Obx(() {
      final isSelected = bottomNavController.currentScreen.value == index;
      return GestureDetector(
        onTap: () => bottomNavController.changeTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 15),
          decoration: BoxDecoration(
            color: isSelected 
                ? LightColors.navSelectedBg
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            isSelected ? filledIcon : outlineIcon,
            color: isSelected ? LightColors.navSelected : LightColors.navUnselected,
            size: 22,
          ),
        ),
      );
    });
  }
}
