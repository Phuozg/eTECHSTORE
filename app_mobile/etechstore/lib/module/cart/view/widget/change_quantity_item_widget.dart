import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangeQuantityItemWidget extends StatefulWidget {
  ChangeQuantityItemWidget({super.key, required this.quantity, required this.item});
  int quantity;
  CartModel item;
  @override
  State<ChangeQuantityItemWidget> createState() => _ChangeQuantityItemWidgetState();
}

class _ChangeQuantityItemWidgetState extends State<ChangeQuantityItemWidget> {
  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.put(CartController());

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
                setState(() {
                  if (widget.quantity > 1) {
                    widget.quantity--;
                    widget.item.soLuong = widget.quantity;
                    controller.updateCartItem(widget.item);
                  }
                });
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
                '${widget.item.soLuong}',
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
                //     controller.toggleItemSelection(item.id);
                setState(() {
                  widget.quantity++;
                  widget.item.soLuong = widget.quantity;
                  controller.updateCartItem(widget.item);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
