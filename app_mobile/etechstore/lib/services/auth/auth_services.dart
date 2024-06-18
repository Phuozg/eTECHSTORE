import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/auth/views/sign_in_screen.dart';
import 'package:etechstore/module/bottom_nav_bar/nav_menu.dart';
import 'package:etechstore/module/profile/model/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices extends GetxController {
  static AuthServices get instance => Get.find();
  //instance & firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //get current usre
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Get.offNamed('/navMenu');
    } else {
      Get.offNamed('/SignInScreen');
      signOut();
    }
  }

  //SignInWithFireStore
  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (await _isUserAllowedToSignIn(email)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Get.offNamed('/navMenu');
      return userCredential;
    } else {
      await _auth.signOut();
      Get.snackbar('Đăng nhập thất bại', 'Email hoặc trạng thái không hợp lệ');
      return null;
    }
  }

  // Check if the user is allowed to sign in
  Future<bool> _isUserAllowedToSignIn(String email) async {
    try {
      QuerySnapshot snapshot = await firestore.collection('Users').where('email', isEqualTo: email).where('TrangThai', isEqualTo: 1).get();

      if (snapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking user status: $e');
      return false;
    }
  }

  //Forget Password
  Future<void> sendPasswordResetEmail(dynamic email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw 'Đã xãy ra lỗi. Hãy thử lại sau';
    }
  }

  //Mail Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw 'Đã xãy ra lỗi. Hãy thử lại sau';
    }
  }

  //SignUp
  Future<UserCredential?> signUpWithEmailPassword(String email, String password, String hoten) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    firestore.collection('Users').doc(userCredential.user!.uid).set({
      'HoTen': hoten,
      'email': email,
      'password': password,
      'uid': userCredential.user!.uid,
      'HinhDaiDien': 'https://th.bing.com/th/id/R.3268de3daaeef4cdc5cd0bbc5d0e8d20?rik=RgusFJOHX7X%2fCg&pid=ImgRaw&r=0',
      'TrangThai': 1,
      'Quyen': true,
      'SoDienThoai': 0,
      'DiaChi': ''
    });
    return userCredential;
  }

  //SignOut
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await _auth.signOut();
    Get.offAllNamed('/SignInScreen');
  }

  //SignIn With Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
      if (userAccount == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await userAccount.authentication;
      final credentials = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userCredential = await _auth.signInWithCredential(credentials);

      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        Get.offNamed('/navMenu');

        firestore.collection('Users').doc(userCredential.user!.uid).set({
          'HoTen': userAccount.email,
          'email': userAccount.email,
          'password': 'Trống',
          'uid': userCredential.user!.uid,
          'HinhDaiDien': 'https://th.bing.com/th/id/R.3268de3daaeef4cdc5cd0bbc5d0e8d20?rik=RgusFJOHX7X%2fCg&pid=ImgRaw&r=0',
          'TrangThai': 1,
          'Quyen': true,
          'SoDienThoai': 0,
          'DiaChi': ''
        });

        return userCredential;
      }
    } catch (e) {
      print("Lỗi đăng nhập Google: $e");
      Get.snackbar('Đăng nhập thất bại', e.toString());
    }
    return null;
  }

  // check if the email exists
  Future<bool> checkEmailExists(String email) async {
    final QuerySnapshot result = await firestore.collection('Users').where('email', isEqualTo: email).limit(1).get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.isNotEmpty;
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return false;
    }

    try {
      // Kiểm tra mật khẩu hiện tại
      bool isCurrentPasswordCorrect = await _isCurrentPasswordCorrect(currentPassword, user);
      if (!isCurrentPasswordCorrect) {
        return false;
      }

      // Cập nhật mật khẩu trong Firestore
      await _updatePasswordInFirestore(user, newPassword);

      // Cập nhật mật khẩu trong Authentication
      await user.updatePassword(newPassword);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _isCurrentPasswordCorrect(String currentPassword, User user) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Users').where('uid', isEqualTo: user.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        final storedPassword = querySnapshot.docs.first.data()['password'];
        return currentPassword == storedPassword;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _updatePasswordInFirestore(User user, String newPassword) async {
    final querySnapshot = await FirebaseFirestore.instance.collection('Users').where('uid', isEqualTo: user.uid).get();

    for (final doc in querySnapshot.docs) {
      await doc.reference.update({'password': newPassword});
    }
  }

  Future<UserCredential> updatePasswordInFirestore(String email, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: newPassword,
    );

    final querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
    for (final doc in querySnapshot.docs) {
      if (doc.data()['uid'] == user!.uid) {
        await doc.reference.update({'password': newPassword});
      }
    }
    return userCredential;
  }
}
