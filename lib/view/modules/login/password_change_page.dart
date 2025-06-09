import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkable/controllers/otp_controller.dart';
import 'package:linkable/utils/app_assets.dart';
import 'package:linkable/utils/app_constants.dart';
import 'package:linkable/utils/app_decorations.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:linkable/view/shared/custom_text_field.dart';
import 'package:linkable/view/shared/empty_boxes.dart';
import 'package:linkable/view/shared/text_field_label.dart';

class PasswordChangePage extends StatelessWidget {
  PasswordChangePage({super.key});

  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBarDecorations.appBarDecorationBuilder(
          appBarText: "Change",
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
                Center(child: Image.asset(AppAssets.otpPic)),
                boxHeigth30,
                const TextFieldLabel(label: "New Password"),
                  CustomTextField(
                      hintText: "abc12@gmail.com",
                      controller: controller.forgetPasswordEmailController,
                      //validator: (value) => controller.validateEmail(value)
                      ),
                const TextFieldLabel(label: "Re-Enter password"),
                  CustomTextField(
                      hintText: "abc12@gmail.com",
                      controller: controller.forgetPasswordEmailController,
                      //validator: (value) => controller.validateEmail(value)
                      ),
                boxHeigth20,
                Obx(() => SizedBox(
                      child: ElevatedButton(
                        onPressed: () => controller.sendToTheEmail(),
                        child: controller.isLoading.isTrue
                            ? const Center(
                                child: CircularProgressIndicator.adaptive())
                            : const Text("Confirm"),
                      ),
                    )),
                boxHeigth16,
              ],
            ),
          )),
    );
  }
}
