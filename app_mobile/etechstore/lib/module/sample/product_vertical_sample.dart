import 'package:etechstore/module/home/models/product_model_home.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
import 'package:etechstore/module/product_detail/view/widget/sample_bottom_sheet.dart';
import 'package:etechstore/module/wishlist/controller/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget productVerticalSample(BuildContext context, List<ProductModel> products) {
  final wishListController = Get.put(WishListController());

  final ProductSampleController productSampleController = Get.put(ProductSampleController());
  return Container(
      constraints: const BoxConstraints(maxHeight: double.infinity),
      child: ScreenUtilInit(
          builder: (context, child) => StreamBuilder<List<ProductSampleModel>>(
                stream: productSampleController.getSampleProduct(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text("Loading..."));
                  }
                  final lstSample = snapshot.data!;
                  return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7),
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (_, index) {
                        final product = products[index];
                        final fillterSample = lstSample.firstWhere((element) => element.MaSanPham == product.id);
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 3.5,
                          child: GestureDetector(
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
                              width: MediaQuery.of(context).size.width / 2,
                              child: Card(
                                surfaceTintColor: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      children: [
                                        SizedBox(
                                            height: MediaQuery.of(context).size.height / 7.75,
                                            width: MediaQuery.of(context).size.width / 3.5,
                                            child: Image.network(
                                              product.thumbnail,
                                              fit: BoxFit.cover,
                                            )),
                                        Builder(
                                          builder: (context) {
                                            if (product.KhuyenMai != 0) {
                                              return Positioned(
                                                  top: -5,
                                                  left: 50,
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        image:
                                                            DecorationImage(image: AssetImage('assets/images/discount_icon.png'), fit: BoxFit.cover)),
                                                    width: 80,
                                                    height: 40,
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 10, 3, 0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "${product.KhuyenMai.toString()}%",
                                                            style: const TextStyle(color: Colors.white,fontSize: 11),
                                                          )
                                                        ],
                                                      ),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
              )));
}
