import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/orders/controller/orders_controller.dart';
import 'package:etechstore/module/orders/model/detail_orders.dart';
import 'package:etechstore/module/orders/model/orders_model.dart';
import 'package:etechstore/module/orders/views/detail_order_screen.dart';
import 'package:etechstore/module/payment/models/order_detail_model.dart';
import 'package:etechstore/module/payment/models/order_model.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/helpers/line/line_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderdetailWdiet extends StatelessWidget {
  Color color;
  String status;
  final OrdersModel order;
  final DetailOrders detail;
  final ProductModel product;
  OrderdetailWdiet({super.key, required this.detail, required this.order, required this.product, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    final OrdersController controller = Get.put(OrdersController());

    return ScreenUtilInit(
      builder: (context, child) => Container(
        height: 183.h,
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
            border: Border.all(
              width: .5,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10.r)),
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
                      product.thumbnail != null
                          ? GestureDetector(
                              onTap: () {
                                Get.to(DetailOrderSreen(maDonHang: order.id));
                              },
                              child: FadeInImage.assetNetwork(
                                image: product.thumbnail.toString(),
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
                      SizedBox(width: 20.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          product.ten != null
                              ? GestureDetector(
                                  onTap: () {
                                    //
                                    Get.to(DetailOrderSreen(maDonHang: order.id));
                                  },
                                  child: SizedBox(
                                    width: 170.w,
                                    child: Text(
                                      product.ten,
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
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
                              detail.maMauSanPham['MauSac'] != null
                                  ? Text(" ${detail.maMauSanPham['MauSac']}", style: const TextStyle(fontWeight: FontWeight.w400))
                                  : const Text("Loading..."),
                              Text(
                                " | ",
                                style: TextStyle(fontSize: 12.sp, color: Colors.blueGrey),
                              ),
                              detail.maMauSanPham['CauHinh'] != null
                                  ? Text(" ${detail.maMauSanPham['CauHinh']}", style: const TextStyle(fontWeight: FontWeight.w400))
                                  : const Text("Loading..."),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Số lượng: ", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.blueGrey)),
                              detail.soLuong != null ? Text("${detail.soLuong}") : const Text("Loading..."),
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
                      status,
                      style: TextStyle(color: color, fontSize: 12.sp),
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
                          priceFormat(product.giaTien),
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
                          priceFormat((product.giaTien - (product.giaTien * product.KhuyenMai / 100)).toInt()),
                          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 1),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                detail.soLuong != null
                    ? Text("${detail.soLuong} sản phẩm", style: TextStyle(color: const Color.fromARGB(255, 41, 40, 40), fontSize: 13.sp))
                    : const Text("Loading"),
                Row(
                  children: [
                    Text(
                      "Thành tiền:",
                      style: TextStyle(color: const Color.fromARGB(255, 41, 40, 40), fontSize: 13.sp),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      priceFormat(((product.giaTien - (product.giaTien * product.KhuyenMai / 100)) * detail.soLuong).toInt()),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.redAccent),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 1),
            GestureDetector(
              onTap: () {
                controller.loadMore();
                Get.to(DetailOrderSreen(maDonHang: order.id));
              },
              child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  child: const Text("Xem chi tiết", style: TextStyle(color: Colors.grey, fontSize: 11))),
            ),
            SizedBox(height: 5.h),
            Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 1),
            SizedBox(height: 5.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: TColros.purple_line,
                border: const Border.fromBorderSide(BorderSide.none),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Text(
                "Mua lại",
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
