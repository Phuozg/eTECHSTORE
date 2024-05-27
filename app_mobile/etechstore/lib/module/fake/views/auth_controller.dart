// auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
    static AuthController get instance => Get.find();

  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  User? get currentUser => firebaseUser.value;

  void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar('Success', 'Logged in successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to login');
    }
  }

  void logout() async {
    await _auth.signOut();
  }
}
