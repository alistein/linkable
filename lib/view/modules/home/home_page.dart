import 'package:linkable/controllers/home_controller.dart';
import 'package:linkable/controllers/profile_controller.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:linkable/view/shared/custom_text_field.dart';
import 'package:linkable/view/shared/empty_boxes.dart';
import 'package:linkable/view/shared/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController homeController = Get.put(HomeController());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      backgroundColor: LightColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 35),
                  _buildQuickActions(),
                ],
              ),
            ),
          ),
          // Animated Loading Overlay
          Obx(() => LoadingOverlay(
            isVisible: homeController.isLoading.value,
            message: 'Wait Please',
          )),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      final userName = profileController.userDetails.value?.name ?? 'User';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          boxHeigth12,
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                LightColors.mainTextColor,
                LightColors.secondaryText,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: Text(
              'Hello, $userName',
              style: TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: -1.0,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ready to organize your digital life?',
            style: TextStyle(
              fontSize: 16,
              color: LightColors.secondaryText,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    });
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        _buildLinkInput(),
        const SizedBox(height: 20),
        _buildRaindropIntegration(),
      ],
    );
  }

  Widget _buildLinkInput() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: LightColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LightColors.border),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          CustomTextField(
            hintText: 'Paste your link here...',
            controller: homeController.linkInput,
            keyboardType: TextInputType.url,
            inputAction: TextInputAction.done,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Paste button (smaller)

              
              // Search button (bigger)
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (homeController.linkInput.text.isNotEmpty) {
                        homeController.saveLink();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LightColors.mainTextColor,
                      foregroundColor: LightColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 50,
                height: 50,
                child: OutlinedButton(
                  onPressed: _pasteFromClipboard,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: LightColors.border),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Icon(
                    Icons.paste,
                    size: 20,
                    color: LightColors.mainTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRaindropIntegration() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: LightColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LightColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.bookmark_outline,
            size: 24,
            color: LightColors.secondaryText,
          ),
          const SizedBox(height: 12),
          Text(
            'Import from Raindrop',
            style: TextStyle(
              fontSize: 18,
              color: LightColors.mainTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Sync your bookmarks and collections',
            style: TextStyle(
              fontSize: 14,
              color: LightColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _openRaindropSelection,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: LightColors.border),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Connect Raindrop',
                style: TextStyle(
                  fontSize: 16,
                  color: LightColors.mainTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pasteFromClipboard() async {
    try {
      ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data != null && data.text != null && data.text!.isNotEmpty) {
        homeController.linkInput.text = data.text!;
        Get.snackbar(
          'Pasted',
          'Content pasted from clipboard',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green.shade700,
          duration: Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'No Content',
          'No text found in clipboard',
          backgroundColor: LightColors.accent,
          colorText: LightColors.mainTextColor,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to paste from clipboard',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red.shade700,
        duration: Duration(seconds: 2),
      );
    }
  }

  void _openRaindropSelection() {
    // TODO: Implement Raindrop integration
    Get.snackbar(
      'Coming Soon',
      'Raindrop integration will be available soon!',
      backgroundColor: LightColors.accent,
      colorText: LightColors.mainTextColor,
      duration: Duration(seconds: 2),
    );
  }
}
