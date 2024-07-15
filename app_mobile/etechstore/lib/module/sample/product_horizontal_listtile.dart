import 'package:etechstore/module/home/models/product_model_home.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
import 'package:etechstore/module/wishlist/controller/wishlist_controller.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget productHorizontalListTile(BuildContext context, ProductModel product) {
  final wishListController = Get.put(WishListController());
  ProductSampleController sampleController =Get.put(ProductSampleController());
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
      width: MediaQuery.of(context).size.width / 2,
      child: Card(
        surfaceTintColor: Colors.white,
        child: Row(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 7,
                  width: MediaQuery.of(context).size.width / 3,
                  child: FadeInImage.assetNetwork(
                    image: product.thumbnail,
                    placeholder: ImageKey.whiteBackGround,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text("Lỗi kết nối"),
                      );
                    },
                  ),
                ),
                Builder(
                  builder: (context) {
                    if (product.KhuyenMai != 0) {
                      return Positioned(
                          top: -5,
                          left: 60,
                          child: Container(
                            decoration:
                                const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/discount_icon.png'), fit: BoxFit.cover)),
                            width: 100,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 3, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${product.KhuyenMai.toString()}%",
                                    style: const TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ));
                    }
                    return const Text("");
                  },
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.Ten.length < 27 ? product.Ten : '${product.Ten.substring(0, 27)}...',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            return Text('${priceFormat(int.parse(sampleController.currentPrice.toString()))}', style: const TextStyle(color: Colors.red));
                          },
                        ),
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
                        })
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
