
import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:linkable/services/connectivity_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkable/models/error_models.dart';
import 'package:linkable/models/phone_model.dart';
import 'package:linkable/models/register_model.dart';
import 'package:linkable/routes/app_routes.dart';
import 'package:linkable/view/modules/login/login_page.dart';
import 'package:linkable/view/shared/alerts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices extends GetxService {
  static AuthServices get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final connectivityService = Get.find<ConnectivityService>();

  Rx<User?> user = Rx<User?>(null);

  final RxBool isRegistering = false.obs;
  final RxBool isAuthReady = false.obs;


  Future<AuthServices> init() async {
    Get.log("AuthServices: init() started.");

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final bool? isFirstInstall = preferences.getBool('isFirstInstall');

    if (isFirstInstall == null || isFirstInstall) {
      await _auth.signOut();
      await preferences.setBool('isFirstInstall', false);
    }

    user.value = _auth.currentUser;

    Get.log(
        "AuthServices: Initial user.value set to: ${user.value?.uid ?? 'null'}");

    if (user.value == null) {
      connectivityService.isUserInit.value = false;
    }

    user.bindStream(_auth.authStateChanges().map((firebaseUser) {
      Get.log(
          "AuthServices: authStateChanges emitted: ${firebaseUser?.uid ?? 'null'}");
      return firebaseUser;
    }));

    ever(user, _navigateUser);
    Get.log(
        "AuthServices: 'ever(user, _handleAuthChanged)' listener registered.");

    isAuthReady.value = true;
    Get.log("AuthServices: isAuthReady set to true.");

    Get.log("AuthServices: Native splash removed.");
    Get.log("AuthServices: init() completed.");


    return this;
  }

Future<void> login(String email, String password) async {
  try {
    var userCredential = await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
    );

    if (!userCredential.user!.emailVerified) {
    await _auth.signOut();
    showErrorSnack(
      title: "Login Error",
      message: "Your email is not verified. Please verify your email before logging in.",
    );
    return;
    }

    // Handle successful login (optional)
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    switch (e.code) {
    case 'invalid-credential':
      errorMessage = 'Invalid email or password. Please try again.';
      break;
    case 'user-not-found':
      errorMessage = 'No account found with this email.';
      break;
    case 'wrong-password':
      errorMessage = 'Incorrect password. Please try again.';
      break;
    case 'user-disabled':
      errorMessage =
        'This account has been disabled. Please contact support.';
      break;
    default:
      errorMessage = 'An unexpected error occurred. Please try again.';
    }

    showErrorSnack(title: "Login Error", message: errorMessage);
  } catch (e) {
    showErrorSnack(
      title: "Login Error",
      message: 'Something went wrong. Please try again.');
  }
  }

Future<void> register(RegisterModel registerModel) async {
    try {
      isRegistering.value = true;
    
      var createdUser = await _auth.createUserWithEmailAndPassword(
        email: registerModel.email!,
        password: registerModel.password,
      );

      await _saveUserData(createdUser.user!.uid, registerModel);

      final result = await sendVerificationEmail();

      result.fold(
        (success) => showSuccessSnack(title: "Your verification link has been sent", message: "Please verify your account"),
        (failure) => showErrorSnack(title: "Verification Error", message: failure.message),
      );

      Get.offAllNamed(AppRoutes.login);

    } on FirebaseAuthException catch (e) {
      isRegistering.value = false;
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered. Please log in.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak. Use at least 6 characters.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage = 'Signup failed. Please try again later.';
      }

      showErrorSnack(title: "Signup Error", message: errorMessage);
     } catch (e) {
      isRegistering.value = false;
      showErrorSnack(
        title: "Signup Error",
        message: 'Something went wrong. Please try again.',
      );
    }
  }
  Future<Either<Success, Failure>> sendVerificationEmail() async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser != null && !currentUser.emailVerified) {
        await currentUser.sendEmailVerification();
        return Left(Success("Verification email sent successfully."));
      } else if (currentUser?.emailVerified == true) {
        return Right(Failure("Email is already verified."));
      } else {
        return Right(Failure("No user is currently logged in."));
      }
    } catch (e) {
      return Right(Failure("Failed to send verification email. Please try again."));
    }
  }


