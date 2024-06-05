import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bcrypt/bcrypt.dart';

class AuthServices extends GetxController {
  static AuthServices get instance => Get.find();
  //instance & firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //get current usre
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //SignInWithFireStore
  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await firestore.collection('Users').where('email', isEqualTo: email).limit(1).get();
    return userCredential;
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
  Future<UserCredential?> signOut() async {
    await _auth.signOut();
    return null;
  }

  //SignIn With Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await userAccount?.authentication;
      final credentials = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      return await _auth.signInWithCredential(credentials);
    } catch (e) {
      rethrow;
    }
  }

  //SignIn With PhoneNumber
  Future<PhoneAuthCredential?> signInWithPhoneNumber(int timeOut, String phoneNumber, String verificationId) async {
    try {
      await _auth.verifyPhoneNumber(
        timeout: Duration(seconds: timeOut),
        phoneNumber: phoneNumber,
        verificationCompleted: (AuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException exc) async {
          if (exc.code == 'invalid-phone-number') {
            print('Invalid phone number');
          } else {
            print('e r r o r');
          }
        },
        codeSent: (String verificationid, int? resendToken) {
          verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      e.toString();
    }
    return null;
  }

  //VerifiPhoneNumber
  Future<UserCredential>? verifyPhoneNumber(String verifyId, String smsCode) {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verifyId, smsCode: smsCode);
      return _auth.signInWithCredential(credential);
    } catch (e) {
      e.toString();
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
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('uid', isEqualTo: user.uid)
          .get();

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
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: user.uid)
        .get();

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
