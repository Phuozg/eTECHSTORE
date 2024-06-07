import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:etechstore/firebase_options.dart';
import 'package:etechstore/module/auth/views/splash_screen.dart';
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
              theme: light,
              darkTheme: dark,
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
            )),
  );
}
