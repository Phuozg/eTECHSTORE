import 'package:etechstore/module/home/models/product_model_home.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/payment/controllers/order_controller.dart';
import 'package:etechstore/module/payment/controllers/payment_controller.dart';
import 'package:etechstore/module/payment/controllers/vnpay_payment_controller.dart';
import 'package:etechstore/module/payment/views/address_user.dart';
import 'package:etechstore/module/payment/views/vnpay_screen.dart';
import 'package:etechstore/module/sample/product_horizontal_listtile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyNowScreen extends StatelessWidget {
  const BuyNowScreen(
      {super.key,
      required this.productID,
      required this.quantity,
      required this.price,
      required this.color,
      required this.config});
  final String productID;
  final int quantity;
  final String price;
  final String color;
  final String config;
  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final paymentController = Get.put(PaymentController());
    final orderController = Get.put(OrderController());
    final product = orderController.getProductByID(productID);
    final vnPayController = Get.put(VNPAY());
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            color: const Color(0xFF383CA0),
          ),
          title: const Text(
            'Thanh toán',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: const BackButton(
            color: Colors.white,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            address(userID),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: productHorizontalListTile(context, product)),
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Color(0xFF383CA0), spreadRadius: 1),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            paymentController.selectPaymentMethod(context);
                          },
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Phương thức thanh toán",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text("Thay đổi")
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image(
                                    image: AssetImage(
                                      paymentController
                                          .selectedPaymentMethod.value.icon,
                                    ),
                                    fit: BoxFit.contain,
                                    height: 60,
                                  ),
                                  const VerticalDivider(),
                                  Text(paymentController
                                      .selectedPaymentMethod.value.ten),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Text(
                          "Tổng tiền: ${int.parse(price)}",
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
              ),
            )
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
              onPressed: () async {
                if (orderController.checkAddressUser(userID)) {
                  if (paymentController.selectedPaymentMethod.value.ten ==
                      'VNPay') {
                    await vnPayController.getUrlPayment(int.parse(price));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VNPAYScreen(
                                url: vnPayController.urlVNPay.value)));
                  } else {
                    orderController.processOrderBuyNow(userID, int.parse(price),
                        productID, quantity, color, config);
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Thiếu thông tin !!!'),
                        content: const Text(
                            'Tài khoản của bạn cần cung cấp thông tin số điện thoại và địa chỉ để mua hàng'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF383CA0)),
              child: Text(
                'Đặt hàng \n ${int.parse(price)}',
                style: const TextStyle(color: Colors.white, fontSize: 15),
                textAlign: TextAlign.center,
              )),
        ));
  }
}
