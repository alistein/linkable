import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkable/models/notification_model.dart';
import 'package:linkable/services/auth_services.dart';
import 'package:linkable/view/shared/alerts.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final AuthServices _authServices = Get.find<AuthServices>();

  @override
  void onInit() {
    super.onInit();

    setupFirestoreListener();
  }

  bool isAllSeen() => notifications
      .where((notification) => notification.isSeen == false)
      .isEmpty;

  void setupFirestoreListener() {
    _firestore
        .collection('notifications')
        .where("userId", isEqualTo: _authServices.user.value?.uid)
        .snapshots()
        .listen(
      (QuerySnapshot snapshot) {
        try {
          // Process data asynchronously to avoid blocking the UI
          final updatedNotifications = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return NotificationModel.fromFirestore(data, doc.id);
          }).toList();

          notifications.value = updatedNotifications;
          debugPrint('Notifications updated: ${notifications.length} items');
        } catch (e) {
          debugPrint('Error processing Firestore snapshot: $e');
        }
      },
      onError: (error) {
        debugPrint('Firestore listener error: $error');
      },
      cancelOnError: false, // Prevents listener from stopping on error
    );
  }

  Future<void> markAsSeen(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'isSeen': true});
    } catch (e) {
      showErrorSnack(
          title: 'Error', message: 'Failed to mark notification as seen');
    }
  }

  Future<void> markAllAsSeen() async {
    try {
      final batch = _firestore.batch();
      for (var notification in notifications.where((n) => !n.isSeen)) {
        final docRef =
            _firestore.collection('notifications').doc(notification.id);
        batch.update(docRef, {'isSeen': true});
      }
      await batch.commit();
    } catch (e) {
      showErrorSnack(
          title: 'Error', message: 'Failed to mark all notifications as seen');
    }
  }
}
