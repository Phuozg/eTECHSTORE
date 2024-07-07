import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/home/controllers/product_controller.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/products/views/product_screen.dart';
import 'package:etechstore/module/sample/product_horizontal_sample.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductSampleController productSampleController = Get.put(ProductSampleController());

    final productController = Get.put(ProductControllerr());
    productSampleController.getSampleProduct();
    return Obx(() {
      if (productController.discountProducts.isEmpty) {
        return const Center(
          child: Text("Không có dữ liệu"),
        );
      }
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "DEAL CỰC CĂNG",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
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
                                      .where('KhuyenMai', isGreaterThan: 0)
                                      .where('TrangThai', isEqualTo: true),
                                )));
                  },
                  child: const Text("Xem tất cả"))
            ],
          ),
          productHorizontalSample(context, 'discountProduct'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Xu hướng mua sắm",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF383CA0)),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ProductScreen(
                                  title: 'Nổi bật',
                                  query: FirebaseFirestore.instance
                                      .collection('SanPham')
                                      .where('isPopular', isEqualTo: true)
                                      .where('TrangThai', isEqualTo: true),
                                )));
                  },
                  child: const Text("Xem tất cả"))
            ],
          ),
          productHorizontalSample(context, 'popularProduct'),
          const Divider(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ProductScreen(
                            title: 'Tất cả sản phẩm',
                            futureMethod: productController.getProductsForCate(catId: 0),
                          )));
            },
            child: const Text("Xem tất cả sản phẩm"),
          ),
        ],
      );
    });
  }
}
