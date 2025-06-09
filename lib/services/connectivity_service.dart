import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:linkable/routes/app_routes.dart';
import 'package:linkable/view/shared/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  var isConnected = true.obs;
  var isUserInit = true.obs;
  bool _isInitialSetup = true;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      bool newStatus = !result.contains(ConnectivityResult.none);
      if (newStatus != isConnected.value) {
        isConnected.value = newStatus;
        // Only navigate on actual connectivity changes, not during initial setup
        if (!_isInitialSetup) {
          _handleNavigationOnConnectivityChange();
        }
      }
    });
  }

  Future<void> _checkInitialConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    isConnected.value = !connectivityResult.contains(ConnectivityResult.none);

    if (!isConnected.value) {
      FlutterNativeSplash.remove();
    }

    // Mark initial setup as complete
    _isInitialSetup = false;
  }

  void _handleNavigationOnConnectivityChange() {
    print('Connectivity changed - Is Connected: ${isConnected.value}');
    
    if (!isConnected.value) {
      // Clear navigation stack and redirect to NoInternetPage
      Get.offAllNamed(AppRoutes.noInternet);
      print("Redirecting to no internet page...");
    } else {
      // If connection is restored, redirect to appropriate page
      // Check current route to avoid unnecessary navigation
      if (Get.currentRoute == AppRoutes.noInternet) {
        if (isUserInit.value) {
          Get.offAllNamed(AppRoutes.mainPage);
        } else {
          Get.offAllNamed(AppRoutes.login);
        }
        print("Connection restored - redirecting...");
      }
    }
  }

  // Utility to check connectivity before critical operations
  Future<bool> hasInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }
}
