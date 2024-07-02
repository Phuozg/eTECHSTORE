import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/cart/view/cart_screen.dart';
import 'package:etechstore/module/home/models/product_model_home.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/payment/views/buynow_screen.dart';
import 'package:etechstore/module/previews/controllers/preview_controller.dart';
import 'package:etechstore/module/previews/views/previews_screen.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/view/detail_image_screen.dart';
import 'package:etechstore/module/product_detail/view/widget/build_product_sample.dart';
import 'package:etechstore/module/product_detail/view/widget/sample_bottom_sheet.dart';
import 'package:etechstore/module/wishlist/controller/wishlist_controller.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_expandable_text/flutter_expandable_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/product_controller.dart';

class DetailScreen extends GetView {
  DetailScreen(
      {super.key,
      required this.GiaTien,
      required this.KhuyenMai,
      required this.MaDanhMuc,
      required this.MoTa,
      required this.Ten,
      required this.TrangThai,
      required this.id,
      required this.thumbnail,
      required this.HinhAnh,
      required this.NgayNhap,
      required this.isPopular});
  final GiaTien;
  final KhuyenMai;
  final MaDanhMuc;
  final MoTa;
  final Ten;
  final TrangThai;
  final id;
  final thumbnail;
  List<dynamic> HinhAnh = [];
  final NgayNhap;
  final isPopular;

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    final ProductSampleController productSampleController = Get.put(ProductSampleController());
    final wishListController = Get.put(WishListController());
    final previewsController = Get.put(PreviewsController());
    previewsController.fetchPreviews(id);
    previewsController.fetchUser();
    productSampleController.productsSold(id);
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
        child: FadeInImage.assetNetwork(
          image: url,
          placeholder: ImageKey.whiteBackGround,
          imageErrorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text("Lỗi kết nối"),
            );
          },
        ),
      );
    }).toList();

    productSampleController.resetIndex();

    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        body: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Stack(children: [
                      SizedBox(
                          width: double.infinity,
                          height: 365.h,
                          child: CarouselSlider(
                            items: imageWidgets,
                            options: CarouselOptions(
                              height: double.infinity,
                              viewportFraction: 1.2,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              onPageChanged: (index, reason) {
                                productSampleController.setCurrentIndex(index);
                              },
                              autoPlayInterval: const Duration(seconds: 5),
                              autoPlayCurve: Curves.fastOutSlowIn,
                            ),
                          )),
                      Positioned(
                        bottom: 70.h,
                        right: 10.r,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            '${productSampleController.currentIndex.value + 1} / ${HinhAnh.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Positioned(
                      width: 350.w,
                      top: 40.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_ios_new)),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CartScreen(),
                                    ));
                                cartController.isEditMode.value = false;
                                cartController.setTotalPriceAndCheckAll();
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
                            Builder(builder: (context) {
                              if (KhuyenMai != 0) {
                                return Row(
                                  children: [
                                    Text(
                                      priceFormat((GiaTien - (GiaTien * KhuyenMai / 100)).round()),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      priceFormat(GiaTien),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: const Color(0xFFC4C4C4),
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                children: [
                                  Text(
                                    priceFormat(GiaTien.round()),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              );
                            }),
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
                                Obx(() {
                                  return IconButton(
                                      onPressed: () {
                                        if (!wishListController.isWish(id)) {
                                          wishListController.addWish(id);
                                        } else {
                                          wishListController.removeWish(id);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.favorite,
                                        color: wishListController.isWish(id) ? Colors.red : Colors.black,
                                      ));
                                })
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 18,
                                  ),
                                  Text(
                                    "${previewsController.getAverage()}/5",
                                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.red),
                                  ),
                                  Text(" (${previewsController.previewsOfProduct.length} đánh giá)",
                                      style: const TextStyle(fontWeight: FontWeight.w300)),
                                  const Text(" | đã bán ", style: TextStyle(fontWeight: FontWeight.w300)),
                                  Text("${productSampleController.lstProduct.length}",
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
                  padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                  child: Text(TTexts.chiTietSanPham, style: TColros.black_13_w500),
                ),
                Container(
                  height: 1.h,
                  width: double.infinity,
                  color: const Color(0xFFF3F3F4),
                ),
                Container(
                  margin: EdgeInsets.only(left: 21.w),
                  padding: EdgeInsets.only(top: 8.h, bottom: 8.h, right: 20.w),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          for (var i = 0; i < previewsController.getAverage().toInt(); i++)
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          Text(
                            "${previewsController.getAverage()}/5",
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.red),
                          ),
                          Text(" (${previewsController.previewsOfProduct.length} đánh giá)", style: const TextStyle(fontWeight: FontWeight.w300)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (previewsController.previewsOfProduct.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Thử lại sau!!!"),
                                  content: const Text("Sản phẩm này chưa có đánh giá nào!"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Đóng"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (builder) => PreviewsScreen(productID: id)));
                          }
                        },
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
        bottomNavigationBar: buildProductSamples(
            GiaTien: GiaTien,
            HinhAnh: HinhAnh,
            KhuyenMai: KhuyenMai,
            MaDanhMuc: MaDanhMuc,
            MoTa: MoTa,
            NgayNhap: NgayNhap,
            Ten: Ten,
            TrangThai: TrangThai,
            context: context,
            id: id,
            isPopular: isPopular,
            thumbnail: thumbnail),
      ),
    );
  }
}
