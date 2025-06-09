import 'package:linkable/controllers/home_controller.dart';import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkable/models/phone_model.dart';
import 'package:linkable/models/user_model.dart';
import 'package:linkable/services/auth_services.dart';
import 'package:linkable/controllers/validation_controller.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:linkable/view/shared/custom_text_field.dart';
import 'package:linkable/view/shared/empty_boxes.dart'; // Assuming boxHeigth24 is here
import 'package:linkable/view/shared/phone_field.dart';
import 'package:linkable/view/shared/text_field_label.dart';
import 'package:linkable/view/shared/alerts.dart'; // Assuming snackbars are here
import 'package:url_launcher/url_launcher.dart';
// import 'package:permission_handler/permission_handler.dart'; // If needed for commented code

class ProfileController extends GetxController {
  // --- Text Controllers ---

  final profileFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();

  // --- User & State ---
  final ImagePicker _picker = ImagePicker();
  Rx<UserModel?> userDetails = Rx(null);
  var isLoading = false.obs;
  var isSwitched = false.obs; // For notifications
  var isChangingPassword = false.obs;

  // --- Phone State ---
  var selectedCountryCode = "+994".obs;
  var phoneNumber = "".obs;
  var selectedCountry = "GB".obs; // e.g., "AZ"

  // --- Services & Validation ---
  // Use Get.find() if already put, or ensure single Get.put() elsewhere
  final AuthServices _authService = Get.find<AuthServices>();
  final ValidationController validationController =
      Get.put(ValidationController());

  // --- State for Bottom Sheet Change Detection ---
  var hasChanges = false.obs;
  late String _originalName;
  late String _originalSurname;
  late String _originalEmail;
  late String _originalPhoneNumber;
  late String _originalCountryCode;
  late String _originalCountry;

  // --- Methods ---

  @override
  void onInit() {
    // checkNotificationPermission(); // Uncomment if needed
    fetchUserData(); // Fetches initial data and populates controllers/obs
    super.onInit();
  }

  // @override
  // void onClose() {
  //   nameController.dispose();
  //   surnameController.dispose();
  //   emailController.dispose();
  //   super.onClose();
  // }

