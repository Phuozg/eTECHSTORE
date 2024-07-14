import 'package:etechstore/module/profile/controller/profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditScreen extends StatelessWidget {
  EditScreen({super.key, required this.text, required this.title, required this.func, required this.controller});
  String text;
  String title;
  VoidCallback? func;
  TextEditingController controller;
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    profileController.fetchProfilesStream(user!.uid);
    return ScreenUtilInit(
        builder: (context, child) => Scaffold(
            appBar: AppBar(
              title: Text(title),
              centerTitle: true,
              actions: [
                TextButton(
                    onPressed: () {
                      if (func != null) {
                        func!();
                        Navigator.pop(context);
                      }
                    },
                    child: Obx(
                      () => Text(
                        "Lưu",
                        style: TextStyle(color: profileController.isTextValid == true ? Colors.redAccent : Colors.grey),
                      ),
                    )),
              ],
            ),
            body: TextFormField(
              onChanged: (text) {
                profileController.validateText(text);
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(borderSide: BorderSide(width: .5)),
                label: Text(
                  text,
                  style: const TextStyle(color: Color(0xFF848484)),
                ),
              ),
              controller: controller,
            )));
  }
}
