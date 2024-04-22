import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:etechstore/module/views/auth/sign_in_screen.dart';
import 'package:etechstore/module/views/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthGate extends StatelessWidget {
  final AdaptiveThemeMode savedThemeMode;

   AuthGate({super.key,required this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp( 


      home: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return const SignInScreen();
            }
          },
        ),
      ),
    );
  }
}
