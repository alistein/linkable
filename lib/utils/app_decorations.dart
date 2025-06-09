import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkable/utils/app_assets.dart';
import 'package:linkable/utils/app_constants.dart';
import 'package:linkable/utils/theme/app_colors.dart';

class AppBorderRadius {
  static BorderRadius card = BorderRadius.circular(10);
  static BorderRadius button = BorderRadius.circular(14);
  static BorderRadius input = BorderRadius.circular(14);
  static BorderRadius stadium = BorderRadius.circular(32);
  static BorderRadius bottomSheet =
      const BorderRadius.vertical(top: Radius.circular(24));
}

class AppShadows {
  static BoxShadow card = BoxShadow(
      offset: const Offset(0, 1), color: Colors.grey.shade600, blurRadius: 4);
}

class AppDecorations {
  static final bottomSheetDec =
      BoxDecoration(color: Get.theme.scaffoldBackgroundColor);

  static final cardDecoration = BoxDecoration(
      color: Get.theme.scaffoldBackgroundColor,
      borderRadius: AppBorderRadius.card,
      border: Border.all(color: Get.theme.splashColor));
}

class AppBarDecorations {
  static final appBarDecoration = AppBar(
    title: Center(
      child: SizedBox(
        width: 200, // Adjust the width as needed
        height: 200, // Adjust the height as needed
        child: Image.asset(AppAssets.logo),
      ),
    ),
  );

  static final appBarDecorationWelcome = AppBar(
    centerTitle: true,
    backgroundColor:
        LightColors.background, // Ensures the title is centered
    title: const Text(
      "Login",
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
      textAlign: TextAlign.center,
    ),
  );

  static AppBar appBarDecorationBuilder(
      {
        required String appBarText,
      AppBarBackgroundColors colorType = AppBarBackgroundColors.mainVersion,
    List<dynamic>? iconButtons,
    IconButton? leadingIconButton,
      double? fontSize = 30
        }) {
    return AppBar(
      centerTitle: true,
      leading: leadingIconButton,
      scrolledUnderElevation: 0,
      actions: //colorType == AppBarBackgroundColors.registrationVersion ? null : 
      [
        // IconButton(
        //   icon: const Icon(Icons.notifications, color: Colors.black),
        //   onPressed: () {},
        // ),
        ...?iconButtons
      ],
      backgroundColor: LightColors.background, // Ensures the title is centered
      title: Text(
        appBarText,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w800),
        textAlign: TextAlign.center,
      ),
    );
  }
}
