import 'package:etechstore/module/auth/views/forget_password_screen.dart';
import 'package:etechstore/module/auth/views/reset_password_screen.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/utlis/connection/network_manager.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();
  final NetworkManager network = Get.put(NetworkManager());
  final AuthServices authServices = Get.put(AuthServices());

  //Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  //Send Reset Password Email
  Future<void> sendPasswordResetEmail() async {
    try {
      final isconnected = network.isConnectedToInternet.value;
      if (!isconnected) {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
        return;
      } else {
//Loading
        FullScreenLoader.openLoadingDialog('Đang xử lý yêu cầu của bạn...', ImageKey.loadingAnimation);

        //Check Internet Connected

        //Form Validation
        if (!forgetPasswordFormKey.currentState!.validate()) {
          //   FullScreenLoader.stopLoading();
          return;
        }

        //Send Email to reset password
        await authServices.sendPasswordResetEmail(email.text.trim()).then(
              (value) => Get.to(
                () => ResetPasswordScreen(
                  email: email.text.trim(),
                ),
              ),
            );

        //Show Success Screen
        TLoaders.successSnackBar(title: 'Gửi Email', message: 'Đã gửi đường dẫn đến Email để đặt lại mặt khẩu'.tr);

        //Redirect
      }
    } catch (e) {
      FullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: e.toString());
    }
  }

  //reSendPassword
  Future<void> resendPasswordResetEmail(String email) async {
    try {
      final isconnected = network.isConnectedToInternet.value;
      if (!isconnected) {
        TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
        return;
      } else {
        //Loading
        FullScreenLoader.openLoadingDialog('Đang xử lý yêu cầu của bạn...', ImageKey.loadingAnimation);

        //Check Internet Connected

        //send Email to reset Password
        await authServices.sendPasswordResetEmail(email);

        //Remove Loader
        FullScreenLoader.stopLoading();

        //Show Success Screen
        TLoaders.successSnackBar(
          title: 'Gửi Email',
          message: 'Đã gửi đường dẫn đến Email để đặt lại mặt khẩu',
        );
      }
    } catch (e) {
      FullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: e.toString());
    }
  }
}
