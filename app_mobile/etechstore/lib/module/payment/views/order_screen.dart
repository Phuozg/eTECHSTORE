import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/payment/controllers/order_controller.dart';
import 'package:etechstore/module/payment/controllers/payment_controller.dart';
import 'package:etechstore/module/payment/controllers/vnpay_payment_controller.dart';
import 'package:etechstore/module/payment/views/address_user.dart';
import 'package:etechstore/module/payment/views/order_items.dart';
import 'package:etechstore/module/payment/views/payment.dart';
import 'package:etechstore/module/payment/views/vnpay_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final paymentController = Get.put(PaymentController());
    final orderController = Get.put(OrderController());
    final vnpayController = Get.put(VNPAY());
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
              if (paymentController.selectedPaymentMethod.value.ten ==
                  'VNPay') {
                await vnpayController.getUrlPayment(10000);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VNPAYScreen(url: vnpayController.urlVNPay.value)));
              } else {
                orderController.processOrder(
                    userID, CartController().instance.totalPrice.value.toInt());
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF383CA0)),
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
