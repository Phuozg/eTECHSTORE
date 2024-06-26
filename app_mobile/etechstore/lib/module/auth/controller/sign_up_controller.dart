import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/auth/views/sign_in_screen.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/utlis/connection/network_manager.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/dialog/alert_dialog.dart';
import 'package:etechstore/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final newPassword = TextEditingController();
  Rx<bool> checkEmail = false.obs;

//change Password
  var currentPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> changePassword() async {
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: 'Mật khẩu mới và xác nhận mật khẩu không khớp.');
      return;
    }

    try {
      isLoading.value = true;
      bool isChanged = await authServices.changePassword(currentPassword, newPassword);
      if (isChanged) {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: 'Đổi mật khẩu thất bại');
      } else {
        clearPassword();
        TLoaders.successSnackBar(title: 'Thông báo', message: 'Đổi mật khẩu thành công.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Đổi mật khẩu thất bại: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearPassword() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    email.clear();
    password.clear();
    conformPassword.clear();
    fullName.clear();
  }

  //SignUp
  Future<void> signUp() async {
    try {
      final isconnected = network.isConnectedToInternet.value;
      if (!isconnected) {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
        return;
      } else {
        //loading
        FullScreenLoader.openLoadingDialog('Quá trình đang diễn ra...', ImageKey.loadingAnimation);

        //check Internet connected
        final isconnected = network.isConnectedToInternet.value;
        if (!isconnected) {
          //    FullScreenLoader.stopLoading();
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

            clearPassword();
          } else {
            TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.matKhauKhongTrungKhop);
            return;
          }
        }

        //showSuccess
        TLoaders.successSnackBar(title: 'Đăng ký tài khoản thành công', message: 'Hãy sử dụng tài khoản đã đăng ký để tiếp tục.');
      }

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
      FullScreenLoader.openLoadingDialog('Quá trình đang diễn ra...', ImageKey.loadingAnimation);

      AuthServices.instance.signInWithGoogle();
    } catch (e) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: TTexts.chuaNhapDuThongTin);
    } finally {
      FullScreenLoader.stopLoading();
    }
  }
}
