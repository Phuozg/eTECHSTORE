import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/home/views/home_screen.dart' as homeScreen;
import 'package:etechstore/module/home/views/product.dart';
import 'package:etechstore/module/orders/controller/orders_controller.dart';
import 'package:etechstore/module/orders/model/detail_orders.dart';
import 'package:etechstore/module/orders/model/orders_model.dart';
import 'package:etechstore/module/orders/views/detail_order_screen.dart';
import 'package:etechstore/module/orders/views/widget/order_isEmpty._widget.dart';
import 'package:etechstore/module/orders/views/widget/order_item_widget.dart';
import 'package:etechstore/module/product_detail/controller/product_controller.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/helpers/line/line_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderIsPaid extends StatelessWidget {
  const OrderIsPaid({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersController controller = Get.put(OrdersController());
        final FirebaseAuth auth = FirebaseAuth.instance;
 
    return ScreenUtilInit(
      builder: (context, child) => StreamBuilder<List<OrdersModel>>(
          stream: controller.getOrder(),
          builder: (context, snapshotDonHang) {
            if (!snapshotDonHang.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            String userId = auth.currentUser?.uid ?? '';
            List<OrdersModel> donHangs = snapshotDonHang.data!;
            List<OrdersModel> fillterOrder = donHangs.where((order) => order.maKhachHang == userId && order.isPaid).toList();
            if (fillterOrder.isEmpty) {
              return Container(
                child: Column(
                  children: [
                    SizedBox(height: 50.h),
                    Image.asset(
                      ImageKey.cartEmpty,
                      width: 100.w,
                      height: 100.h,
                    ),
                    SizedBox(height: 20.h),
                    Center(
                        child: Text(
                      "Chưa có đơn hàng nào",
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w300),
                    )),
                  ],
                ),
              );
            }

            return StreamBuilder<List<DetailOrders>>(
              stream: controller.fetchData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<DetailOrders> ctDonHangs = snapshot.data!;
                  Set<String> displayedOrders = <String>{};

                  List<DetailOrders> filteredCTDonHangs =
                      ctDonHangs.where((ctDonHang) => fillterOrder.any((order) => order.id == ctDonHang.maDonHang)).where((ctDonHang) {
                    if (displayedOrders.contains(ctDonHang.maDonHang)) {
                      return false;
                    } else {
                      displayedOrders.add(ctDonHang.maDonHang);
                      return true;
                    }
                  }).toList();
                  return Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          (controller.itemsToShow.value >= filteredCTDonHangs.length) ? filteredCTDonHangs.length : controller.itemsToShow.value + 1,
                      itemBuilder: (context, index) {
                        DetailOrders item = filteredCTDonHangs[index];
                        var product = controller.products[item.maMauSanPham['MaSanPham']];
                        OrdersModel? order = fillterOrder.firstWhereOrNull((order) => order.id == item.maDonHang);
                        if (order == null) {
                          return Container(
                            child: Text('Order not found for detail order ${item.maDonHang}.'),
                          );
                        }

                        return order.isPaid == true
                            ? OrderdetailWdiet(
                                detail: item,
                                order: order,
                                product: product!,
                                status: "Chờ xác nhận",
                                color: TColros.purple_line,
                              )
                            : OrderIsEmpty();
                      },
                    ),
                  );
                }
              },
            );
          }),
    );
  }
}
