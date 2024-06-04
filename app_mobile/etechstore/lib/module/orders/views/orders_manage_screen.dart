import 'package:etechstore/module/cart/view/cart_screen.dart';
import 'package:etechstore/module/orders/controller/orders_controller.dart';
import 'package:etechstore/module/orders/views/order_item_cancelled.dart';
import 'package:etechstore/module/orders/views/order_item_completed.dart';
import 'package:etechstore/module/orders/views/order_is_Paid.dart';
import 'package:etechstore/module/orders/views/order_is_shipped.dart';
import 'package:etechstore/module/orders/views/order_is_being_shipped.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderManageScreen extends StatelessWidget {
  const OrderManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersController ordersController = Get.put(OrdersController());
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.red,
            indicatorSize: TabBarIndicatorSize.tab, isScrollable: true,
            //  isScrollable: true,
            tabs: [
              SizedBox(width: 110, child: Tab(text: "Chờ xác nhận")),
              SizedBox(width: 110, child: Tab(text: "Đang vận chuyển")),
              SizedBox(width: 90, child: Tab(text: "Thành công")),
              SizedBox(width: 90, child: Tab(text: "Đã hủy")),
              SizedBox(width: 90, child: Tab(text: "Trả hàng")),
            ],
          ),
          centerTitle: true,
          title: const Text('Đơn hàng'),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(const CartScreen());
                },
                icon: const Image(image: AssetImage(ImageKey.iconCart), color: Colors.black))
          ],
        ),
        body: const TabBarView(
          children: [
            OrderIsPaid(),
            OrderIsShipped(),
            OrderCompleted(),
            OrderIsBeingShipped(),
            OrderCancelled(),
          ],
        ),
      ),
    );
  }
}
