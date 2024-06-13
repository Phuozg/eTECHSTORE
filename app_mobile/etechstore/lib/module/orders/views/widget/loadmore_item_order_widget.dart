import 'package:etechstore/module/orders/controller/orders_controller.dart';
import 'package:etechstore/module/orders/views/detail_order_screen.dart';
import 'package:etechstore/utlis/helpers/line/line_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadMore extends StatefulWidget {
  const LoadMore({super.key, required this.maDonHang});
  final maDonHang;
  @override
  State<LoadMore> createState() => _LoadMoreState();
}

class _LoadMoreState extends State<LoadMore> {
  final OrdersController controller = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 1),
        GestureDetector(
          onTap: () {
            controller.loadMore();
            Get.to(DetailOrderSreen(maDonHang: widget.maDonHang));
          },
          child: Container(
              margin: const EdgeInsets.only(top: 5),
              alignment: Alignment.center,
              child: const Text("Xem thêm", style: TextStyle(color: Colors.grey, fontSize: 11))),
        )
      ],
    );
  }
}
