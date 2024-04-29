import 'package:etechstore/module/auth/views/sign_in_screen.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/utlis/connection/network_manager.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/dialog/alert_dialog.dart';
import 'package:etechstore/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final NetworkManager network = Get.put(NetworkManager());
  final AuthServices authServices = Get.put(AuthServices());

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  //Variables
  final hidePassword = true.obs;
  final hideConformPassword = true.obs;
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final conformPassword = TextEditingController();
  Rx<bool> checkEmail = false.obs;

  //SignUp
  void signUp() async {
    try {
      //loading
      FullScreenLoader.openLoadingDialog('Quá trình đang diễn ra...', ImageKey.loadingAnimation);

      //check Internet connected
      final isconnected = await network.isConneted();
      if (!isconnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      //validation
      if (!signUpFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      //Check Email
      bool emailExists = await authServices.checkEmailExists(email.text.trim());
      if (emailExists) {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.taiKhoanDaTonTai);
        return;
      } else {
        //SignUp
        if (password.text == conformPassword.text) {
          await authServices.signUpWithEmailPassword(email.text.trim(), password.text.trim(), fullName.text.trim());
        } else {
          TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.chuaNhapDuThongTin);
          return;
        }
      }

      //showSuccess
      TLoaders.successSnackBar(title: 'Đăng ký tài khoản thành công', message: 'Hãy sử dụng tài khoản đã đăng ký để tiếp tục.');

      /*   //Move to LoginScreen
      Get.offAll(const SignInScreen()); */
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.chuaNhapDuThongTin);
    } finally {
      FullScreenLoader.stopLoading();
    }
  }

  //Google SignIn
  Future<void> googleSignIn() async {
    try {
      final isConnected = await NetworkManager.instance.isConneted();
      final userCredentials = AuthServices.instance.signInWithGoogle();
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.chuaNhapDuThongTin);
    } finally {
      FullScreenLoader.stopLoading();
    }
  }
}
