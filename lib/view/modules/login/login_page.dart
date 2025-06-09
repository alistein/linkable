import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:linkable/controllers/login_controller.dart';
import 'package:linkable/routes/app_routes.dart';
import 'package:linkable/utils/app_assets.dart';
import 'package:linkable/utils/app_constants.dart';
import 'package:linkable/utils/app_decorations.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:linkable/view/shared/custom_text_field.dart';
import 'package:linkable/view/shared/empty_boxes.dart';
import 'package:linkable/view/shared/passport_field.dart';
import 'package:linkable/view/shared/text_field_label.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {

    final loginFormKey = GlobalKey<FormState>();

    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    
    return Scaffold(
        backgroundColor: LightColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 35),
          child: Form(
              key: loginFormKey,
              child: Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  boxHeigth64,
                  Center(
                    child: Image.asset(
                      AppAssets.intropic1,
                      width: width * 0.6,
                      height: height * 0.25,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const TextFieldLabel(label: "Email"),
                  CustomTextField(
                      hintText: "abc12@gmail.com",
                      controller: controller.emailController,
                      validator: (value) => controller.validateEmail(value)),
                  const TextFieldLabel(label: "Enter your password"),
                  Obx(() => PasswordField(
                        isVisible: controller.isPasswordVisible.value,
                        toggleVisibility: controller.togglePasswordVisibility,
                        validator: (value) =>
                            controller.validatePassword(value),
                        controller: controller.passwordController,
                      )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.forgotPass),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              fontSize: 15,
                              color: LightColors.secondaryText,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                  Obx(() => SizedBox(
                        child: ElevatedButton(
                          onPressed: controller.isLoading.isTrue
                              ? null
                              : () => controller.submitForm(loginFormKey),
                          child: controller.isLoading.isTrue
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text("Login"),
                        ),
                      )),
                  boxHeigth16,
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            color: LightColors.secondaryText, fontSize: 14),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: "Sign Up",
                            style: const TextStyle(
                                color: LightColors.primary,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.toNamed(AppRoutes.register),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
