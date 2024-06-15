import 'package:etechstore/module/wishlist/controller/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.put(WishListController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sản phẩm yêu thích"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            wishlistController.fetchProductWishList();
          }, 
          child: const Text("data")
        ),
      ),
    );
  }
}