  // --- Fetch User Data ---
  Future<void> fetchUserData() async {
    // Consider adding isLoading state here if fetch takes time
    var rawUserData = await _authService.fetchUserData();

    rawUserData.fold((success) async {
      var fetchedUser = UserModel.fromJson(success.data);
      // Use email/photo from the authenticated user object if backend doesn't return it
      fetchedUser.email = _authService.user.value?.email ?? fetchedUser.email;

      try {
        await _authService.user.value?.reload();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'user-token-expired':
            _authService.logout();
            break;
          default:
        }
      }

      _authService.user.value = FirebaseAuth.instance.currentUser;

      fetchedUser.profilePhotoUrl = _authService.user.value?.photoURL;

      userDetails.value = fetchedUser;

      // Populate controllers and reactive variables
      nameController.text = userDetails.value!.name;
      surnameController.text = userDetails.value!.surname;
      emailController.text = userDetails.value!.email;
      selectedCountryCode.value = userDetails.value!.phoneNumber.prefix;
      selectedCountry.value = userDetails.value!.phoneNumber.country;
      phoneNumber.value = userDetails.value!.phoneNumber.number;

      // Set notification switch state
      isSwitched.value = userDetails.value!.isNotificationEnabled;
    }, (failure) {
      showErrorSnack(title: "Problem Occurred", message: failure.message);
      // Handle fetch failure case - maybe clear fields or show error placeholder?
      userDetails.value = null; // Or keep previous value?
      nameController.text = '';
      surnameController.text = '';
      emailController.text = '';
      selectedCountryCode.value = '+994'; // Reset to default?
      selectedCountry.value = '';
      phoneNumber.value = '';
      isSwitched.value = false;
    });
  }

  // --- Phone Update Callbacks (used by PhoneField) ---
  void updatePhoneNumber(String number) {
    phoneNumber.value = number;
    _checkForChanges(); // Check if this change causes a difference
  }

  void changeCountryCode(String newCode) {
    selectedCountryCode.value = newCode;
    _checkForChanges();
  }

  void changeCountry(String code) {
    selectedCountry.value = code;
    _checkForChanges();
  }

  // --- Change Detection Logic ---
  void _checkForChanges() {
    // Compare current values with stored original values
    bool nameChanged = nameController.text != _originalName;
    bool surnameChanged = surnameController.text != _originalSurname;
    bool emailChanged = emailController.text != _originalEmail;
    bool phoneChanged = phoneNumber.value != _originalPhoneNumber;
    bool countryCodeChanged = selectedCountryCode.value != _originalCountryCode;
    // bool countryChanged = selectedCountry.value != _originalCountry; // Only if country selection affects update

    hasChanges.value = nameChanged ||
        surnameChanged ||
        emailChanged ||
        phoneChanged ||
        countryCodeChanged; // || countryChanged;
  }

  // --- Show Update Bottom Sheet ---
  void showUpdateBottomSheet(BuildContext context) async {
    // Make async
    // 1. Store original values BEFORE showing the sheet
    _originalName = nameController.text;
    _originalSurname = surnameController.text;
    _originalEmail = emailController.text;
    _originalPhoneNumber = phoneNumber.value;
    _originalCountryCode = selectedCountryCode.value;
    _originalCountry = selectedCountry.value;

    // 2. Reset change detection flag
    hasChanges.value = false;

    // 3. Add temporary listeners to controllers
    //    Using GetX's Obx for the button is often simpler than manual listeners.
    //    We will call _checkForChanges within Obx instead.
    nameController.addListener(_checkForChanges);
    surnameController.addListener(_checkForChanges);
    emailController.addListener(_checkForChanges);
    // Changes to phone observables already call _checkForChanges via their update methods

    // 4. Show the bottom sheet and wait for result
    final result = await showModalBottomSheet<bool?>(
        // Expect bool? result
        context: context, // Use the outer context passed to the method
        useSafeArea: true,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (BuildContext innerContext) {
          // Use innerContext for builder scope
          return Padding(
            padding: EdgeInsets.only(
              left: 25.0,
              right: 25.0,
              bottom: MediaQuery.of(innerContext)
                  .viewInsets
                  .bottom, // Use innerContext
            ),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Form(
                  key: profileFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text('Information',
                          style: TextStyle(
                            fontSize: 23,
                            color: LightColors.mainTextColor,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                    const SizedBox(height: 16), // Add some spacing

                    const TextFieldLabel(label: "Name"),
                    CustomTextField(
                        hintText:
                            "John", // Consider using originalName as hint?
                        controller: nameController,
                        inputAction: TextInputAction.next,
                        validator: (value) =>
                            validationController.validateName(value)),

                    const TextFieldLabel(label: "Surname"),
                    CustomTextField(
                      hintText: "Smith",
                      inputAction: TextInputAction.next,
                      controller: surnameController,
                      validator: (value) =>
                          validationController.validateSurname(value),
                    ),

                    const TextFieldLabel(label: "Phone number"),
                    // Assuming PhoneField uses the controller methods
                    PhoneField(
                        controller: this, // Pass controller instance
                        hintText: "1712345678",
                        inputAction: TextInputAction.next,
                        validator: (value) => validationController.validatePhone(
                            value)), // Validator might need access to full number state

                    const TextFieldLabel(
                      label: "Email",
                      topMargin: 0,
                    ),
                    CustomTextField(
                        hintText: "abc12@gmail.com",
                        inputAction: TextInputAction.done,
                        controller: emailController,
                        validator: (value) =>
                            validationController.validateEmail(value)),

                    boxHeigth24, // Use const SizedBox(height: 24)

                    // Obx listens to isLoading and hasChanges
                    Obx(() {
                      // Re-evaluate changes whenever Obx rebuilds
                      // _checkForChanges(); // Call check here if not using listeners or update methods
                      bool canConfirm = hasChanges.value && !isLoading.value;

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            // Enable/disable based on changes and loading state
                            onPressed: canConfirm
                                ? () {
                                    // Optional: Form validation
                                    // if (_formKey.currentState?.validate() ?? false) {
                                    updateUserData(
                                        innerContext); // Pass context for popping
                                    // }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              // Optionally change style when disabled
                              backgroundColor:
                                  canConfirm ? null : Colors.grey.shade300,
                            ), // Disabled if no changes or loading
                            child: isLoading.value
                                ? const Center(
                                    child: SizedBox(
                                    // Give indicator a size
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator.adaptive(
                                      strokeWidth: 3,
                                    ),
                                  ))
                                : Text(
                                    "Confirm",
                                    style: TextStyle(
                                        color: canConfirm
                                            ? LightColors
                                                .mainTextColor // Active color
                                            : Colors
                                                .grey // Disabled color (example)
                                        ),
                                  )),
                      );
                    }),
                    const SizedBox(height: 20), // Bottom padding
                  ],
                ),
                ), // Form End
              ),
            ),
          );
        }); // End showModalBottomSheet

    // 5. Remove temporary listeners AFTER sheet closes
    nameController.removeListener(_checkForChanges);
    surnameController.removeListener(_checkForChanges);
    emailController.removeListener(_checkForChanges);

    // 6. Check result and reset if necessary
    if (result != true) {
      // Reset only if update didn't succeed (dismissed or failed)
      print("Resetting fields to original values because result was: $result");
      nameController.text = _originalName;
      surnameController.text = _originalSurname;
      emailController.text = _originalEmail;
      phoneNumber.value = _originalPhoneNumber;
      selectedCountryCode.value = _originalCountryCode;
      selectedCountry.value = _originalCountry;
      hasChanges.value = false; // Reset flag
    } else {
      print("Update successful. Fields retain their new values.");
      // The fetchUserData within updateUserData already updated the state
    }
  }

  // --- Update User Data ---
  // Needs BuildContext to pop the sheet
  Future<void> updateUserData(BuildContext context) async {

    if (profileFormKey.currentState!.validate()) {
      isLoading.value = true;
      bool success = false;
    var result = await _authService.updateUser(
      name: nameController.text, // Use .text directly
      surname: surnameController.text,
      phoneNumber: PhoneModel(
        prefix: selectedCountryCode.value,
        number: phoneNumber.value,
        country: selectedCountry.value,
        combined:
            "${selectedCountryCode.value}${phoneNumber.value}", // Ensure prefix includes '+' if needed by backend
      ),
      email: emailController.text,
    );

    result.fold(
        (successResponse) async {
        showSuccessSnack(title: "Updated", message: successResponse.data);
        success = true;
        // Fetch data again AFTER successful update to reflect server state
        // This also resets controllers if backend returns slightly different format
          await fetchUserData();
      },
      (failure) {
        showErrorSnack(title: "Problem occurred", message: failure.message);
        success = false;
      },
    );

    isLoading.value = false;

    // Pop the sheet AFTER processing is complete, passing success status
    // Check if context is still valid (widget might be disposed)
    if (Navigator.canPop(context)) {
      Navigator.pop(context, success); // Pop with true/false
    }
    }

  }

  // --- Other Methods (Profile Photo, Password Change, Logout, Mail etc.) ---
  Future<void> updateProfilePhoto() async {
    isLoading.value = true; // Show loading indicator
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75);

    if (image == null) {
      isLoading.value = false;
      return; // User cancelled picker
    }

    var result = await _authService.updateProfilePhoto(image);

    result.fold((successResponse) async {
      showSuccessSnack(
          title: "Updated", message: "Profile picture was updated");
      // Update local state immediately for better UX
      userDetails.value?.profilePhotoUrl = successResponse.data;
      userDetails
          .refresh(); // Notify GetX listeners about the change in the nested object
    },
        (failure) =>
             showErrorSnack(
            title: "Problem Occurred", message: failure.message));

    isLoading.value = false;
  }

  Future<void> changePassword() async {
    // Ensure userDetails and email are available
    final email = userDetails.value?.email;
    if (email == null || email.isEmpty) {
      showErrorSnack(title: "Error", message: "User email not found.");
      return;
    }

    isChangingPassword.value = true;
    var result = await _authService.sendForgetPasswordCode(email);

    result.fold((success) async {
      showSuccessSnack(
          title: "Link sent",
          message: "Password change link sent to your email");
    }, (failure) {
      showErrorSnack(title: "Problem Occurred", message: failure.message);
    });
    isChangingPassword.value = false; // Set false regardless of outcome
  }

  Future<void> logout() async {
    // Add confirmation dialog?
    await _authService.logout();

    Get.delete<HomeController>();
    // Navigation to login screen usually happens in the AuthGuard or listener
  }

  Future<void> openDefaultMailApp() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
        path: 'support@domehive.com', // Replace with your actual support email
        queryParameters: {
          // Use queryParameters for cleaner encoding
          'subject': 'Domehive App Support Request',
          'body':
              'Hello Domehive Support,\n\nI need help with...\n\n(Please describe your issue here)',
        }
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        showErrorSnack(title: "Error", message: "Could not launch email app.");
      }
    } catch (e) {
      showErrorSnack(title: "Error", message: "Failed to open email app: $e");
    }
  }
}
