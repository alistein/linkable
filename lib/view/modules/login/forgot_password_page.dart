import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:linkable/controllers/otp_controller.dart';
import 'package:linkable/controllers/validation_controller.dart';
import 'package:linkable/utils/app_assets.dart';
import 'package:linkable/utils/app_constants.dart';
import 'package:linkable/utils/app_decorations.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:linkable/view/shared/custom_text_field.dart';
import 'package:linkable/view/shared/empty_boxes.dart';
import 'package:linkable/view/shared/text_field_label.dart';

class ForgetPasswordPage extends StatelessWidget {
  ForgetPasswordPage({super.key});

  final OtpController controller = Get.put(OtpController());
  final ValidationController validationController = Get.put(ValidationController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBarDecorations.appBarDecorationBuilder(
          appBarText: "Forgot",
          colorType: AppBarBackgroundColors.registrationVersion),
      backgroundColor: LightColors.background,
      body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 35),
          child: Form(
            //key: controller.formKey,
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boxHeigth24,
                Center(child: SvgPicture.asset(AppAssets.forgetPasswordPic)),
                boxHeigth30,
                Center(
                  child: Text("Forgot Password?",
                      style: TextStyle(
                          fontSize: 26.32, fontWeight: FontWeight.w700)),
                ),
                boxHeigth8,
                Center(
                  child: SizedBox(
                    width: width * 0.9,
                    child: Text(
                      "Don’t worry! it happens. Please enter email address associated with your account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: LightColors.secondaryText,
                          fontSize: 15.35,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                boxHeigth14,
                const TextFieldLabel(label: "Email"),
                  CustomTextField(
                      hintText: "abc12@gmail.com",
                      controller: controller.forgetPasswordEmailController,
                      validator: (value) => validationController.validateEmail(value)
                      ),
                boxHeigth20,
                Obx(() => SizedBox(
                      child: ElevatedButton(
                        onPressed: () => controller.sendToTheEmail(),
                        child: controller.isLoading.isTrue
                            ? const Center(
                                child: CircularProgressIndicator.adaptive())
                            : const Text("Continue"),
                      ),
                    )),
                boxHeigth16,
              ],
            ),
          )),
    );
  }
}
