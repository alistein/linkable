import 'package:linkable/view/modules/main/main_page.dart';
import 'package:linkable/view/modules/main/no_internet_page.dart';
import 'package:linkable/view/modules/notifications/notification_page.dart';
import 'package:get/get.dart';
import 'package:linkable/routes/app_routes.dart';
import 'package:linkable/view/modules/login/forgot_password_page.dart';
import 'package:linkable/view/modules/login/login_page.dart';
import 'package:linkable/view/modules/login/password_change_page.dart';
import 'package:linkable/view/modules/login/register_page.dart';
import 'package:linkable/view/modules/login/welcome_page.dart';
import 'package:linkable/view/modules/profile/profile_page.dart';

class AppPages {
  static List<GetPage> pages = [
    // GetPage(
    //     name: AppRoutes.main,
    //     page: () => const MainPage(),
    //     binding: MainBindings()),
    GetPage(name: AppRoutes.welcome, page: () => const WelcomePage()),
    GetPage(name: AppRoutes.mainPage, page: () => MainPage()),
    GetPage(name: AppRoutes.login, page: () =>    LoginPage()),
    GetPage(name: AppRoutes.register, page: () => RegisterPage()),
    GetPage(name: AppRoutes.account, page: () => ProfilePage()),
    GetPage(name: AppRoutes.forgotPass, page: () => ForgetPasswordPage()),
    GetPage(name: AppRoutes.changePass, page: () => PasswordChangePage()),
    GetPage(name: AppRoutes.notification, page: () => NotificationPage()),
    GetPage(name: AppRoutes.noInternet, page: () => NoInternetPage()),
  ];
}
