import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/auth/views/sign_in_screen.dart';
import 'package:etechstore/module/bottom_nav_bar/nav_menu.dart';
import 'package:etechstore/module/profile/model/profile_model.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
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
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.dangNhapThatBai);

      return null;
    }
  }

  Future<bool> _isUserAllowedToSignIn(String email) async {
    try {
      QuerySnapshot snapshot = await firestore.collection('Users').where('email', isEqualTo: email).where('TrangThai', isEqualTo: 1).get();

      if (snapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.dangNhapThatBai);

      return false;
    }
  }

  //Forget Password
  Future<void> sendPasswordResetEmail(dynamic email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.dangNhapThatBai);
    }
  }

  //Mail Verification
  Future<void> sendEmailVerification(String email, String password, String hoten) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Gửi email xác nhận
      await userCredential.user!.sendEmailVerification();
      User? user = _auth.currentUser;

      await user?.reload();
      Get.snackbar("Thông báo", "Vui lòng kiểm tra email để xác nhận.");
    } on FirebaseAuthException catch (e) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.daXayRaLoi);
    }
  }

  Future<void> checkEmailVerification(String email, String password, String hoten, BuildContext context) async {
    User? user = _auth.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      await signUpWithEmailPassword(user, hoten, password);
      TLoaders.successSnackBar(title: 'Đăng ký tài khoản thành công', message: 'Hãy sử dụng tài khoản đã đăng ký để tiếp tục.');
       Get.offNamed('/SignInScreen');
    } else {
      Get.snackbar("Thông báo", "Nhập lại thông tin");
    }
  }

  // SignUp
  Future<void> signUpWithEmailPassword(User user, String hoten, String password) async {
    await user.reload();
    await firestore.collection('Users').doc(user.uid).set({
      'password': password,
      'HoTen': hoten,
      'email': user.email,
      'uid': user.uid,
      'HinhDaiDien': 'https://th.bing.com/th/id/R.3268de3daaeef4cdc5cd0bbc5d0e8d20?rik=RgusFJOHX7X%2fCg&pid=ImgRaw&r=0',
      'TrangThai': 1,
      'Quyen': true,
      'SoDienThoai': 0,
      'DiaChi': ''
    });
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
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.dangNhapThatBai);
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
      bool isCurrentPasswordCorrect = await _isCurrentPasswordCorrect(currentPassword, user);
      if (!isCurrentPasswordCorrect) {
        return false;
      }

      await _updatePasswordInFirestore(user, newPassword);

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
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.daXayRaLoi);

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
