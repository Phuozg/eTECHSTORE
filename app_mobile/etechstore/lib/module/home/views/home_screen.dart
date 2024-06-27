import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/view/cart_screen.dart';
import 'package:etechstore/module/cart/view/widget/cart_icon_widget.dart';
import 'package:etechstore/module/home/views/category.dart';
import 'package:etechstore/module/home/views/product.dart';
import 'package:etechstore/module/home/views/search_bar.dart';
import 'package:etechstore/module/home/views/slideshow_banner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    final Uri facbook =
        Uri.parse('https://www.facebook.com/messages/t/323929774140624');
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
                    cartController.isEditMode.value = false;
                    cartController.setTotalPriceAndCheckAll();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(
                            price: 0,
                          ),
                        ));
                  },
                );
              });
            },
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: CartIconWithBadge(
                    itemCount: cartController.cartItems.length),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                //  auth.logout();
                await launchUrl(facbook);
              },
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFF383CA0)),
              child: const Icon(
                Icons.message,
                color: Colors.white,
              )),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.grey.shade200,
        child: ListView(
          shrinkWrap: true,
          children: [
            //Banner khuyến mãi
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 6,
                child: const SlideShowBanner()),
            const Divider(),

            //Danh mục sản phẩm
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Danh mục",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height / 15,
                    child: const Categories()),
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
