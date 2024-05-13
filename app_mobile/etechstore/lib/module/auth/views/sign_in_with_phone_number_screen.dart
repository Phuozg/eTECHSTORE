import 'package:country_picker/country_picker.dart';
import 'package:etechstore/module/auth/controller/sign_in_controller.dart';
import 'package:etechstore/module/auth/views/veryfi_phone_number_screen.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/validators/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SignInPhoneNumberScreen extends GetView<SignInController> {
  const SignInPhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    return Scaffold(
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
              const Text(
                "Xác thực số điện thoại",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Chúng tôi cần số điện thoại của bạn để đăng ký và tiếp tục sử dụng!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        style: const TextStyle(fontSize: 18),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                        ],
                        controller: controller.phoneNumber,
                        onChanged: (value) {
                          controller.phoneNumber.text = value;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Số điện thoại",
                            prefixIcon: Container(
                              padding: const EdgeInsets.only(top: 13, right: 5),
                              child: InkWell(
                                onTap: () {
                                  showCountryPicker(
                                    countryListTheme: const CountryListThemeData(bottomSheetHeight: 500),
                                    context: context,
                                    onSelect: (value) {
                                      controller.selectCountry = value;
                                    },
                                  );
                                },
                                child: Text(
                                  "${controller.selectCountry.flagEmoji} +${controller.selectCountry.phoneCode}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            suffixIcon: controller.phoneNumber.text.length > 8
                                ? Container(
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                                    margin: const EdgeInsets.all(10),
                                    child: const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  )
                                : null),
                      ),
                    )
                  ],
                ),
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
                      controller.phoneNumber.text.length > 8 ? controller.signInPhoneNumber() : null;
                    },
                    child: const Text("Gửi mã OTP")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
