import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:etechstore/utlis/constants/colors.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key, required this.title, required this.text});

  String title;
  String text;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Container(
        padding: EdgeInsets.only(left: 23.w, right: 23.w),
        width: double.infinity,
        height: 50.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(color: Color(0xFF848484), fontSize: 14),
            ),
            SizedBox(width: 25.w),
            Container(
              alignment: Alignment.centerLeft,
              width: 200,
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 15
            ),
          ],
        ),
      ),
    );
  }
}
