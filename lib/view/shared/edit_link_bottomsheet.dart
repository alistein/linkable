import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkable/controllers/home_controller.dart';
import 'package:linkable/controllers/profile_controller.dart';
import 'package:linkable/models/link_model.dart';
import 'package:linkable/view/shared/custom_text_field.dart';
import 'package:linkable/utils/theme/app_colors.dart';

class EditLinkWidget extends StatelessWidget {
  final LinkModel? linkData;

  const EditLinkWidget({
    super.key,
    this.linkData,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final ProfileController profileController = Get.find<ProfileController>();
    
    final titleController = TextEditingController(text: linkData?.title ?? '');
    final summaryController = TextEditingController(text: linkData?.summary ?? '');
    final websiteController = TextEditingController(text: linkData?.website ?? '');
    
    // Get tags from user details
    final userTags = profileController.userDetails.value?.tags ?? <String>[];
    
    // Create a mutable list of available tags
    final availableTags = List<String>.from(userTags);
    
    // If linkData has a tag and it's not in user's tags, add it to the beginning
    if (linkData?.tag != null && linkData!.tag!.isNotEmpty && !availableTags.contains(linkData!.tag)) {
      availableTags.insert(0, linkData!.tag!);
    }
    
    // Ensure selectedTag is valid - prioritize linkData tag if available
    String initialTag = '';
    if (linkData?.tag != null && linkData!.tag!.isNotEmpty) {
      initialTag = linkData!.tag!;
    } else if (availableTags.isNotEmpty) {
      initialTag = availableTags.first;
    }
    
    final selectedTag = RxString(initialTag);

    void saveLink() {
      if (titleController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Title is required',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red.shade700,
        );
        return;
      }

      if (websiteController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Website URL is required',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red.shade700,
        );
        return;
      }

      final linkModel = LinkModel(
        id: linkData?.id,
        title: titleController.text.trim(),
        summary: summaryController.text.trim(),
        tag: selectedTag.value,
        website: websiteController.text.trim(),
        scrapedLinks: linkData?.scrapedLinks,
        webPageName: linkData?.webPageName,
        createdAt: linkData?.createdAt,
        updatedAt: DateTime.now(),
      );

      controller.saveLinkToFirebase(linkModel);
      Get.back();
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: LightColors.mutedText.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                Text(
                  linkData?.id != null ? 'Edit Link' : 'Add Link',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: LightColors.mutedText,
                    size: 24,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: LightColors.background,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ),
          
          // Form content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title field
                  const Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: titleController,
                    hintText: 'Enter link title',
                    inputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  
                  // Website field
                  const Text(
                    'Website URL',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: websiteController,
                    hintText: 'https://example.com',
                    keyboardType: TextInputType.url,
                    inputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  
                  // Tag selector - only show if tags are available
                  if (availableTags.isNotEmpty) ...[
                    const Text(
                      'Tag',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: LightColors.input,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: LightColors.border,
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedTag.value,
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: LightColors.mutedText,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: LightColors.primary[600],
                            height: 1.5,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              selectedTag.value = newValue;
                            }
                          },
                          items: availableTags.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    )),
                    const SizedBox(height: 20),
                  ],
                  
                  // Summary field
                  const Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: LightColors.input,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: LightColors.border,
                        width: 1,
                      ),
                    ),
                    child: TextFormField(
                      controller: summaryController,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: LightColors.primary[600],
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add a brief description...',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: LightColors.mutedText,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Save button
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value ? null : saveLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LightColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        disabledBackgroundColor: LightColors.mutedText.withOpacity(0.3),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              linkData?.id != null ? 'Save Link' : 'Save Link',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  )),
                  
                  // Bottom padding for safe area
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 