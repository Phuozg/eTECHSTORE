import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:etechstore/firebase_options.dart';
import 'package:etechstore/module/auth/views/sign_in_screen.dart';
import 'package:etechstore/module/bottom_nav_bar/nav_menu.dart';
import 'package:etechstore/module/payment/views/success_screen.dart';
import 'package:etechstore/services/auth/auth_gate.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:etechstore/services/notifi_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material();
  };
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotificaiotnServece().requestPermisstion();
  await LocalNotificaiotnServece().init();
  final fcmToken = await FirebaseMessaging.instance.getToken();

  print("FCMToken $fcmToken");
  runApp(
    AdaptiveTheme(
        light: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: Colors.blue,
        ),
        dark: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
        ),
        initial: savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (light, dark) => GetMaterialApp(
              initialBinding: BindingsBuilder(() {
                Get.put(AuthServices());
              }),
              theme: light,
              darkTheme: dark,
              debugShowCheckedModeBanner: false,
              home: const AuthGate(),
              getPages: [
                GetPage(name: '/successPayment', page: () => const SuccessScreen()),
                GetPage(name: '/navMenu', page: () => const NavMenu()),
                GetPage(name: '/SignInScreen', page: () => const SignInScreen()),
              ],
            )),
  );
}
