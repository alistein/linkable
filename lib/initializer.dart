import 'package:linkable/services/auth_services.dart';
import 'package:linkable/services/connectivity_service.dart';
import 'package:linkable/view/modules/main/main_page.dart';
import 'package:linkable/view/modules/login/welcome_page.dart';
import 'package:linkable/view/modules/main/no_internet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

// IMPORTANT: Replace HomePage with your actual widget for logged-in users.
// Make sure you have a HomePage widget defined and imported.

class InitializerWidget extends StatelessWidget {
  const InitializerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthServices authService = Get.find<AuthServices>();
    final ConnectivityService connectivityService =
        Get.find<ConnectivityService>();

    if (authService.user.value == null) {
      FlutterNativeSplash.remove();
    }

    return Obx(() {
      if (!authService.isAuthReady.value) {
        // While auth or connectivity is not ready, native splash is shown.
        // This widget is built "behind" the splash.
        return const Scaffold(
            body: Center(child: SizedBox.shrink())); // Minimal UI
      }

      if (!connectivityService.isConnected.value) {
        return NoInternetPage();
      }

      // Auth and connectivity are ready, splash has been removed. Decide page.
      if (authService.user.value != null) {
        // User is logged in - return MainPage which contains the navigation structure
        return MainPage();
      } else {
        // User is not logged in
        return const WelcomePage(); // Your existing WelcomePage widget
      }
    });
  }
}
