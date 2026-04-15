import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final AuthService _authService = Get.find<AuthService>();

  final RxBool _isLoggedIn = false.obs;
  bool get isLoggedIn => _isLoggedIn.value;

  final Rx<User?> _firebaseUser = Rx<User?>(null);
  User? get user => _firebaseUser.value;

  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final RxBool isLoading = false.obs;

  final authChangeNotifier = ChangeNotify();
  late SharedPreferences _prefs;

  String? _verificationId;

  Future<AuthController> init() async {
    _prefs = await SharedPreferences.getInstance();
    _firebaseUser.bindStream(_authService.authStateChanges);
    
    ever(_firebaseUser, (User? user) {
      if (user != null) {
        _isLoggedIn.value = true;
        _prefs.setBool('isLoggedIn', true);
        getUserData(user.uid);
      } else {
        _isLoggedIn.value = false;
        _prefs.setBool('isLoggedIn', false);
        userData.clear();
      }
      authChangeNotifier.notify();
    });

    _isLoggedIn.value = _authService.currentUser != null;
    if (_authService.currentUser != null) {
      getUserData(_authService.currentUser!.uid);
    }

    return this;
  }

  Future<void> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _authService.getUserData(uid);
      if (doc.exists) {
        userData.value = doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  // --- Phone Authentication ---

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      isLoading.value = true;
      await _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _authService.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          Get.snackbar("Error", e.message ?? "Verification failed", snackPosition: SnackPosition.BOTTOM);
        },
        codeSent: (String verificationId, int? resendToken) {
          isLoading.value = false;
          _verificationId = verificationId;
          Get.snackbar("Success", "OTP sent to $phoneNumber", snackPosition: SnackPosition.BOTTOM);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signInWithOtp(String smsCode) async {
    try {
      if (_verificationId == null) return;
      isLoading.value = true;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await _authService.signInWithCredential(credential);
    } catch (e) {
      Get.snackbar("Error", "Invalid OTP", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // --- Email/Password Authentication ---

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.login(email, password);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.signUp(name, email, password);
      if (_authService.currentUser != null) {
        await getUserData(_authService.currentUser!.uid);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      Get.snackbar(
        "Success",
        "Password reset link sent to your email",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    if (user == null) return;
    try {
      await _authService.updateUserData(user!.uid, data);
      await getUserData(user!.uid);
    } catch (e) {
      debugPrint("Error updating user data: $e");
    }
  }
}

class ChangeNotify extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
