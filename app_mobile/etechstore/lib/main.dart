import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/firebase_options.dart';
import 'package:etechstore/module/auth/controller/sign_in_controller.dart';
import 'package:etechstore/module/auth/views/sign_in_screen.dart';
import 'package:etechstore/module/auth/views/splash_screen.dart';
import 'package:etechstore/module/bottom_nav_bar/nav_menu.dart';
 import 'package:etechstore/module/orders/controller/orders_controller.dart';
import 'package:etechstore/module/product_detail/controller/product_controller.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/wishlist/controller/wishlist_controller.dart';
import 'package:etechstore/services/auth/auth_gate.dart';
import 'package:etechstore/services/auth/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material();
  };
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
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
              home: AuthGate(),
              getPages: [
                GetPage(name: '/navMenu', page: () => const NavMenu()),
                GetPage(name: '/SignInScreen', page: () => const SignInScreen()),
              ],
            )),
  );
}
