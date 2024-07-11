import 'package:etechstore/module/sample/product_vertical_sample.dart';
import 'package:etechstore/module/wishlist/controller/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  final wishlistController = Get.put(WishListController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Color(0xFF383CA0)),
        ),
        title: const Text(
          "Sản phẩm yêu thích",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Obx(() {
                if (wishlistController.listProductWishList.isEmpty) {
                  return const Center(
                    child: Text('Bạn chưa có sản phẩm yêu thích nào'),
                  );
                }
                return productVerticalSample(
                    context, wishlistController.listProductWishList);
              }),
            ])),
      ),
    );
  }
}
