import 'package:etechstore/module/profile/controller/profile_controller.dart';
import 'package:etechstore/module/profile/model/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditScreen extends StatelessWidget {
  EditScreen({super.key, required this.text, required this.title, required this.func, required this.controller, required this.profile});
  String text;
  String title;
  VoidCallback? func;
  TextEditingController controller;
  String profile;
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
            body: Container(
              margin: EdgeInsets.all(5),
              child: TextFormField(keyboardType: profile =='' ?TextInputType.number:null,
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
              ),
            )));
  }
}
