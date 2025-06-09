import 'package:linkable/controllers/notification_controller.dart';
import 'package:linkable/utils/app_decorations.dart';
import 'package:linkable/view/modules/notifications/notification_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  final controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDecorations.appBarDecorationBuilder(
          appBarText: "Notifications",
          iconButtons: [
            IconButton(
                onPressed: controller.markAllAsSeen,
                icon: Icon(Icons.mark_chat_read))
          ]),
      body: Obx(
        () => controller.notifications.isEmpty
            ? const Center(child: Text('No notifications'))
            : ListView.builder(
                itemCount: controller.notifications.length,
                itemBuilder: (context, index) {
                  final notification = controller.notifications[index];
                  return NotificationContainer(notification: notification);
                },
              ),
      ),
    );
  }
}
