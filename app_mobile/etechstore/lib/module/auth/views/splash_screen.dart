import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:etechstore/services/auth/auth_gate.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utlis/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AdaptiveThemeMode savedThemeMode;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 150.h),
          width: 400.w,
          color: TColros.purple_line,
          child: Column(
            children: [
              Image.asset(
                ImageKey.logoEtechStore,
                width: 250.w,
                height: 250.h,
              ),
              Text(
                TTexts.etechStore,
                style: TColros.white_25_bold,
              ),
              SizedBox(height: 250.h),
            ],
          ),
        ),
      ),
    );
  }
}
