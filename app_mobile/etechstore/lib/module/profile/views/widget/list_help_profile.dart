import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:etechstore/utlis/constants/colors.dart';

class ListHelpProfile extends StatelessWidget {
  ListHelpProfile({super.key, required this.icon, required this.text});

  Image icon;
  String text;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Container(
        margin: EdgeInsets.symmetric(horizontal: 33.w, vertical: 17.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 30,
              height: 30,
              child: icon,
            ),
            SizedBox(width: 30.w),
            Text(text, style: TColros.black_15_w400),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 15),
          ],
        ),
      ),
    );
  }
}
