import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:linkable/routes/app_routes.dart';
import 'package:linkable/utils/app_assets.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:linkable/view/shared/empty_boxes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: LightColors.background,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      AppAssets.intropic1,
                      width: width * 0.6,
                      height: height * 0.25,
                      fit: BoxFit.contain,
                    ),
                  ),
                  boxHeigth24,
                  SizedBox(
                    width: width * .80,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(AppRoutes.login),
                      child: Text("Login"),
                    ),
                  ),
                  boxHeigth14,
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.register),
                    child: Text(
                      "Create an account",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
