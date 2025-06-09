import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkable/bindings/app_bindings.dart';
import 'package:linkable/initializer.dart';
import 'package:linkable/services/connectivity_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:linkable/firebase_options.dart';
import 'package:linkable/routes/app_pages.dart';
import 'package:linkable/services/auth_services.dart';
import 'package:linkable/utils/theme/app_theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );

  Get.put(ConnectivityService(), permanent: true);

  await Get.putAsync(() => AuthServices().init());

  //HttpOverrides.global = MyHttpOverrides();

  //await GetStorage.init('User');

  runApp(const OneDome());
}

class OneDome extends StatelessWidget {
  const OneDome({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OneDome',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      initialBinding: AppBindings(),
      //locale: const Locale('en'),
      //translations: Lang()
      home: const InitializerWidget(),
      getPages: AppPages.pages,
      // navigatorObservers: [ConnectivityNavigatorObserver()],
    );
  }
}
