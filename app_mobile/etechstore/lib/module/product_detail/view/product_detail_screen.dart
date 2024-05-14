import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/home/home_screen.dart';
import 'package:etechstore/module/product_detail/controller/get_product_controller.dart';
import 'package:etechstore/module/product_detail/model/product_detail_model.dart';
import 'package:etechstore/module/product_detail/view/controller_state_manage/detail_controller_state_manage.dart';
import 'package:etechstore/module/product_detail/view/detail_image_screen.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_expandable_text/flutter_expandable_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:get/get_core/src/get_main.dart';

class DetailScreen extends GetView {
  DetailScreen({
    super.key,
    required this.GiaTien,
    required this.KhuyenMai,
    required this.MaDanhMuc,
    required this.MoTa,
    required this.SoLuong,
    required this.Ten,
    required this.TrangThai,
    required this.id,
    required this.thumbnail,
    required this.HinhAnh,
  });
  final GiaTien;
  final KhuyenMai;
  final MaDanhMuc;
  final MoTa;
  final SoLuong;
  final Ten;
  final TrangThai;
  final id;
  final thumbnail;
  List<dynamic> HinhAnh = [];
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    List<Widget> imageWidgets = HinhAnh.map((url) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailImageScreen(imageUrl: url),
            ),
          );
        },
        child: Image.network(url),
      );
    }).toList();

    return Scaffold(
      body: ScreenUtilInit(
        builder: (context, child) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: 365.h,
                      child: CarouselSlider(
                        items: imageWidgets,
                        options: CarouselOptions(
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          // autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayCurve: Curves.fastOutSlowIn,
                        ),
                      )),
                  Positioned(
                    width: 350.w,
                    top: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.off(const HomeScreen());
                            },
                            icon: const Icon(Icons.arrow_back_ios_new)),
                        IconButton(
                            onPressed: () {
                              //    controller.getImages();
                            },
                            icon: const Image(
                              image: AssetImage(ImageKey.iconCart),
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 361),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    width: double.infinity,
                    child: Container(
                      margin: EdgeInsets.only(top: 25.h, left: 21.w),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                priceFormat(GiaTien),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "4.000.000",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: const Color(0xFFC4C4C4),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 285.w,
                                child: Text(
                                  '''$Ten''',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: const Color.fromARGB(255, 217, 217, 217),
                                ),
                                child: const Image(image: AssetImage(ImageKey.iconHeart)),
                              )
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 18,
                                ),
                                Text(
                                  "4.8/5",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "(320)",
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                                ),
                                Text(" | đã bán ", style: TextStyle(fontWeight: FontWeight.w300)),
                                Text("210", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 7.h,
                width: double.infinity,
                color: const Color(0xFFF3F3F4),
              ),
              Container(
                margin: EdgeInsets.only(left: 21.w),
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(TTexts.chiTietSanPham, style: TColros.black_13_w500),
              ),
              Container(
                height: 1.h,
                width: double.infinity,
                color: const Color(0xFFF3F3F4),
              ),
              Container(
                margin: EdgeInsets.only(left: 21.w),
                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 20),
                child: ExpandableText(
                  style: TextStyle(fontSize: 14.sp, color: const Color(0xFF848484)),
                  "$MoTa",
                  trimType: TrimType.lines,
                  trim: 5,
                  readLessText: TTexts.thuGon,
                  readMoreText: TTexts.xemThem,
                ),
              ),
              Container(
                height: 7.h,
                width: double.infinity,
                color: const Color(0xFFF3F3F4),
              ),
              Container(
                margin: EdgeInsets.only(left: 21.w),
                padding: EdgeInsets.only(top: 8.h),
                child: Text(TTexts.danhGiaSanPham, style: TColros.black_13_w500),
              ),
              Container(
                margin: EdgeInsets.only(left: 19.w),
                padding: EdgeInsets.only(bottom: 8.w, right: 20.w),
                child: Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow, size: 18.sp),
                          Icon(Icons.star, color: Colors.yellow, size: 18.sp),
                          Icon(Icons.star, color: Colors.yellow, size: 18.sp),
                          Icon(Icons.star, color: Colors.yellow, size: 18.sp),
                          Icon(Icons.star, color: Colors.yellow, size: 18.sp),
                          Text(
                            "4.8/5",
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.red),
                          ),
                          const Text(" (14 đánh giá)", style: TextStyle(fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          margin: EdgeInsets.only(left: 25.w),
                          child: Text(
                            TTexts.xemTatCa,
                            style: const TextStyle(color: Colors.red),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60.h,
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
            GestureDetector(
              onTap: () {
                FullScreenLoader.show(context, thumbnail, SoLuong, Ten, GiaTien, '5.000.000', '5.000.000');
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
            GestureDetector(
              onTap: () {},
              child: Container(
                alignment: Alignment.bottomCenter,
                width: 150.w,
                height: 70.h,
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
                      " ${priceFormat(GiaTien)}",
                      style: TColros.red_accent_15,
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
