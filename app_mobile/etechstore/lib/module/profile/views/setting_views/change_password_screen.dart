import 'package:etechstore/module/auth/controller/sign_in_controller.dart';
import 'package:etechstore/module/auth/controller/sign_up_controller.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/validators/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePassWordScreen extends StatelessWidget {
  const ChangePassWordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerSingIn = Get.put(SignInController());
    final controllerSignUp = Get.put(SignUpController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
        iconTheme: const IconThemeData(color: TColros.purple_line),
        centerTitle: true,
      ),
      body: ScreenUtilInit(
        child: Container(
          margin: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  TTexts.matKhau,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Obx(
                () => TextFormField(
                  controller: controllerSignUp.currentPasswordController,
                  obscureText: controllerSingIn.hidePassword.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: TColros.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: TColros.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: TColros.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: TTexts.nhapMatKhau,
                    hintStyle: const TextStyle(color: TColros.grey),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controllerSingIn.hidePassword.value = !controllerSingIn.hidePassword.value;
                      },
                      icon: Icon(controllerSingIn.hidePassword.value ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  TTexts.nhapMatKhauMoi,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Obx(
                () => TextFormField(
                  controller: controllerSignUp.newPasswordController,
                  obscureText: controllerSignUp.hideConformPassword.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: TColros.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: TColros.grey),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: TColros.grey),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    hintText: TTexts.nhapMatKhauMoi,
                    hintStyle: const TextStyle(
                      color: TColros.grey,
                    ),
                    fillColor: Colors.grey,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controllerSignUp.hideConformPassword.value = !controllerSignUp.hideConformPassword.value;
                      },
                      icon: Icon(controllerSignUp.hideConformPassword.value ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  TTexts.nhapLaiMatKhau,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Obx(
                () => TextFormField(
                  controller: controllerSignUp.confirmPasswordController,
                  obscureText: controllerSignUp.hideConformPassword.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: TColros.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: TColros.grey),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: TColros.grey),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    hintText: TTexts.nhapLaiMatKhau,
                    hintStyle: const TextStyle(
                      color: TColros.grey,
                    ),
                    fillColor: Colors.grey,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controllerSignUp.hideConformPassword.value = !controllerSignUp.hideConformPassword.value;
                      },
                      icon: Icon(controllerSignUp.hideConformPassword.value ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: TColros.purple_line,
                        padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 10),
                      ),
                      onPressed: () {
                        controllerSignUp.changePassword();
                      },
                      child: const Text("Xác nhận", style: TextStyle(color: Colors.white))))
            ],
          ),
        ),
      ),
    );
  }
}
