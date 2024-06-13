import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class DeleteItem extends StatefulWidget {
  DeleteItem({super.key, required this.item});
  CartModel item;
  @override
  State<DeleteItem> createState() => _DeleteItemState();
}

class _DeleteItemState extends State<DeleteItem> {
  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: (context) {
        controller.removeItemFromCart(widget.item);
      },
      backgroundColor: const Color(0xFFFE4A49),
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: 'Xóa',
    );
  }
}
