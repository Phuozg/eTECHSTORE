import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/view/cart_screen.dart';
import 'package:etechstore/module/chat_with_admin/view/chat_home_screen.dart';
import 'package:etechstore/module/fake/views/auth_controller.dart';
import 'package:etechstore/module/home/views/category.dart';
import 'package:etechstore/module/home/views/product.dart';
import 'package:etechstore/module/home/views/search_bar.dart';
import 'package:etechstore/module/home/views/slider_show.dart';
import 'package:etechstore/module/orders/controller/orders_controller.dart';
import 'package:etechstore/module/product_detail/controller/product_controller.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CartController cartController = Get.put(CartController());
  final ProductController productController = Get.put(ProductController());
  final ProductSampleController productSampleController = Get.put(ProductSampleController());
  final db = FirebaseFirestore.instance;
  final OrdersController ordersController = Get.put(OrdersController());
  final AuthController auth = Get.put(AuthController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ordersController.fetchIsPaid();
 productController.fetchProductSamples();
    cartController.fetchCartItems();
    productController.fetchProducts();
   productSampleController.fetchProductSamples();
  }

  @override
  Widget build(BuildContext context) {
    final Uri facbook = Uri.parse('https://www.facebook.com/messages/t/323929774140624');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.blue),
        ),
        title: searchBar(),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await cartController.fetchCartItems().then((value) {
                Future.delayed(
                  const Duration(milliseconds: 1),
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ));
                  },
                );
              });
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.blue,
            ),
            child: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                //  auth.logout();
                await launchUrl(facbook);
              },
              style: ElevatedButton.styleFrom(shape: const CircleBorder(), backgroundColor: Colors.blue),
              child: const Icon(
                Icons.message,
                color: Colors.white,
              )),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          children: [
            //Danh mục sản phẩm
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: SizedBox(height: MediaQuery.of(context).size.height / 15, child: category()),
            ),
            //Banner khuyến mãi
            SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height / 6, child: sliderShow()),

            //Danh sách sản phẩm
            product()
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
