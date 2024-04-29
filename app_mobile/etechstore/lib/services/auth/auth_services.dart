import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    firestore.collection('Users').doc(userCredential.user!.uid).set({
      'password': password,
      'email': email,
    });
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
}
