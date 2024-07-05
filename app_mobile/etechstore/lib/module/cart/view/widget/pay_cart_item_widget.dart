import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/home/views/product.dart';
import 'package:etechstore/module/payment/views/order_screen.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PayCartItem extends StatelessWidget {
  const PayCartItem({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.put(CartController());
    ProductSampleController sampleCOntroller = Get.put(ProductSampleController());
    return ScreenUtilInit(builder: (context, child) {
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6.h),
              Text("Tổng thanh toán", style: TextStyle(fontSize: 10.sp)),
              Obx(
                () => Text(
                  priceFormat(controller.totalPrice.value.toInt()),
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Obx(
            () => GestureDetector(
              onTap: controller.selectedItemCount.value >= 1
                  ? () {
                      sampleCOntroller.getProduct();
                      sampleCOntroller.getCarts();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderScreen()));
                    }
                  : null,
              child: Obx(
                () => Container(
                  alignment: Alignment.center,
                  width: 114.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    color: controller.selectedItemCount >= 1 ? const Color(0xFFCB291C) : Colors.grey,
                  ),
                  child: Text(
                    "Thanh toán (${controller.selectedItemCount})",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}
