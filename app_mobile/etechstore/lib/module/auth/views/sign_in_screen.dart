import 'package:etechstore/module/auth/controller/sign_in_controller.dart';
import 'package:etechstore/module/auth/views/forget_password_screen.dart';
 import 'package:etechstore/module/auth/views/sign_up_screen.dart';
import 'package:etechstore/services/auth/auth_gate.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/validators/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SignInScreen extends GetView<SignInController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    return Form(
      key: controller.signInFormKey,
      child: Scaffold(
        body: ScreenUtilInit(
          builder: (context, child) => SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 60.h, left: 20.w, right: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Đăng nhập",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    TTexts.dangNhapBangTaiKhoanDaDangKy,
                    style: const TextStyle(color: TColros.grey, fontSize: 15),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TTexts.emai,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextFormField(
                          controller: controller.email,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email_outlined, color: TColros.grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1, color: TColros.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1, color: TColros.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: TTexts.nhapEmail,
                            hintStyle: const TextStyle(color: TColros.grey),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          TTexts.matKhau,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Obx(
                          () => TextFormField(
                            controller: controller.password,
                            obscureText: controller.hidePassword.value,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: TColros.grey,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1, color: TColros.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1, color: TColros.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              hintText: TTexts.nhapMatKhau,
                              hintStyle: const TextStyle(color: TColros.grey),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.hidePassword.value = !controller.hidePassword.value;
                                },
                                icon: Icon(controller.hidePassword.value ? Icons.visibility : Icons.visibility_off),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.to(const ForgetPasswordScreen());
                      },
                      child: Text(
                        TTexts.quenMatKhau,
                        style: TextStyle(
                          color: TColros.purple_line,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Center(
                      child: GestureDetector(
                    onTap: () {
                      controller.signIn();
                      controller.upDatePassword();
                    },
                    child: Container(
                      width: 330.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: TColros.purple_line,
                        border: Border.all(width: .5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          TTexts.dangNhap,
                          style: TextStyle(fontSize: ScreenUtil().setSp(15), color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )),
                  SizedBox(
                    height: 15.h,
                  ),
                  Center(
                    child: Text(
                      TTexts.hoacSuDungMotTrongCacLuaChonNay,
                      style: TextStyle(
                        color: TColros.grey,
                        fontSize: ScreenUtil().setSp(15),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await controller.googleSignIn();
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(border: Border.all(width: .5), borderRadius: BorderRadius.circular(30.r)),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 35.w),
                              width: 20.w,
                              height: 20.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(ImageKey.iconGoogle),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              TTexts.dangNhapBangGoogle,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(15),
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35.h,
                  ),
                  Center(
                    child: Row(
                      children: [
                        Text(
                          TTexts.banDaBietDeneTech,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(15),
                            color: TColros.black,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.to(const SignUpScreen());
                            },
                            child: Text(
                              TTexts.singUp,
                              style: TextStyle(
                                color: TColros.purple_line,
                                fontSize: ScreenUtil().setSp(15),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