Future<Either<Success, Failure>> sendForgetPasswordCode(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return Left(Success("Password reset email sent."));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        default:
          errorMessage =
              'Failed to send password reset email. Please try again.';
      }

      return Right(Failure(errorMessage));
    } catch (e) {
      return Right(Failure('Something went wrong. Please try again.'));
    }
  }

  Future<Either<Success, Failure>> fetchUserData() async {
    try {
      var userId = user.value?.uid;

      var userData = await _firestore.collection("users").doc(userId).get();

      return Left(Success(userData.data()));
    } catch (e) {
      return Right(Failure("A Problem occured while accessing user data"));
    }
  }


  Future<Either<Success, Failure>> updateUser(
      {required String name,
      required String surname,
      required PhoneModel phoneNumber,
      required String email}) async {
    try {
      await _firestore.collection("users").doc(user.value!.uid).update({
        "name": name,
        "surname": surname,
        "phoneNumber": phoneNumber.toJson()
      });

      var successMessage = "Your profile has been updated!";

      if (email != user.value?.email) {
        await _auth.currentUser?.verifyBeforeUpdateEmail(email);

        successMessage =
            "For changing email, you need to approve the sent to you new email";
      }

      return Left(Success(successMessage));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'requires-recent-login':
          errorMessage = 'Please login again to perform the email change';
          break;
        default:
          errorMessage = 'An unexpected error occurred. Please try again.';
      }

      showErrorSnack(title: "Login Error", message: errorMessage);
      return Right(Failure(errorMessage));
    } catch (e) {
      return Right(Failure(e.toString()));
    }
  }

  Future<Either<Success, Failure>> updateProfilePhoto(XFile image) async {
    try {
      final String fileName = '${user.value?.uid}_profile_photo';

      final Reference storageRef =
          _storage.ref().child('profile_photos/${user.value?.uid}/$fileName');

      final UploadTask uploadTask = storageRef.putFile(File(image.path));

      // Get download URL after upload completes
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await user.value?.updatePhotoURL(downloadUrl);

      await user.value?.reload();

      return Left(Success(downloadUrl));
    } catch (e) {
      return Right(Failure(e.toString()));
    }
  }

  Future<void> _saveUserData(String uid, RegisterModel registerModel) async {
    await _firestore.collection("users").doc(uid).set(registerModel.toJson());
  }

  Future<void> logout() async {
    await _auth.signOut();
  }


  Future<void> _navigateUser(User? firebaseUser) async {
    // Renamed param for clarity
    Get.log(
        "AuthServices: _navigateUser triggered. User: ${firebaseUser?.uid ?? 'null'}. Current route: ${Get.currentRoute}");

    // Ensure navigation logic only runs after the initial splash/setup phase is complete
    // and InitializerWidget has had a chance to render the first screen.
    if (!isAuthReady.value) {
      Get.log(
          "AuthServices: _navigateUser called but isAuthReady is false. Navigation deferred.");
      return; // Don't navigate if the app isn't ready for it yet
    }

    if (!await connectivityService.hasInternet()) {
      Get.offAllNamed(AppRoutes.noInternet);
      return;
    }

    if (firebaseUser == null) {
      Get.log("AuthServices: User is null. Navigating to LoginPage.");
      // Ensure LoginPage is a widget builder, not a route string if using Get.offAll
      connectivityService.isUserInit.value = false;
      Get.offAll(() => LoginPage()); // If not logged in, go to LoginPage
    } else {
      if (isRegistering.value) {
        Get.log(
            "AuthServices: Registration in progress. Deferring navigation.");
        return; // Skip navigation during registration
      }
      Get.log(
          "AuthServices: User is not null (${firebaseUser.uid}). Checking Firestore.");
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection("users").doc(firebaseUser.uid).get();

        if (userDoc.exists) {
          // Explicitly cast to Map<String, dynamic> before accessing fields
          Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?;

          final currentUser = _auth.currentUser;

          final currentUserVerified = currentUser?.emailVerified ?? false;

          if (userData != null && currentUserVerified) {
            Get.log(
                "AuthServices: User is verified. Navigating to AppRoutes.mainPage.");
            if (Get.currentRoute != AppRoutes.mainPage) {
              Get.offAllNamed(AppRoutes.mainPage);
            }
          } else {
            Get.log(
                "AuthServices: User doc exists but 'isVerified' is missing or not a bool, or userData is null. Navigating to AppRoutes.login.");
            if (Get.currentRoute != AppRoutes.login) {
              Get.offAllNamed(AppRoutes.login);
            }
          }
        } else {
          Get.log(
              "AuthServices: User doc does not exist in Firestore. Navigating to AppRoutes.login.");
          if (Get.currentRoute != AppRoutes.login) {
            Get.offAllNamed(AppRoutes.login);
          }
        }
      } catch (e) {
        Get.log(
            "AuthServices: Error fetching user document from Firestore: $e. Navigating to AppRoutes.login as a fallback.");
        // Fallback navigation in case of Firestore error
        if (Get.currentRoute != AppRoutes.login) {
          Get.offAllNamed(AppRoutes.login);
        }
      }
    }
  }
}
