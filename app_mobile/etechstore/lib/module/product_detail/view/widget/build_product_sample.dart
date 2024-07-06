import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/home/models/product_model_home.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/payment/views/buynow_screen.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:etechstore/module/product_detail/view/widget/sample_bottom_sheet.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

Widget buildProductSamples(
    {required BuildContext context,
    required String id,
    required String thumbnail,
    required int GiaTien,
    required int KhuyenMai,
    required List<dynamic> HinhAnh,
    required int MaDanhMuc,
    required String Ten,
    required String MoTa,
    required bool TrangThai,
    required Timestamp NgayNhap,
    required bool isPopular}) {
  final ProductSampleController productSampleController = Get.put(ProductSampleController());
  final CartController controller = Get.put(CartController());

  return ScreenUtilInit(
    builder: (context, child) => SizedBox(
        width: double.infinity,
        height: 64,
        child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: StreamBuilder<List<ProductSampleModel>>(
              stream: productSampleController.getSampleProduct(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<ProductSampleModel> lstSample = snapshot.data!;
                  List fillterSample = lstSample.where((element) => element.MaSanPham == id).toList();
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: fillterSample.map((sample) {
                      if (sample.mauSac.isEmpty && sample.cauHinh.isEmpty) {
                        // Nếu mauSac hoặc cauhinh là null
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (ctx) {
                                    productSampleController.setSelectedColorIndex(0, sample);
                                    productSampleController.setSelectedConfigIndex(0, sample);
                                    productSampleController.checkPrice(sample, GiaTien.toString());
                                    return BuySampleSingle(GiaTien: GiaTien, KhuyenMai: KhuyenMai, sample: sample, thumbnail: thumbnail);
                                  },
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 150.w,
                                height: 70.h,
                                decoration: BoxDecoration(
                                  border: Border.all(width: .5.w, color: TColros.purple_line),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Text(
                                  TTexts.themVaoGioHang,
                                  style: const TextStyle(color: TColros.purple_line),
                                ),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => BuyNowScreen(
                                            product: ProductModel(
                                                GiaTien: GiaTien,
                                                HinhAnh: HinhAnh,
                                                KhuyenMai: KhuyenMai,
                                                MaDanhMuc: MaDanhMuc,
                                                MoTa: MoTa,
                                                TrangThai: TrangThai,
                                                Ten: Ten,
                                                id: id,
                                                thumbnail: thumbnail,
                                                NgayNhap: NgayNhap,
                                                isPopular: isPopular))));
                              },
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                width: 150.w,
                                height: 66.h,
                                decoration: BoxDecoration(
                                  color: TColros.purple_line,
                                  border: Border.all(width: .5.w),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      TTexts.muaVoiVoucher,
                                      style: TColros.white_12_w300,
                                    ),
                                    Text(
                                      " ${priceFormat((GiaTien - (GiaTien * KhuyenMai / 100)).round())}",
                                      style: TColros.red_accent_15,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              productSampleController.setSelectedColorIndex(0, sample);
                              productSampleController.setSelectedConfigIndex(0, sample);
                              productSampleController.checkPrice(sample, GiaTien.toString());
                              return SampleBottomSheet(
                                KhuyenMai: KhuyenMai,
                                GiaTien: GiaTien,
                                sample: sample,
                                thumbnail: thumbnail,
                                id: id,
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 150.w,
                              height: 70.h,
                              decoration: BoxDecoration(
                                border: Border.all(width: .5.w, color: TColros.purple_line),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Text(
                                TTexts.themVaoGioHang,
                                style: const TextStyle(color: TColros.purple_line),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => BuyNowScreen(
                                            product: ProductModel(
                                                GiaTien: GiaTien,
                                                HinhAnh: HinhAnh,
                                                KhuyenMai: KhuyenMai,
                                                MaDanhMuc: MaDanhMuc,
                                                MoTa: MoTa,
                                                TrangThai: TrangThai,
                                                Ten: Ten,
                                                id: id,
                                                thumbnail: thumbnail,
                                                NgayNhap: NgayNhap,
                                                isPopular: isPopular))));
                              },
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                width: 150.w,
                                height: 67.h,
                                decoration: BoxDecoration(
                                  color: TColros.purple_line,
                                  border: Border.all(width: .5.w),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      TTexts.muaVoiVoucher,
                                      style: TColros.white_12_w300,
                                    ),
                                    Text(
                                      " ${priceFormat((GiaTien - (GiaTien * KhuyenMai / 100)).round())}",
                                      style: TColros.red_accent_15,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ), // Replace with actual UI element
                      );
                    }).toList(),
                  );
                }
              },
            ))),
  );
}
