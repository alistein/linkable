import 'package:linkable/controllers/notification_controller.dart';
import 'package:linkable/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationIcon extends StatelessWidget {
  NotificationIcon({super.key});

  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
        onPressed: () => {Get.toNamed(AppRoutes.notification)},
        icon: notificationController.isAllSeen()
            ? Icon(Icons.notifications)
            : Icon(
                Icons.notifications_on,
                color: Colors.red,
              )));
  }
}
