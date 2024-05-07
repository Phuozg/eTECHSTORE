import 'package:etechstore/module/chat_with_admin/view/chat_home_screen.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class HomeScreen extends GetView {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthServices authServices = AuthServices();
    String? userId;
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser?.uid;
    }
    return ScreenUtilInit(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Get.to(ChatHomePageScreen());
              },
              icon: Image.asset(
                ImageKey.iconMessage,
                width: 250.w,
                height: 250.h,
              ),
            )
          ],
          title: const Text("Home"),
        ),
        body: Column(children: [
          IconButton(
            onPressed: () {
              authServices.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
          ElevatedButton(
              onPressed: () {
                print(userId);
              },
              child: const Text("UID"))
        ]),
      ),
    );
  }
}
