import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/view/cart_screen.dart';
import 'package:etechstore/module/cart/view/widget/cart_icon_widget.dart';
import 'package:etechstore/module/orders/controller/orders_controller.dart';
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
    CartController controller = Get.put(CartController());
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TColros.purple_line,
          bottom: const TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.red,
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            tabs: [
              SizedBox(width: 110, child: Tab(text: "Chờ xác nhận")),
              SizedBox(width: 110, child: Tab(text: "Đang vận chuyển")),
              SizedBox(width: 90, child: Tab(text: "Thành công")),
              SizedBox(width: 90, child: Tab(text: "Đã hủy")),
             ],
          ),
          centerTitle: true,
          title: const Text('Đơn hàng', style: TextStyle(color: Colors.white, fontSize: 18)),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(const CartScreen());
                controller.isEditMode.value = false;
                controller.setTotalPriceAndCheckAll();
              },
              icon: Obx(
                () => Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: CartIconWithBadge(itemCount: controller.cartItems.length),
                ),
              ),
            )
          ],
        ),
        body: const TabBarView(
          children: [
            OrderIsPaid(),
            OrderIsShipped(),
            OrderCompleted(),
            OrderIsBeingShipped(),
           ],
        ),
      ),
    );
  }
}
