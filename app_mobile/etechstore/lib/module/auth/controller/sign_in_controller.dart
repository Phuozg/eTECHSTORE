import 'package:etechstore/module/auth/views/sign_in_screen.dart';
import 'package:etechstore/module/auth/views/veryfi_phone_number_screen.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/services/auth/auth_gate.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/utlis/connection/network_manager.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/dialog/alert_dialog.dart';
import 'package:etechstore/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find();
  final AuthServices authServices = Get.put(AuthServices());
  final NetworkManager network = Get.put(NetworkManager());

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
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

//
  Future<void> checkSignIn() async {
    await authServices.checkLoginStatus();
  }

  Future<void> signOut() async {
    await authServices.signOut();
  }

  //SignIn
  Future<void> signIn() async {
    final isconnected = network.isConnectedToInternet.value;
    try {
      if (!isconnected) {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
        return;
      } else {
        await authServices.signInWithEmailPassword(email.text.trim(), password.text.trim());
        await authServices.updatePasswordInFirestore(email.text.trim(), password.text.trim());
      }
    } catch (e) {
      if (email.text.isEmpty || password.text.isEmpty) {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.chuaNhapDuThongTin);
      } else {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.saiEmailHoacMatKhau);
      }
    }
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

  //SignIn with Phone
  Future<void> signInPhoneNumber() async {
/*     try {
      //loading
      FullScreenLoader.openLoadingDialog('Quá trình đang diễn ra...', ImageKey.loadingAnimation);

      //check Internet connected
      final isconnected = network.isConnectedToInternet.value;
      if (!isconnected) {
        return;
      }

      //validation
      if (!signInFormKey.currentState!.validate()) {
        return;
      }

      //send OTP
      authServices.signInWithPhoneNumber(
        60,
        phoneNumber.text.trim(),
        '${Get.off(VerifyPhoneNumberScreen(phoneNumber: phoneNumber.text.trim(), verifyId: verify.toString()))}',
      );
    } catch (e) {
      if (phoneNumber.text.isEmpty) {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: Text(TTexts.chuaNhapSoDienThoai));
      } else {
        e.toString();
      }
    } */
  }

  //Verifi PhoneNumber
  Future<void> verifyPhoneNumber() async {
    /*   try {
      //Loading
      FullScreenLoader.openLoadingDialog('Đang xử lý yêu cầu của bạn...', ImageKey.loadingAnimation);

      //Check Internet Connected
      final isconnected = network.isConnectedToInternet.value;
      if (isconnected) {
        return;
      }

      //Form Validation
      if (!signInFormKey.currentState!.validate()) {
        return;
      }

      //Send Email to reset password
      await authServices.verifyPhoneNumber(verify.value, code.value)!.then((value) => Get.off(const HomeScreen()));

      //Redirect
    } catch (e) {
      if (verify.value.isEmpty || code.value.isEmpty) {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: Text(TTexts.maOTPThieu));
      } else {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: Text(TTexts.maXacNhanOTPChuaDung));
      }
    } */
  }
}
