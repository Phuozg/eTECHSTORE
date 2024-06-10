import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/bottom_nav_bar/nav_menu.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/cart/view/cart_screen.dart';
import 'package:etechstore/module/cart/view/prodct_view.dart';
import 'package:etechstore/module/fake/views/auth_controller.dart';
import 'package:etechstore/module/home/home_screen.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/view/detail_image_screen.dart';
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
  DetailScreen({
    super.key,
    required this.GiaTien,
    required this.KhuyenMai,
    required this.MaDanhMuc,
    required this.MoTa,
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
  final Ten;
  final TrangThai;
  final id;
  final thumbnail;
  List<dynamic> HinhAnh = [];

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    final ProductSampleController productSampleController = Get.put(ProductSampleController());

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

    return Scaffold(
      body: ScreenUtilInit(
        builder: (context, child) => SingleChildScrollView(
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
      ),
      bottomNavigationBar: SizedBox(
        height: 60.h,
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
            for (final sample in productSampleController.productSamples.where((p0) => id == p0.MaSanPham))
              GestureDetector(
                onTap: () {
                  productSampleController.fetchProductSamples();
                  showModalBottomSheet(
                      isDismissible: true,
                      enableDrag: true,
                      elevation: 10,
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (ctx) {
                        String selectedColor = sample.mauSac.first;
                        String selectedConfig = sample.cauHinh.first;
                        int quantity = 1;
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Container(
                              padding: EdgeInsets.only(top: 20.h, left: 30.w),
                              width: double.infinity,
                              height: 375.h,
                              color: Colors.white,
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: 90.w,
                                            height: 80.h,
                                            child: Image.network(
                                              thumbnail,
                                              fit: BoxFit.fill,
                                            )),
                                        SizedBox(width: 13.w),
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
                                                    height: 12.h,
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
                                                    Text(
                                                      "${priceFormat((GiaTien - (GiaTien * KhuyenMai / 100)).round())} ",
                                                      style: TColros.red_18_w500,
                                                    ),
                                                    Text(
                                                      "${priceFormat(GiaTien)} ",
                                                      style: const TextStyle(
                                                        decoration: TextDecoration.lineThrough,
                                                        fontSize: 14,
                                                        color: Color(0xFFC4C4C4),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                //   IconButton(onPressed: () {}, icon: const Icon(Icons.close))
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
                                    Column(
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          width: double.infinity,
                                          height: 70.h,
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              mainAxisExtent: 25.h,
                                              mainAxisSpacing: 15.w,
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
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 25.h, bottom: 9.h),
                                      child: const Text("Loại", style: TColros.black_14_w500),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          width: double.infinity,
                                          height: 70.h,
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              mainAxisExtent: 25.h,
                                              mainAxisSpacing: 15.w,
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
                                      ],
                                    ),
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
                                              border: Border.all(width: .5),
                                              borderRadius: BorderRadius.circular(30.r),
                                              color: const Color(0xFFF3F3F4)),
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
                                                width: .5.w,
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
                                                child: Container(
                                                    margin: EdgeInsets.only(right: 5.w), child: const Text("+", style: TColros.black_14_w600)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 35.h),
                                    GestureDetector(
                                      onTap: () {
                                        final FirebaseAuth auth = FirebaseAuth.instance;

                                        User? user = auth.currentUser;
                                        var cartItem = CartModel(
                                          id: sample.id,
                                          maKhachHang: user!.uid,
                                          soLuong: quantity,
                                          trangThai: 1,
                                          maSanPham: {
                                            'maSanPham': sample.MaSanPham,
                                            'mauSac': selectedColor,
                                            'cauHinh': selectedConfig,
                                          },
                                        );

                                        cartController.addItemToCart(cartItem);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: 8.w, bottom: 20.h),
                                        alignment: Alignment.center,
                                        width: 287.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          color: TColros.purple_line,
                                          border: Border.all(width: .5),
                                          borderRadius: BorderRadius.circular(30.r),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              TTexts.themVaoGioHang,
                                              style: TColros.white_14_w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      });
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
              onTap: () {
                print("Mua Hang");
                productSampleController.fetchProductSamples();
              },
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
                      " ${priceFormat((GiaTien - (GiaTien * KhuyenMai / 100)).round())}",
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
