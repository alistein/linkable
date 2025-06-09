import 'package:linkable/controllers/home_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    // Get.lazyPut<ConnectivityController>(() => ConnectivityController());
    // Get.lazyPut<HBSController>(() => HBSController(), tag: 'HBS');
    // Get.lazyPut<HBSPlusController>(() => HBSPlusController(), tag: 'HBS+');
    // Get.lazyPut<MortgageController>(() => MortgageController(), tag: 'Mortgage');
    // Get.lazyPut<ConveyancingController>(() => ConveyancingController(), tag: 'Conveyancing');
  }
}