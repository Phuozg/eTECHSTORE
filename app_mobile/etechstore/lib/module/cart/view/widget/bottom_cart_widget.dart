import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomCartWidget extends StatefulWidget {
  const BottomCartWidget({super.key});

  @override
  State<BottomCartWidget> createState() => _BottomCartWidgetState();
}

class _BottomCartWidgetState extends State<BottomCartWidget> {
  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => Row(
        children: [
          Row(
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
                    controller.toggleSelectAll();
                  },
                ),
              ),
              Text(
                "Tất cả",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
              ),
            ],
          ),
          SizedBox(width: 39.w),
          GestureDetector(
            onTap: () {
              // Thêm vào yêu thích
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 7.h, vertical: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 3.5.w),
              decoration: BoxDecoration(border: Border.all(width: .5, color: Colors.redAccent), borderRadius: BorderRadius.circular(5.r)),
              child: Text(
                "Lưu vào yêu thích",
                style: TextStyle(fontSize: 12.sp, color: Colors.redAccent),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              List<CartModel> itemsToRemove = [];
              controller.selectedItems.forEach((id, isSelected) {
                if (isSelected) {
                  CartModel? item = controller.cartItems.firstWhereOrNull((item) => item.id == id);
                  if (item != null) {
                    itemsToRemove.add(item);
                  }
                }
              });

              // Xóa các mục đã chọn khỏi giỏ hàng
              for (var item in itemsToRemove) {
                controller.removeItemFromCart(
                  item,
                );
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 7.h, vertical: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(width: .5), borderRadius: BorderRadius.circular(5.r)),
              child: Row(
                children: [
                  Text(
                    "Delete",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
