import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void showCustomModalBottomSheet({required BuildContext context, required sample, required CartModel item, required ProductModel product}) {
  final CartController controller = Get.put(CartController());

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      String selectedColor = sample.mauSac.first;
      String selectedConfig = sample.cauHinh.first;
      int quantity = 1;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ScreenUtilInit(
            builder: (context, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                    ),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(top: 20.h, left: 30.w),
                  height: 420,
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 90.w,
                                  height: 80.h,
                                  child: product.thumbnail != null
                                      ? FadeInImage.assetNetwork(
                                          image: product.thumbnail,
                                          placeholder: ImageKey.whiteBackGround,
                                          fit: BoxFit.cover,
                                          imageErrorBuilder: (context, error, stackTrace) {
                                            return Center(child: Image.asset(ImageKey.whiteBackGround));
                                          },
                                        )
                                      : null),
                              const SizedBox(width: 13),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 5.h),
                                        child: SizedBox(
                                          width: 15.w,
                                          height: 12.w,
                                          child: (const Image(
                                            image: AssetImage(ImageKey.iconVoucher),
                                            fit: BoxFit.fill,
                                          )),
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          product.KhuyenMai != null
                                              ? Text(
                                                  "${priceFormat((product.giaTien - (product.giaTien * product.KhuyenMai / 100)).round())} ",
                                                  style: TColros.red_18_w500,
                                                )
                                              : const Text('Loading...'),
                                          product.giaTien != null
                                              ? Text(
                                                  "${priceFormat(product.giaTien)} ",
                                                  style: TextStyle(
                                                    decoration: TextDecoration.lineThrough,
                                                    fontSize: 14.sp,
                                                    color: const Color(0xFFC4C4C4),
                                                  ),
                                                )
                                              : const Text("Loading...")
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(left: 70.w, bottom: 40.h),
                                            padding: EdgeInsets.only(bottom: 20.h),
                                            alignment: Alignment.topRight,
                                            child: const Text(
                                              "x",
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 25.h, bottom: 9.h),
                            child: const Text("Màu sắc", style: TColros.black_13_w500),
                          ),
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            height: 70.h,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisExtent: 25,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: CupertinoCheckbox.width,
                              ),
                              itemCount: sample.mauSac.length,
                              itemBuilder: (context, index) {
                                String color = sample.mauSac[index];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedColor = color;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(right: 15.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: selectedColor == color ? Colors.redAccent : Colors.white,
                                      ),
                                      color: const Color.fromARGB(35, 158, 158, 158),
                                    ),
                                    child: Center(child: Text(color.toString())),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 9.h),
                            child: const Text("Loại", style: TColros.black_14_w500),
                          ),
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            height: 70.h,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisExtent: 25,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: CupertinoCheckbox.width,
                              ),
                              itemCount: sample.cauHinh.length,
                              itemBuilder: (context, index) {
                                String config = sample.cauHinh[index];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedConfig = config;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(right: 15.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: selectedConfig == config ? Colors.redAccent : Colors.white,
                                      ),
                                      color: const Color.fromARGB(35, 158, 158, 158),
                                    ),
                                    child: Center(child: Text(config.toString())),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 16.0.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Số lượng", style: TColros.black_14_w500),
                              Container(
                                margin: EdgeInsets.only(right: 20.w),
                                width: 85.w,
                                height: 23.h,
                                decoration: BoxDecoration(
                                    border: Border.all(width: .5), borderRadius: BorderRadius.circular(30), color: const Color(0xFFF3F3F4)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          if (quantity > 1) {
                                            setState(() {
                                              quantity--;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: 8.w,
                                          height: 2.h,
                                          color: Colors.black,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(left: 5.w),
                                        )),
                                    Container(
                                      height: double.infinity,
                                      color: Colors.black,
                                      width: .5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 1.h),
                                      child: Text(
                                        quantity.toString(),
                                        style: TextStyle(fontSize: 17.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: double.infinity,
                                      color: Colors.black,
                                      width: .5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantity++;
                                        });
                                      },
                                      child: Container(margin: EdgeInsets.only(right: 5.w), child: const Text("+", style: TColros.black_14_w600)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0.h),
                          GestureDetector(
                            onTap: () {
                              selectedColor = selectedColor;
                              selectedConfig = selectedConfig;
                              item.maSanPham['mauSac'] = selectedColor;
                              item.maSanPham['cauHinh'] = selectedConfig;
                              item.soLuong = quantity;
                              controller.updateCartItem(item);
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10.w, bottom: 20.h),
                              alignment: Alignment.center,
                              width: 287.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: TColros.purple_line,
                                border: Border.all(width: .5),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: const Text(
                                'Xác nhận',
                                style: TColros.white_14_w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
