import 'package:etechstore/module/home/views/product.dart';
import 'package:etechstore/module/orders/controller/orders_controller.dart';
import 'package:etechstore/module/orders/views/detail_order_screen.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/helpers/line/line_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderIsEmpty extends StatefulWidget {
  const OrderIsEmpty({super.key});

  @override
  State<OrderIsEmpty> createState() => _OrderIsEmptyState();
}

class _OrderIsEmptyState extends State<OrderIsEmpty> {
  final OrdersController controller = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenUtilInit(
        builder: (context, child) => Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  ImageKey.cartEmpty,
                  width: 100.w,
                  height: 100.h,
                ),
                SizedBox(height: 20.h),
                const Center(
                    child: Text(
                  "Chưa có đơn hàng nào",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
