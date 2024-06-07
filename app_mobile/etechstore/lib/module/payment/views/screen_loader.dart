import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenLoader{
  static void openLoadingDialog(){
    showDialog(
      context: Get.overlayContext!, 
      barrierDismissible: false,
      builder: (_)=>PopScope(
        canPop: false,
        child: Container( 
          color: const Color(0xFF383CA0),
          width: double.infinity,
          height: double.infinity,
          child: const Column( 
            children: [
              SizedBox(height: 250,),
              CircularProgressIndicator()
            ],
          ),
        )
      )
    );
  }

  static stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }
}