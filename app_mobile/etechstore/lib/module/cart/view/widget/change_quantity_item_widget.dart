import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangeQuantityItemWidget extends StatelessWidget {
  final CartModel item;

  const ChangeQuantityItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.put(CartController());
    controller.initializeQuantity(item);

    return ScreenUtilInit(
      builder: (context, child) => Container(
        alignment: Alignment.center,
        width: 60.w,
        height: 16.5.h,
        decoration: BoxDecoration(
          border: Border.all(width: .5.w),
          borderRadius: BorderRadius.circular(5.r),
          color: const Color.fromARGB(57, 187, 184, 184),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              child: Container(alignment: Alignment.center, child: const Icon(Icons.remove, size: 18)),
              onTap: () {
                controller.decreaseQuantity(item.id);
              },
            ),
            Container(
              height: double.infinity,
              color: Colors.black,
              width: .5,
            ),
            Container(
              padding: EdgeInsets.only(left: 3.0.w, right: 4.w),
              alignment: Alignment.topCenter,
              child: Text(
                '${item.soLuong}',
                style: TextStyle(fontSize: 13.sp),
              ),
            ),
            Container(
              height: double.infinity,
              color: Colors.black,
              width: .5,
            ),
            GestureDetector(
              child: Container(height: 15.h, alignment: Alignment.topCenter, child: Icon(Icons.add, size: 17.sp)),
              onTap: () {
                controller.increaseQuantity(item.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
