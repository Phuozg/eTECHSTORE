import 'package:etechstore/module/auth/controller/forget_password_controller.dart';
import 'package:etechstore/module/auth/views/reset_password_screen.dart';
import 'package:etechstore/module/auth/views/sign_in_screen.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etechstore/utlis/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Quên mật khẩu", style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 15),
              Text("Nhập email để đổi mật khẩu mới", style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 15),
              Form(
                key: controller.forgetPasswordFormKey,
                child: TextFormField(
                    controller: controller.email,
                    validator: TValidator.validateEmail,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: TColros.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: TColros.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: TTexts.nhapEmail,
                      prefixIcon: const Icon(Icons.email),
                    )),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      //FullScreenLoader.openLoadingDialog('Quá trình đang diễn ra...', ImageKey.loadingAnimation);
                      //Get.off(() => ResetPasswordScreen(email: controller.sendPasswordResetEmail()));
                      controller.sendPasswordResetEmail();
                    },
                    child: const Text("Gửi")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
