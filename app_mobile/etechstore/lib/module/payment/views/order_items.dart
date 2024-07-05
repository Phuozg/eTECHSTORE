import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/payment/controllers/order_controller.dart';
import 'package:etechstore/module/payment/controllers/order_items_controller.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
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
    final ProductSampleController productController =
        Get.put(ProductSampleController());

    return Obx(() {
      if (orderItemController.orderItem.isEmpty) {
        return const Center(
          child: Text("Không có dữ liệu"),
        );
      }
      return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Color(0xFF383CA0), spreadRadius: 1),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height / 2.5,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('GioHang')
                  .where('maKhachHang',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .where('trangThai', isEqualTo: 1)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final carts = snapshot.data!.docs;
                if (carts.isEmpty) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (context, index) {
                      CartModel item = controller.cartItems[index];

                      final cart = carts[index];
                      final iteProductm = orderItemController.orderItem[index];
                      String selectedColor = item.maSanPham['mauSac'];
                      String selectedConfig = item.maSanPham['cauHinh'];
                      int quantity = item.soLuong;
                      orderController.addListModel(selectedColor,
                          selectedConfig, item.maSanPham['maSanPham']);
                      final productSample =
                          productController.productSamples.firstWhere(
                        (p) => p.MaSanPham == item.maSanPham['maSanPham'],
                        orElse: () => ProductSampleModel(
                            id: '',
                            MaSanPham: '',
                            soLuong: 0,
                            mauSac: [],
                            cauHinh: [],
                            giaTien: []),
                      );

                      return Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 7,
                                  child: Image.network(iteProductm.thumbnail)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      iteProductm.Ten,
                                      softWrap: true,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(priceFormat(
                                            (iteProductm.GiaTien).toInt())),
                                        Text(
                                            "SL: ${cart['soLuong'].toString()}"),
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
              }),
        ),
      );
    });
  }
}
