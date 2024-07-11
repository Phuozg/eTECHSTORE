import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/home/controllers/product_controller.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/products/views/product_screen.dart';
import 'package:etechstore/module/products/views/sortable_products.dart';
import 'package:etechstore/module/sample/product_horizontal_sample.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductSampleController productSampleController =
        Get.put(ProductSampleController());
    productSampleController.getSampleProduct();

    final productController = Get.put(ProductControllerr());
    var products = productController.allProduct;
    return Obx(() {
      if (productController.discountProducts.isEmpty) {
        return const Center(
          child: Text("Không có dữ liệu"),
        );
      }
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.only(left: 5),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "DEAL CỰC CĂNG",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF383CA0)),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => ProductScreen(
                                        title: 'Khuyến mãi',
                                        query: FirebaseFirestore.instance
                                            .collection('SanPham')
                                            .where('KhuyenMai',
                                                isGreaterThan: 0)
                                            .where('TrangThai',
                                                isEqualTo: true),
                                      )));
                        },
                        child: const Text(
                          "Xem tất cả",
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
                productHorizontalSample(context, 'discountProduct'),
              ],
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(top: 5),
          //   color: Colors.white,
          //   child: Column(
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           const Text(
          //             "Xu hướng mua sắm",
          //             style: TextStyle(
          //                 fontSize: 20,
          //                 fontWeight: FontWeight.bold,
          //                 color: Color(0xFF383CA0)),
          //           ),
          //           TextButton(
          //               onPressed: () {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (builder) => ProductScreen(
          //                               title: 'Nổi bật',
          //                               query: FirebaseFirestore.instance
          //                                   .collection('SanPham')
          //                                   .where('isPopular', isEqualTo: true)
          //                                   .where('TrangThai',
          //                                       isEqualTo: true),
          //                             )));
          //               },
          //               child: const Text(
          //                 "Xem tất cả",
          //                 style: TextStyle(color: Colors.black),
          //               ))
          //         ],
          //       ),
          //       productHorizontalSample(context, 'popularProduct'),
          //     ],
          //   ),
          // ),
          Container(
              padding: const EdgeInsets.only(left: 5),
              margin: const EdgeInsets.only(top: 5),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Gợi ý hôm nay",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF383CA0)),
                  ),
                  SortableProducts(products: products),
                ],
              )),
        ],
      );
    });
  }
}
