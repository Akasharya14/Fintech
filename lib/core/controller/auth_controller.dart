import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final RxBool _isLoggedIn = false.obs;
  bool get isLoggedIn => _isLoggedIn.value;

  final Rx<User?> _firebaseUser = Rx<User?>(null);
  User? get user => _firebaseUser.value;

  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final RxBool isLoading = false.obs;

  // This will be used by GoRouter to listen for changes
  final authChangeNotifier = ChangeNotify();

  late SharedPreferences _prefs;

  Future<AuthController> init() async {
    _prefs = await SharedPreferences.getInstance();

    // Bind firebase user to our observable
    _firebaseUser.bindStream(_auth.authStateChanges());
    
    // Listen to auth changes
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

    _isLoggedIn.value = _auth.currentUser != null;
    if (_auth.currentUser != null) {
      getUserData(_auth.currentUser!.uid);
    }

    return this;
  }

  Future<void> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        userData.value = doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
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
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // Save user data to Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': name,
        'email': email,
        'profilePic': "",
        'createdAt': FieldValue.serverTimestamp(),
      });

      await getUserData(credential.user!.uid);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      
      if (image != null) {
        isLoading.value = true;
        File file = File(image.path);
        String uid = _auth.currentUser!.uid;
        
        Reference ref = _storage.ref().child('profilePics').child("$uid.jpg");
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Update Firestore
        await _firestore.collection('users').doc(uid).update({
          'profilePic': downloadUrl,
        });

        // Update local state
        userData['profilePic'] = downloadUrl;
        userData.refresh();
        
        Get.snackbar("Success", "Profile picture updated successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to upload image: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
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
}

class ChangeNotify extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
