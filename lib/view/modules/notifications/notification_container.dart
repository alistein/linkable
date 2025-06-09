import 'package:linkable/controllers/notification_controller.dart';
import 'package:linkable/models/notification_model.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class NotificationContainer extends StatelessWidget {
  final NotificationModel notification;

  const NotificationContainer({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: notification.isSeen
                ? (Colors.grey[300] ?? Colors.grey)
                : LightColors.primary,
            width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        tileColor: Colors.grey[100],
        // leading: notification.isSeen
        //     ? Icon(
        //         Icons.circle,
        //         color: Colors.grey,
        //         size: 10,
        //       )
        //     : Icon(
        //         Icons.circle,
        //         color: Colors.red,
        //         size: 10,
        //       ),
        title: Text(notification.title),
        subtitle: Text(
            DateFormat('dd/MM/yyyy HH:mm').format(notification.createdAt!)),
        trailing: notification.isSeen
            ? null
            : IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: LightColors.primary,
                  size: 23,
                ),
                onPressed: () {
                  if (!notification.isSeen) {
                    controller.markAsSeen(notification.id);
                  }
                },
              ),
      ),
    );
  }
}