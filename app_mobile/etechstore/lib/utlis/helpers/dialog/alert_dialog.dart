import 'package:etechstore/utlis/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ETAlertDialog {
  static void showSuccessDialog(BuildContext context, String content, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScreenUtilInit(
          child: AlertDialog(
            title: Text(title),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(content, style: TColros.black_14_w600),
            ),
            actions: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: TColros.purple_line,
                      border: Border.all(width: .5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text('Đóng',
                        style: TextStyle(
                          color: Color.fromARGB(232, 255, 255, 255),
                        )),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
