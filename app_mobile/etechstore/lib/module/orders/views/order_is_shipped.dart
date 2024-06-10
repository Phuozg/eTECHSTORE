import 'package:etechstore/module/home/views/home_screen.dart' as homeScreen;
import 'package:etechstore/module/home/views/product.dart';
import 'package:etechstore/module/orders/controller/orders_controller.dart';
import 'package:etechstore/module/orders/model/detail_orders.dart';
import 'package:etechstore/module/orders/model/orders_model.dart';
import 'package:etechstore/module/orders/views/detail_order_screen.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/helpers/line/line_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderIsShipped extends StatelessWidget {
  const OrderIsShipped({super.key});

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
            List<OrdersModel> fillterOrder = donHangs.where((order) => order.maKhachHang == userId).toList();
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

                  List<DetailOrders> filteredCTDonHangs =
                      ctDonHangs.where((ctDonHang) => fillterOrder.any((order) => order.id == ctDonHang.maDonHang)).toList();
                  return ListView.builder(
                    itemCount: fillterOrder.length,
                    itemBuilder: (context, index) {
                      DetailOrders item = filteredCTDonHangs[index];

                      var productt = controller.products[item.maMauSanPham['MaSanPham']];
                      OrdersModel? order = fillterOrder.firstWhereOrNull((order) => order.id == item.maDonHang);
                      if (order == null) {
                        return Container(
                          child: Text('Order not found for detail order ${item.maDonHang}.'),
                        );
                      }
                      print(order.isBeingShipped);
                      return order.isShipped == true
                          ? Container(
                              height: 150.h,
                              margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: .5,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(DetailOrderSreen());
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(width: 3.w),
                                            productt?.thumbnail != null
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Get.to(DetailOrderSreen());
                                                    },
                                                    child: FadeInImage.assetNetwork(
                                                      image: productt!.thumbnail.toString(),
                                                      placeholder: ImageKey.whiteBackGround,
                                                      width: 60.w,
                                                      height: 60.h,
                                                      fit: BoxFit.cover,
                                                      imageErrorBuilder: (context, error, stackTrace) {
                                                        return Center(
                                                            child: Image.asset(
                                                          ImageKey.whiteBackGround,
                                                          width: 60.w,
                                                          height: 60.h,
                                                          fit: BoxFit.cover,
                                                        ));
                                                      },
                                                    ))
                                                : Container(),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                productt?.ten != null
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          //
                                                          Get.to(DetailOrderSreen());
                                                        },
                                                        child: SizedBox(
                                                          width: 140.w,
                                                          child: Text(
                                                            productt!.ten,
                                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
                                                            overflow: TextOverflow.ellipsis,
                                                            softWrap: true,
                                                          ),
                                                        ),
                                                      )
                                                    : const Text("Loading..."),
                                                SizedBox(height: 5.h),
                                                Row(
                                                  children: [
                                                    const Text("Loại:", style: TextStyle(color: Colors.blueGrey)),
                                                    item.maMauSanPham['MauSac'] != null
                                                        ? Text(" ${item.maMauSanPham['MauSac']}", style: const TextStyle(fontWeight: FontWeight.w400))
                                                        : const Text("Loading..."),
                                                    Text(
                                                      " | ",
                                                      style: TextStyle(fontSize: 12.sp, color: Colors.blueGrey),
                                                    ),
                                                    item.maMauSanPham['CauHinh'] != null
                                                        ? Text(" ${item.maMauSanPham['CauHinh']}",
                                                            style: const TextStyle(fontWeight: FontWeight.w400))
                                                        : const Text("Loading..."),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text("Số lượng: ", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.blueGrey)),
                                                    item.soLuong != null ? Text("${item.soLuong}") : const Text("Loading..."),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Đang vận chuyển",
                                            style: TextStyle(color: Colors.lightBlue, fontSize: 12.sp),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 130.0.w),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                                homeScreen.priceFormat(productt!.giaTien),
                                                style: const TextStyle(
                                                  color: Colors.blueGrey,
                                                  decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Flexible(
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                             priceFormat(productt!.giaTien),
                                                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.redAccent),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 1),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      item.soLuong != null
                                          ? Text(
                                              "${item.soLuong} sản phẩm",
                                              style: TextStyle(color: const Color.fromARGB(255, 41, 40, 40), fontSize: 13.sp),
                                            )
                                          : const Text("Loading..."),
                                      Row(
                                        children: [
                                          Text(
                                            "Thành tiền:",
                                            style: TextStyle(color: const Color.fromARGB(255, 41, 40, 40), fontSize: 15.sp),
                                          ),
                                          SizedBox(width: 5.w),
                                          Text(
                                            homeScreen.priceFormat(order.tongTien),
                                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: Colors.redAccent),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                SizedBox(height: 20.h),
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
                                const SizedBox(height: 60),
                                Linehelper(color: const Color.fromARGB(39, 158, 158, 158), height: 5.h),
                                ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [const Product()],
                                )
                              ],
                            );
                    },
                  );
                }
              },
            );
          }),
    );
  }
}
