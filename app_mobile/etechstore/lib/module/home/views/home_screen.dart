import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/view/cart_screen.dart';
import 'package:etechstore/module/cart/view/widget/cart_icon_widget.dart';
import 'package:etechstore/module/home/views/category.dart';
import 'package:etechstore/module/home/views/product.dart';
import 'package:etechstore/module/home/views/search_bar.dart';
import 'package:etechstore/module/home/views/slideshow_banner.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/wishlist/controller/wishlist_controller.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
    HomeScreen({super.key});
    ProductSampleController productSampleController = Get.put(ProductSampleController());
  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    final Uri facbook = Uri.parse('https://www.facebook.com/messages/t/323929774140624');
    final wishListController = Get.put(WishListController());
    wishListController.createWishList(FirebaseAuth.instance.currentUser!.uid);
      productSampleController.getSampleProduct();
 
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Color(0xFF383CA0)),
        ),
        title: searchBar(context),
        actions: [
          GestureDetector(
            onTap: () async {
              await cartController.fetchCartItems().then((value) {
                Future.delayed(
                  const Duration(milliseconds: 1),
                  () {
                    cartController.setTotalPriceAndCheckAll();
                    cartController.isEditMode.value = false;
                    cartController.fetchCartItems();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ));
                  },
                );
              });
            },
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 5),
                child: CartIconWithBadge(itemCount: cartController.cartItems.length),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              //  auth.logout();
              await launchUrl(facbook);
            },
            child: const Padding(
              padding: EdgeInsets.only(bottom: 8, right: 15),
              child: Image(image: AssetImage(ImageKey.messengerIcon), height: 25, width: 30),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.grey.shade200,
        child: ListView(
          shrinkWrap: true,
          children: [
            //Banner khuyến mãi
            SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height / 6, child: const SlideShowBanner()),
            const Divider(),

            //Danh mục sản phẩm
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Danh mục",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 15, child: const Categories()),
              ],
            ),
            const Divider(),

            //Danh sách sản phẩm
            const Product(),
          ],
        ),
      ),
    );
  }
}

String priceFormat(int price) {
  final priceOutput = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  return priceOutput.format(price);
}
