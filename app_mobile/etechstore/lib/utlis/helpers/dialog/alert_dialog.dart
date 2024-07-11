import 'package:etechstore/utlis/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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

  static showConfirmPopup({required title, required String description, VoidCallback? onDismissed, VoidCallback? conFirm}) {
    showDialog(
      context: Get.context!,
      builder: (context) => _showComfirmPopup(title: title, description: description, onDismissed: onDismissed, conFirm: conFirm),
    );
  }

  static _showComfirmPopup({required String title, required String description, VoidCallback? onDismissed, VoidCallback? conFirm}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          width: MediaQuery.of(Get.context!).size.width / 1.5,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: const Icon(Icons.error_outline, color: Colors.red, size: 50.0),
              ),
              const SizedBox(height: 20),
              Material(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Material(
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Color.fromARGB(188, 158, 158, 158)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 30),
                        backgroundColor: const Color.fromARGB(255, 197, 205, 220),
                        shadowColor: const Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (onDismissed != null) {
                          onDismissed();
                        }
                        Navigator.of(Get.context!).pop();
                      },
                      child: const Text('Đóng', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 30),
                        backgroundColor: TColros.purple_line,
                        shadowColor: const Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (conFirm != null) {
                          conFirm();
                        }
                        Navigator.of(Get.context!).pop();
                      },
                      child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
