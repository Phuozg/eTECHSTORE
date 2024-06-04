import 'package:etechstore/utlis/helpers/line/line_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Thiết lập tài khoản"),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: const Color.fromARGB(49, 217, 217, 217),
                  padding: EdgeInsets.only(left: 23.w),
                  width: double.infinity,
                  height: 30.h,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Tài khoản của tôi",
                        style: TextStyle(color: Color.fromARGB(255, 105, 104, 104), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 23.w, right: 23.w),
                  width: double.infinity,
                  height: 40.h,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Tài khoản",
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF848484)),
                    ],
                  ),
                ),
                Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 1),
                Container(
                  padding: EdgeInsets.only(left: 23.w, right: 23.w),
                  width: double.infinity,
                  height: 40.h,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Bảo mật",
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF848484)),
                    ],
                  ),
                ),
                Container(
                  color: const Color.fromARGB(49, 217, 217, 217),
                  padding: EdgeInsets.only(left: 23.w),
                  width: double.infinity,
                  height: 30.h,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Cài đặt",
                        style: TextStyle(color: Color.fromARGB(255, 105, 104, 104), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 23.w, right: 23.w),
                  width: double.infinity,
                  height: 40.h,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Ngôn Ngữ / Language",
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF848484)),
                    ],
                  ),
                ),
                Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 1),
                Container(
                  padding: EdgeInsets.only(left: 23.w, right: 23.w),
                  width: double.infinity,
                  height: 40.h,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Giới thiệu",
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF848484)),
                    ],
                  ),
                ),
                  Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
