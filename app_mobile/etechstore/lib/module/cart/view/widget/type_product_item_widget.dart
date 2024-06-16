import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypeProductItemWidget extends StatefulWidget {
  String selectedColor;
  String selectedConfig;
  TypeProductItemWidget({super.key, required this.selectedColor, required this.selectedConfig});

  @override
  State<TypeProductItemWidget> createState() => _TypeProductItemWidgetState();
}

class _TypeProductItemWidgetState extends State<TypeProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 2.5,
        ),
        alignment: Alignment.center,
        width: 163.w,
        height: 18.h,
        color: const Color.fromARGB(58, 189, 189, 189),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Phân loại:",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12.sp),
            ),
            Text(
              '${widget.selectedColor}  -',
              style: TextStyle(color: Colors.black, fontSize: 12.sp),
            ),
            Text(
              widget.selectedConfig,
              style: TextStyle(color: Colors.black, fontSize: 12.sp),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 9.h),
                child: const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: 20,
                ))
          ],
        ),
      ),
    );
  }
}
