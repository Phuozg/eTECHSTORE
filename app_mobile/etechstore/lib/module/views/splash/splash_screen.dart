import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../gen/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onbording()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        body: Container(
          width: 400.w,
          color: AppTheme.purple_line,
          child: Column(
            children: [
              SizedBox(height: 100.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Assets.images.logoEtech.image(width: 175.w, height: 160.h),
              ),
              SizedBox(height: 50.h),
              const Text("eTECHSTORE", style: AppTheme.white_32_bold),
              const Text("Cái quần gì cũng có ở đây", style: AppTheme.white_14),
              SizedBox(height: 280.h),
    
            ],
          ),
        ),
      ),
    );
  }
}
