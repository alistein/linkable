import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkable/controllers/register_controller.dart';
import 'package:linkable/utils/app_constants.dart';
import 'package:linkable/utils/app_decorations.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:linkable/view/shared/custom_text_field.dart';
import 'package:linkable/view/shared/empty_boxes.dart';
import 'package:linkable/view/shared/passport_field.dart';
import 'package:linkable/view/shared/phone_field.dart';
import 'package:linkable/view/shared/text_field_label.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDecorations.appBarDecorationBuilder(
          appBarText: "Register",
          colorType: AppBarBackgroundColors.registrationVersion),
      backgroundColor: LightColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 35),
        child: Form(
            key: controller.registerFormKey,
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextFieldLabel(label: "Name"),
                CustomTextField(
                    hintText: "John",
                    controller: controller.nameController,
                    validator: (value) => controller.validateName(value)),
                const TextFieldLabel(label: "Surname"),
                CustomTextField(
                  hintText: "Smith",
                  controller: controller.surnameController,
                  validator: (value) => controller.validateSurname(value),
                ),
                const TextFieldLabel(label: "Phone number"),
                Row(
                  children: [
                    Expanded(
                        child: PhoneField(
                            controller: controller,
                            hintText: "1712345678",
                            validator: (value) =>
                                controller.validatePhone(value))),
                  ],
                ),
                const TextFieldLabel(
                  label: "Email",
                  topMargin: 0,
                ),
                CustomTextField(
                    hintText: "abc12@gmail.com",
                    controller: controller.emailController,
                    validator: (value) => controller.validateEmail(value)),
                const TextFieldLabel(label: "Password"),
                Obx(() => PasswordField(
                      isVisible: controller.isPasswordVisible.value,
                      toggleVisibility: controller.togglePasswordVisibility,
                      validator: (value) => controller.validatePassword(value),
                      controller: controller.passwordController,
                    )),
                const TextFieldLabel(label: "Re-Enter password"),
                Obx(() => PasswordField(
                      isVisible: controller.isConfirmPasswordVisible.value,
                      toggleVisibility:
                          controller.toggleConfirmPasswordVisibility,
                      validator: (value) =>
                          controller.validateConfirmPassword(value),
                      controller: controller.confirmPasswordController,
                    )),
                boxHeigth12,
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                      style: const TextStyle(
                          color: LightColors.secondaryText, fontSize: 14),
                      children: [
                        const TextSpan(
                            text:
                                "By submitting this form, you confirm that you have read and agree to our "),
                        TextSpan(
                          text: "Terms & Conditions",
                          style: TextStyle(
                              color: LightColors.primary[500],
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => {},
                        ),
                      ]),
                ),
                boxHeigth24,
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.submitForm,
                        child: controller.isLoading.isTrue
                            ? const Center(
                                child: CircularProgressIndicator.adaptive())
                            : const Text("Confirm"),
                      ),
                    )),
                boxHeigth16,
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          color: LightColors.secondaryText, fontSize: 14),
                      children: [
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: "Sign in",
                          style: const TextStyle(
                              color: LightColors.primary,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.toNamed("/login"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
