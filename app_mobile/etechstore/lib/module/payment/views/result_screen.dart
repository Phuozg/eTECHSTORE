import 'package:etechstore/module/bottom_nav_bar/nav_menu.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/payment/controllers/order_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.isSucces});
  final bool isSucces;

  @override
  Widget build(BuildContext context){
    final orderController = Get.put(OrderController());
    isSucces? orderController.processOrderwithVNPay(
                            FirebaseAuth.instance.currentUser!.uid,
                            CartController().instance.totalPrice.value.toInt()):0;
    return Scaffold(
      body: isSucces
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Đặt hàng hoàn tất!",
                    style: TextStyle(
                        color: Color(0xFF383CA0),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text("Đơn hàng của bạn sẻ được giao sớm"),
                  ElevatedButton(
                      onPressed: ()   {
                         
                          Get.off(()=>const NavMenu());
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF383CA0)),
                      child: const Text(
                        "Tiếp tục",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Có lỗi trong quá trình thanh toán",
                    style: TextStyle(
                        color: Color(0xFF383CA0),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text("Vui lòng thử lại"),
                  ElevatedButton(
                      onPressed: () {
                        Get.off(const NavMenu());
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF383CA0)),
                      child: const Text(
                        "Quay lại",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
    );
  }
}
