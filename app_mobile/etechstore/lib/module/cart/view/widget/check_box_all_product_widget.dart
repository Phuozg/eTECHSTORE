import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CheckBoxAllProductWidget extends StatefulWidget {
  const CheckBoxAllProductWidget({super.key});

  @override
  State<CheckBoxAllProductWidget> createState() => _CheckBoxAllProductWidgetState();
}

class _CheckBoxAllProductWidgetState extends State<CheckBoxAllProductWidget> {
  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Row(
        children: [
          Transform.scale(
            scale: 1,
            child: Checkbox(
              checkColor: Colors.white,
              activeColor: Colors.deepOrange,
              value: controller.isSelectAll.value,
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              onChanged: (val) {
                setState(() {
                  controller.toggleSelectAll();
                });
              },
            ),
          ),
          Text(
            "Tất cả",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
