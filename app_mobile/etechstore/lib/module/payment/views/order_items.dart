import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/payment/controllers/order_controller.dart';
import 'package:etechstore/module/payment/controllers/order_items_controller.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({super.key});

  @override
  Widget build(BuildContext context) {
    final orderItemController = Get.put(OrderItemsController());
    final orderController = Get.put(OrderController());
    orderController.listModel.clear();
    final CartController controller = Get.put(CartController());
    final ProductSampleController productController = Get.put(ProductSampleController());
    final FirebaseAuth auth = FirebaseAuth.instance;
    orderController.listModel.clear();

    String userId = auth.currentUser?.uid ?? '';

    return Obx(() {
      if (orderItemController.orderItem.isEmpty) {
        return const Center(
          child: Text("Không có dữ liệu"),
        );
      }
      return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(width: 1,color:const Color(0xFF383CA0) ),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height / 2.5,
          child: StreamBuilder<List<ProductModel>>(
            stream: productController.getProduct(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              List<ProductModel> data = snapshot.data!;
              List<ProductModel> lstProduct = data.toList();
              return StreamBuilder<List<CartModel>>(
                  stream: productController.getCarts(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    List<CartModel> carts = snapshot.data!;
                    List<CartModel> lstCart = carts.toList();
                    if (carts.isEmpty) {
                      return const CircularProgressIndicator();
                    }
                    List<CartModel> listcart = lstCart
                        .where((cart) =>
                            lstProduct.any((product) => product.id == cart.maSanPham['maSanPham']) &&
                            cart.trangThai == 1 &&
                            cart.maKhachHang == userId)
                        .toList();

                    return ListView.builder(
                        itemCount: listcart.length,
                        itemBuilder: (value, index) {
                          CartModel item = listcart[index];
                          ProductModel product = lstProduct.firstWhere((element) => element.id == item.maSanPham['maSanPham']);
                          String selectedColor = item.maSanPham['mauSac'];
                          String selectedConfig = item.maSanPham['cauHinh'];
                          final productSample = productController.productSamples.firstWhere((p) => p.MaSanPham == item.maSanPham['maSanPham']);
                          final price = controller.calculatePrice(productSample, product, selectedColor, selectedConfig);
                          orderController.addListModel(selectedColor, selectedConfig, item.maSanPham['maSanPham']);
                          return Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height / 7,width: MediaQuery.of(context).size.width/3, child: Image.network(product.thumbnail)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.ten,
                                          softWrap: true,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(priceFormat((price).toInt())),
                                            Text("SL: ${item.soLuong.toString()}"),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const Divider()
                            ],
                          );
                        });
                  });
            },
          ),
        ),
      );
    });
  }
}
