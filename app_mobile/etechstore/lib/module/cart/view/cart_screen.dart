import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/controller/enum.dart';
import 'package:etechstore/module/home/home_screen.dart';
import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SingingCharacter? character = SingingCharacter.lafayette;
    final cartController = Get.put(CartController());

    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
          backgroundColor: const Color(0xFFF3F3F4),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF3F3F4),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30.w,
                ),
                const Text("Giỏ hàng", style: TColros.black_18),
                const Text(
                  " (4)",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text("Sửa", style: TColros.black_14_w400),
              )
            ],
          ),
          body: ListView.builder(
            itemCount: CartController.products.length,
            itemBuilder: (context, index) {
              final product = CartController.products[index];

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                  GiaTien: product['GiaTien'],
                                  KhuyenMai: product['KhuyenMai'],
                                  MaDanhMuc: product['MaDanhMuc'],
                                  MoTa: product['MoTa'],
                                  SoLuong: product['SoLuong'],
                                  Ten: product['Ten'],
                                  TrangThai: product['TrangThai'],
                                  id: product['id'],
                                  thumbnail: product['thumbnail'],
                                  HinhAnh: product['HinhAnh']),
                            ));
                      },
                      child: Container(
                        alignment: Alignment.topCenter,
                        width: double.infinity,
                        height: 100.h,
                        margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                        decoration: BoxDecoration(border: null, borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Transform.scale(
                                    scale: 1,
                                    child: Checkbox(
                                      checkColor: Colors.white,
                                      activeColor: Colors.deepOrange,
                                      value: cartController.selected.value == 2,
                                      side: BorderSide(color: Colors.grey.shade400),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      onChanged: (val) {
                                        val ?? true ? cartController.selected.value = 2 : cartController.selected.value = null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 70.w,
                                  height: 60.h,
                                  child: Image.network(
                                    '${product['thumbnail']}',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 13.w),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 210.w,
                                          child: Text(
                                            "${product['Ten']}",
                                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Màu sắc:",
                                          style: TextStyle(color: Colors.grey.shade400),
                                        ),
                                        const Text(
                                          " Đỏ",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  priceFormat(product['GiaTien']),
                                                  style: TextStyle(color: const Color(0xFFEB4335), fontSize: 16.sp),
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                const Text(
                                                  "4.700.000",
                                                  style: TextStyle(
                                                    decoration: TextDecoration.lineThrough,
                                                    inherit: true,
                                                    color: Color(0xFFC4C4C4),
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 60.w,
                                      height: 16.5.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: .5.w), borderRadius: BorderRadius.circular(5.r), color: const Color(0xFFF3F3F4)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            child: Container(child: const Text("-")),
                                            onTap: () {
                                              cartController.incrementQuantity(CartController.currentUserID, product);
                                            },
                                          ),
                                          Text(
                                            "${product['SoLuong']}",
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                          GestureDetector(
                                            child: Container(child: const Text("+")),
                                            onTap: () {
                                              cartController.decrementQuantity(CartController.currentUserID, product);
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: SizedBox(
            height: 65.h,
            width: double.infinity,
            child: BottomAppBar(
              color: Colors.white,
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Obx(
                          () => Transform.scale(
                            scale: 1,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.deepOrange,
                              value: cartController.selected.value == 2,
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              onChanged: (val) {
                                val ?? true ? cartController.selected.value = 2 : cartController.selected.value = null;
                              },
                            ),
                          ),
                        ),
                        Text(
                          "Tất cả",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
                        ),
                      ],
                    ),
                    SizedBox(width: 6.h),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 6.h),
                            const Text("Tổng thanh toán", style: TextStyle(fontSize: 10)),
                            Text(
                              "4.600.000",
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.redAccent),
                            ),
                            //  Text("Giảm 600.000", style: TextStyle(fontSize: 10.sp, color: const Color(0xFFCB291C)))
                          ],
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 114.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                              border: Border.all(width: .5.w), borderRadius: BorderRadius.circular(10.w), color: const Color(0xFFCB291C)),
                          child: const Text(
                            "Thanh thoán (0)",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
