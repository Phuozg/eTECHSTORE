import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:etechstore/module/auth/controller/sign_in_controller.dart';
import 'package:etechstore/module/auth/views/sign_in_screen.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/bottom_nav_bar/nav_menu.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/services/notifi_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final SignInController authController = Get.put(SignInController());
  @override
  void initState() {
    super.initState();
    final SignInController authController = Get.put(SignInController());
    authController.checkSignIn();
    LocalNotificaiotnServece().uploadFcmToken();
    notidicationHandle();
  }

  void notidicationHandle() {
    FirebaseMessaging.onMessage.listen((event) {
       LocalNotificaiotnServece().showNotification(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
