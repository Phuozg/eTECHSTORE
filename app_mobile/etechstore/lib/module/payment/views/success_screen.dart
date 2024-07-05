import 'package:etechstore/module/bottom_nav_bar/nav_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Đặt hàng hoàn tất!",
              style: TextStyle(color: Color(0xFF383CA0), fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text("Đơn hàng của bạn sẻ được giao sớm"),
            ElevatedButton(
                onPressed: () {
                  Get.off(() => const NavMenu());
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF383CA0)),
                child: const Text(
                  "Tiếp tục",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
