import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/orders/controller/orders_controller.dart';
import 'package:etechstore/module/orders/model/detail_orders.dart';
import 'package:etechstore/module/orders/model/orders_model.dart';
import 'package:etechstore/module/orders/views/detail_order_screen.dart';
import 'package:etechstore/module/orders/views/widget/order_isEmpty._widget.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/helpers/line/line_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCompleted extends StatelessWidget {
  const OrderCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersController controller = Get.put(OrdersController());
    final FirebaseAuth auth = FirebaseAuth.instance;

    return ScreenUtilInit(
      builder: (context, child) => StreamBuilder<List<OrdersModel>>(
          stream: controller.getOrder(),
          builder: (context, snapshotDonHang) {
            if (!snapshotDonHang.hasData) {
              return const OrderIsEmpty();
            }
            String userId = auth.currentUser?.uid ?? '';
            List<OrdersModel> donHangs = snapshotDonHang.data!;
            List<OrdersModel> fillterOrder = donHangs.where((order) => order.maKhachHang == userId && order.isCompleted).toList();
            if (fillterOrder.isEmpty) {
              return const OrderIsEmpty();
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
                      itemCount:
                          (controller.itemsToShow.value >= filteredCTDonHangs.length) ? filteredCTDonHangs.length : controller.itemsToShow.value + 1,
                      itemBuilder: (context, index) {
                        DetailOrders item = filteredCTDonHangs[index];

                        var product = controller.products[item.maMauSanPham['MaSanPham']];
                        OrdersModel? order = fillterOrder.firstWhereOrNull((order) => order.id == item.maDonHang);
                        if (order == null) {
                          return const OrderIsEmpty();
                        }
                        controller.checkItemInOrder(order.id);

                        return order.isCompleted == true
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
                                            Get.to(DetailOrderSreen(maDonHang: order.id));
                                          },
                                          child: Row(
                                            children: [
                                              SizedBox(width: 3.w),
                                              product?.thumbnail != null
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        Get.to(DetailOrderSreen(maDonHang: order.id));
                                                      },
                                                      child: FadeInImage.assetNetwork(
                                                        image: product!.thumbnail.toString(),
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
                                                  product?.Ten != null
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            //
                                                            Get.to(DetailOrderSreen(maDonHang: order.id));
                                                          },
                                                          child: SizedBox(
                                                            width: 140.w,
                                                            child: Text(
                                                              product!.Ten,
                                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
                                                              overflow: TextOverflow.ellipsis,
                                                              softWrap: true,
                                                            ),
                                                          ),
                                                        )
                                                      : const Text("Loading..."),
                                                  SizedBox(height: 5.h),
                                                  item.maMauSanPham['MauSac'] != "" && item.maMauSanPham['CauHinh'] != "" ||
                                                          item.maMauSanPham['MauSac'] != "" ||
                                                          item.maMauSanPham['CauHinh'] != ""
                                                      ? Row(
                                                          children: [
                                                            const Text("Loại:", style: TextStyle(color: Colors.blueGrey)),
                                                            item.maMauSanPham['MauSac'] == null
                                                                ? const Text("Loại:", style: TextStyle(color: Colors.grey))
                                                                : Container(),
                                                            item.maMauSanPham['MauSac'] != null
                                                                ? Text("${item.maMauSanPham['MauSac']}",
                                                                    style: const TextStyle(fontWeight: FontWeight.w400))
                                                                : const Text("Loading..."),
                                                            Row(
                                                              children: [
                                                                item.maMauSanPham['MauSac'] != "" && item.maMauSanPham['CauHinh'] != "" ||
                                                                        item.maMauSanPham['MauSac'] != "" ||
                                                                        item.maMauSanPham['CauHinh'] != ""
                                                                    ? Text(
                                                                        " | ",
                                                                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                                                      )
                                                                    : Container(),
                                                                item.maMauSanPham['CauHinh'] != null
                                                                    ? Text("${item.maMauSanPham['CauHinh']}",
                                                                        style: const TextStyle(fontWeight: FontWeight.w400))
                                                                    : const Text("Loading..."),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      : Container(),
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
                                              "Thành công",
                                              style: TextStyle(color: Colors.green, fontSize: 12.sp),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          priceFormat(product!.GiaTien),
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          priceFormat((item.giaTien!).toInt()),
                                          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.redAccent),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 1),
                                    Center(
                                      child: GestureDetector(
                                          onTap: () {
                                            controller.loadMore();
                                            Get.to(DetailOrderSreen(maDonHang: order.id));
                                          },
                                          child:  controller.getQuantity(ctDonHangs, order.id) >= 2
                                                ? Text("Xem thêm ${controller.getQuantity(ctDonHangs, order.id) - 1} sản phẩm",
                                                    style: const TextStyle(color: Colors.grey, fontSize: 11))
                                                : const Text("Xem chi tiết", style: TextStyle(color: Colors.grey, fontSize: 11)),
                                          ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 1),
                                    SizedBox(height: 5.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        item.soLuong != null
                                            ?  Text(
                                                  "${controller.getQuantity(ctDonHangs, order.id)} sản phẩm",
                                                  style: TextStyle(color: const Color.fromARGB(255, 41, 40, 40), fontSize: 13.sp),
                                                
                                              )
                                            : const Text("Loading..."),
                                        Row(
                                          children: [
                                            Text(
                                              "Thành tiền:",
                                              style: TextStyle(color: const Color.fromARGB(255, 41, 40, 40), fontSize: 13.sp),
                                            ),
                                            SizedBox(width: 5.w),
                                            Text(
                                              priceFormat((order.tongTien).toInt()),
                                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.redAccent),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : const OrderIsEmpty();
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
