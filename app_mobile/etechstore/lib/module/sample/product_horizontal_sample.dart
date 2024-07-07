import 'package:etechstore/module/home/controllers/product_controller.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
import 'package:etechstore/module/product_detail/view/widget/build_product_sample.dart';
import 'package:etechstore/module/product_detail/view/widget/sample_bottom_sheet.dart';
import 'package:etechstore/module/wishlist/controller/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';import 'package:flutter_screenutil/flutter_screenutil.dart';


Widget productHorizontalSample(BuildContext context, String query) {
  final productController = Get.put(ProductControllerr());
  final wishListController = Get.put(WishListController());
  final ProductSampleController productSampleController = Get.put(ProductSampleController());

  return ScreenUtilInit(builder: (context, child) => 
  StreamBuilder<List<ProductSampleModel>>(
      stream: productSampleController.getSampleProduct(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Text("Loading..."));
        }
        final lstSample = snapshot.data!;
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: Obx(
            () => ListView.builder(
                shrinkWrap: true,
                itemCount: productController.queryProduct(query).length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  final product = productController.queryProduct(query)[index];
    
                  final fillterSample = lstSample.firstWhere((element) => element.MaSanPham == product.id);
                  List fillter = lstSample.where((element) => element.MaSanPham == product.id).toList();
    
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              HinhAnh: product.HinhAnh,
                              GiaTien: product.GiaTien,
                              KhuyenMai: product.KhuyenMai,
                              MaDanhMuc: product.MaDanhMuc,
                              MoTa: product.MoTa,
                              Ten: product.Ten,
                              TrangThai: product.TrangThai,
                              id: product.id,
                              thumbnail: product.thumbnail,
                              isPopular: product.isPopular,
                              NgayNhap: product.NgayNhap,
                            ),
                          ));
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: Card(
                        surfaceTintColor: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                        height: MediaQuery.of(context).size.height / 6.5,
                                        width: MediaQuery.of(context).size.width / 3,
                                        child: Image.network(
                                          product.thumbnail,
                                          fit: BoxFit.cover,
                                        )),
                                    Builder(
                                      builder: (context) {
                                        if (product.KhuyenMai != 0) {
                                          return Positioned(
                                              top: 0,
                                              left: 80,
                                              right: 2,
                                              bottom: 85,
                                              child: Container(
                                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                width: 100,
                                                height: 50,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "-${product.KhuyenMai.toString()}%",
                                                      style: const TextStyle(color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                              ));
                                        }
                                        return const Text("");
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  product.Ten.length < 30 ? product.Ten : '${product.Ten.substring(0, 30)}...',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Builder(
                                  builder: (context) {
                                    if (product.KhuyenMai != 0) {
                                      return Column(
                                        children: [
                                          Text(
                                            priceFormat(product.GiaTien),
                                            style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
                                          ),
                                          Text(priceFormat(((product.GiaTien - (product.GiaTien * product.KhuyenMai / 100))).round()),
                                              style: const TextStyle(color: Colors.red))
                                        ],
                                      );
                                    }
                                    return Text(priceFormat(product.GiaTien), style: const TextStyle(color: Colors.red));
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: fillter.map((e) {
                                return Row(
                                  children: [
                                    Obx(() {
                                      return IconButton(
                                          onPressed: () {
                                            if (!wishListController.isWish(product.id)) {
                                              wishListController.addWish(product.id);
                                            } else {
                                              wishListController.removeWish(product.id);
                                            }
                                          },
                                          icon: Icon(
                                            Icons.favorite,
                                            color: wishListController.isWish(product.id) ? Colors.red : Colors.black,
                                          ));
                                    }),
                                    IconButton(
                                        onPressed: () {
                                          fillterSample.mauSac.isNotEmpty && fillterSample.cauHinh.isNotEmpty
                                              ? showModalBottomSheet(
                                                  context: context,
                                                  builder: (ctx) {
                                                    productSampleController.setSelectedColorIndex(0, fillterSample);
                                                    productSampleController.setSelectedConfigIndex(0, fillterSample);
                                                    productSampleController.checkPrice(fillterSample, product.GiaTien.toString());
                                                    return SampleBottomSheet(
                                                      KhuyenMai: product.KhuyenMai,
                                                      GiaTien: product.GiaTien,
                                                      sample: fillterSample,
                                                      thumbnail: product.thumbnail,
                                                      id: product.id,
                                                    );
                                                  },
                                                )
                                              : showModalBottomSheet(
                                                  context: context,
                                                  builder: (ctx) {
                                                    productSampleController.setSelectedColorIndex(0, fillterSample);
                                                    productSampleController.setSelectedConfigIndex(0, fillterSample);
                                                    productSampleController.checkPrice(fillterSample, product.GiaTien.toString());
                                                    return BuySampleSingle(
                                                      KhuyenMai: product.KhuyenMai,
                                                      GiaTien: product.GiaTien,
                                                      sample: fillterSample,
                                                      thumbnail: product.thumbnail,
                                                    );
                                                  },
                                                );
                                        },
                                        icon: const Icon(Icons.add))
                                  ],
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        );
      },
    ),
  );
}
