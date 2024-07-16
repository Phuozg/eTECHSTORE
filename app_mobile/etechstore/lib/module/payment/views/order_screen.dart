import 'dart:convert';

import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/payment/controllers/order_controller.dart';
import 'package:etechstore/module/payment/controllers/payment_controller.dart';
import 'package:etechstore/module/payment/controllers/vnpay_payment_controller.dart';
import 'package:etechstore/module/payment/controllers/zalo_pay_controller.dart';
import 'package:etechstore/module/payment/views/address_user.dart';
import 'package:etechstore/module/payment/views/order_items.dart';
import 'package:etechstore/module/payment/views/payment.dart';
import 'package:etechstore/module/payment/views/vnpay_screen.dart';
import 'package:etechstore/module/payment/views/zalo_screen.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final paymentController = Get.put(PaymentController());
    final orderController = Get.put(OrderController());
    final vnpayController = Get.put(VNPAY());
    final zalo = Get.put(ZaloPay());
    RxString response = ''.obs;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            address(userID),
            const OrderItem(),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Color(0xFF383CA0), spreadRadius: 1),
                ],
              ),
              child: const Column(
                children: [Payment()],
              ),
            ),
            Obx(() => Text(response.value))
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
            onPressed: () async {
              final controller = Get.put(ProductSampleController());
              if (orderController.checkAddressUser(userID) && controller.check(userID)) {
                if (paymentController.selectedPaymentMethod.value.ten == 'VNPay') {
                  await vnpayController.getUrlPayment(CartController().instance.totalPrice.value.toInt());
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VNPAYScreen(url: vnpayController.urlVNPay.value)));
                }
                if (paymentController.selectedPaymentMethod.value.ten == 'ZaloPay') {
                  final url = Uri.parse(zalo.createOrder(CartController().instance.totalPrice.value.toInt()));
                  final response = await http.get(url);
                  if (response.statusCode == 200) {
                    Map<String, dynamic> data = jsonDecode(response.body);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ZaloScreen(url: data['orderurl'])));
                    // print(data['orderurl']);
                  }
                }
                if (paymentController.selectedPaymentMethod.value.ten == 'Thanh toán khi nhận hàng') {
                  orderController.processOrder(userID, CartController().instance.totalPrice.value.toInt());
                }
              } else if (controller.check(userID)) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Column(
                        children: [
                          Text('Hết hàng !!!'),
                          Icon(
                            Icons.warning_amber,
                            size: 40,
                            color: Colors.red,
                          )
                        ],
                      ),
                      content: const Text('Sản phẩm tạm hết hàng, vui lòng thử lại sau hoặc liên hệ chúng tôi để được hỗ trợ'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF383CA0)),
                          child: const Text(
                            'Close',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Column(
                        children: [
                          Text('Thiếu thông tin !!!'),
                          Icon(
                            Icons.warning_amber,
                            size: 40,
                            color: Colors.red,
                          )
                        ],
                      ),
                      content: const Text('Tài khoản của bạn cần cung cấp thông tin số điện thoại và địa chỉ để mua hàng'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF383CA0)),
                          child: const Text(
                            'Close',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF383CA0)),
            child: Obx(() {
              return Text(
                'Đặt hàng \n ${priceFormat(CartController().instance.totalPrice.value.toInt())}',
                style: const TextStyle(color: Colors.white, fontSize: 15),
                textAlign: TextAlign.center,
              );
            })),
      ),
    );
  }
}
