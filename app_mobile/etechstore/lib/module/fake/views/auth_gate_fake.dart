/* import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:etechstore/module/auth/views/sign_in_screen.dart';
import 'package:etechstore/module/cart/view/prodct_view.dart';
import 'package:etechstore/module/fake/views/auth_view.dart';
import 'package:etechstore/module/home/home_screen.dart';
import 'package:etechstore/module/bottom_nav_bar/nav_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_view.dart';

class AuthGateFake extends StatelessWidget {
  const AuthGateFake({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomeView();
            } else {
              return LoginView();
            }
          },
        ),
      ),
    );
  }
}
 */