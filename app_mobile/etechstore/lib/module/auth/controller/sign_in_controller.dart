import 'package:etechstore/module/auth/views/sign_in_screen.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/services/auth/auth_gate.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/services/notifi_service.dart';
import 'package:etechstore/utlis/connection/network_manager.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/dialog/alert_dialog.dart';
import 'package:etechstore/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find();
  final AuthServices authServices = Get.put(AuthServices());
  final NetworkManager network = Get.put(NetworkManager());

  //Variables
  final hidePassword = true.obs;
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final conformPassword = TextEditingController();
  final phoneNumber = TextEditingController();
  Rx<String> verify = "".obs;
  Rx<String> code = "".obs;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void clearPassword() {
    email.clear();
    password.clear();
    conformPassword.clear();
    fullName.clear();
  }

//
  Future<void> checkSignIn() async {
    await authServices.checkLoginStatus();
  }

  Future<void> signOut() async {
    ETAlertDialog.showConfirmPopup(
      title: "Xác nhận",
      description: "Bạn có thực sự muốn đăng xuất",
      conFirm: () => authServices.signOut(),
    );
  }

  Future<void> signIn() async {
    final isconnected = network.isConnectedToInternet.value;
    try {
      if (!isconnected) {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
        return;
      }

      if (email.text.isEmpty || password.text.isEmpty) {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.chuaNhapDuThongTin);
        return;
      }

      FullScreenLoader.openLoadingDialog('Quá trình đang diễn ra...', ImageKey.loadingAnimation);
      await authServices.signInWithEmailPassword(email.text.trim(), password.text.trim());
      await authServices.updatePasswordInFirestore(email.text.trim(), password.text.trim());
      clearPassword();
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.saiEmailHoacMatKhau);
    }
  }

  
  void notidicationHandle() { 
    FirebaseMessaging.onMessage.listen((event) {
      print("hello ${event.notification!.title}");
      LocalNotificaiotnServece().showNotification(event);
    });
  }


  Future<void> upDatePassword() async {
    try {
      await authServices.updatePasswordInFirestore(email.text.trim(), password.text.trim());
    } catch (e) {
      print(e);
    }
  }

  //Google SignIn
  Future<void> googleSignIn() async {
    try {
      //loading
      FullScreenLoader.openLoadingDialog('Quá trình đang diễn ra...', ImageKey.loadingAnimation);

      final isconnected = network.isConnectedToInternet.value;
      if (!isconnected) {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
        return;
      } else {
        AuthServices.instance.signInWithGoogle();
      }
    } catch (e) {
      //TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.chuaNhapDuThongTin);
    }
  }

  //check null
  void checkIsEmpty(BuildContext context, TextEditingController emailController, TextEditingController passwordController) {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ETAlertDialog.showSuccessDialog(context, TTexts.chuaEmailHoacMatKhau, TTexts.thongBao);
    }
  }
}
