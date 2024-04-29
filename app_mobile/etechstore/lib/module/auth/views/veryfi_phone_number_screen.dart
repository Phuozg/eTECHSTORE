import 'package:etechstore/module/auth/controller/sign_in_controller.dart';
import 'package:etechstore/module/auth/controller/sign_up_controller.dart';
import 'package:etechstore/module/auth/views/sign_in_with_phone_number_screen.dart';
import 'package:etechstore/module/auth/views/sign_in_with_phone_number_screen.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

class VerifyPhoneNumberScreen extends GetView<SignUpController> {
  VerifyPhoneNumberScreen({super.key, required this.phoneNumber, required this.verifyId});
  String phoneNumber;
  final String verifyId;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    final controller = Get.put(SignInController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                ImageKey.smsPhoneAnimation,
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 8,
                repeat: true,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                TTexts.nhapMaOTP,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                TTexts.banCanDangKySoDienThoai,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                onCompleted: (pin) => print(pin),
                onChanged: (value) {
                  controller.code.value = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      controller.verifyPhoneNumber();
                    },
                    child: Text(TTexts.xacMinhSoDienThoai)),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Get.off(const SignInPhoneNumberScreen());
                      },
                      child: Text(
                        TTexts.chinhSuaSoDienThoai,
                        style: const TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
