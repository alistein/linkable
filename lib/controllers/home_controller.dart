import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:linkable/controllers/profile_controller.dart';
import 'package:linkable/models/link_model.dart';
import 'package:linkable/services/auth_services.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:linkable/view/shared/edit_link_bottomsheet.dart';


class HomeController extends GetxController {
  final AuthServices _authService = Get.put(AuthServices());

  final ProfileController profileController = Get.put(ProfileController());

  final TextEditingController linkInput = TextEditingController();

  final _firestore = FirebaseFirestore.instance;
  final Dio _dio = Dio();

  // Loading state for the overlay
  final RxBool isLoading = false.obs;

  // Observable to store a single link
  final Rx<LinkModel?> currentLink = Rx<LinkModel?>(null);

  void saveLink() async {
    if (linkInput.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a link first',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red.shade700,
        duration: Duration(seconds: 2),
      );
      return;
    }

    // Show loading overlay
    isLoading.value = true;

    try {
      // Get content from backend
      var content = await getContentFromBack();

      Get.log(content.toString());
      
      // Hide loading overlay
      isLoading.value = false;
      
      if (content != null) {
        // Show bottom sheet with the fetched content for editing
        showEditLinkBottomSheet(linkData: content);
      }
      
      linkInput.clear();
      
    } catch (e) {
      // Hide loading overlay on error
      isLoading.value = false;
      
      Get.snackbar(
        'Error',
        'Failed to fetch link content. Please try again.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red.shade700,
        duration: Duration(seconds: 2),
      );
    }
  }

  Future<LinkModel?> getContentFromBack() async {
    try {
      // Get user's current tags
      final userTags = profileController.userDetails.value?.tags ?? [];
      final webpageLink = linkInput.text.trim();
      
      if (webpageLink.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter a webpage link',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red.shade700,
          duration: Duration(seconds: 2),
        );
        return null;
      }

      // Prepare the payload
      final payload = {
        "tags": userTags,
        "webpage-link": webpageLink,
      };

      // Make API call to backend
      final response = await _dio.post(
        'http://localhost:8080/generate-tags',
        data: payload,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data;
        
        // Map the response to LinkModel
        LinkModel linkModel = LinkModel(
          id: responseData['id']?.toString(),
          webPageName: responseData['webpageName'],
          title: responseData['title'] ?? responseData['webpageName'] ?? 'Untitled',
          summary: responseData['summary'] ?? 'No summary available',
          tag: responseData['tag'] ?? 'general',
          website: webpageLink, // Use the original link input
          scrapedLinks: responseData['scrapedLinks'] != null 
              ? List<String>.from(responseData['scrapedLinks']) 
              : null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        // Update the observable link
        currentLink.value = linkModel;
        
        // Show success message
        Get.snackbar(
          'Success',
          'Content loaded successfully!',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        );
        
        return linkModel;
      } else {
        throw Exception('Failed to load content from server');
      }
      
    } on DioException catch (e) {
      String errorMessage = 'Failed to load content. Please try again.';
      
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timeout. Please check your connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Connection error. Please check if the server is running.';
      } else if (e.response?.statusCode == 400) {
        errorMessage = 'Invalid request. Please check the webpage link.';
      } else if (e.response?.statusCode == 500) {
        errorMessage = 'Server error. Please try again later.';
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red.shade700,
        duration: const Duration(seconds: 3),
      );
      
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red.shade700,
        duration: const Duration(seconds: 2),
      );
      
      return null;
    }
  }

  // Save or update link to Firebase
  Future<void> saveLinkToFirebase(LinkModel linkModel) async {
    if (_authService.user.value == null) {
      Get.snackbar(
        'Error',
        'Please login to save links',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red.shade700,
      );
      return;
    }

    isLoading.value = true;

    try {
      final linkData = linkModel.toMap();
      linkData['userId'] = _authService.user.value!.uid;

      if (linkModel.id != null) {
        // Update existing link
        await _firestore
            .collection('links')
            .doc(linkModel.id)
            .set(linkData);
        
      } else {
        // Create new link
        await _firestore
            .collection('links')
            .add(linkData);
        
        Get.snackbar(
          'Success',
          'Link saved successfully!',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        );
      }

      // If the tag does not exist in the user's tags, add it to Firestore
      if (profileController.userDetails.value != null &&
          profileController.userDetails.value!.tags != null &&
          profileController.userDetails.value!.tags!.contains(linkModel.tag)) {
        // Tag already exists, do nothing
      } else {
        // Tag does not exist, add it to the user's tags in Firestore
        final userId = _authService.user.value!.uid;
        final userDocRef = _firestore.collection('users').doc(userId);

        // Add the tag to the local user model as well
        final currentTags = profileController.userDetails.value?.tags ?? [];
        final updatedTags = List<String>.from(currentTags)..add(linkModel.tag);

        await userDocRef.update({'tags': updatedTags});

        // Optionally update the local userDetails as well
        profileController.userDetails.value?.tags = updatedTags;
        profileController.userDetails.refresh();
      }
      // Update the current link observable
      currentLink.value = linkModel;

      Get.snackbar(
          'Success',
          'Link saved successfully!',
          backgroundColor: const Color.fromARGB(255, 104, 111, 104).withOpacity(0.1),
          colorText: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save link. Please try again.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red.shade700,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Show edit link bottom sheet
  void showEditLinkBottomSheet({LinkModel? linkData}) {
    Get.bottomSheet(
      EditLinkWidget(linkData: linkData),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  void onInit() async {

    FlutterNativeSplash.remove();

    super.onInit();
  }


  @override
  void onClose() {

    super.onClose();
  }

  @override
  void dispose() {

    super.dispose();
  }
}
