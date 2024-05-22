import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen1 extends GetView {
  const CartScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

    return Scaffold(
        appBar: AppBar(
          title: const Text('Giỏ Hàng'),
        ),
        body: ListView.builder(
          itemCount: CartController.products.length,
          itemBuilder: (context, index) {
            final product = CartController.products[index];
            return Column(
              children: [
                Card(
                  child: ListTile(
                    leading: Image.network(product['thumbnail']),
                    title: Text(product['Ten']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Giá: ${product['GiaTien']}'),
                        Text('Khuyến Mại: ${product['KhuyenMai']}'),
                        Text('Số Lượng: ${product['SoLuong']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        CartController.products.removeAt(index);
                        cartController.update(); // Notify listeners to update UI
                      },
                    ),
                  ),
                ),
                Obx(
                  () => Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.deepOrange,
                    value: cartController.selected.value == 2,
                    onChanged: (val) {
                      val ?? true ? cartController.selected.value = 2 : cartController.selected.value = null;
                      product;
                    },
                  ),
                ),
              ],
            );
          },
        ));
  }
}
