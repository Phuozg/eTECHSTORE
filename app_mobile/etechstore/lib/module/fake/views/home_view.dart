import 'package:etechstore/module/cart/view/prodct_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
 
class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ'),
      ),
      body: Obx(() {
        if (controller.products.isEmpty) {
          return Center(child: Text('Không có sản phẩm nào'));
        } else {
          return ListView.builder(
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              var product = controller.products[index];
              return ListTile(
                leading: Image.network(product.thumbnail),
                title: Text(product.ten),
                subtitle: Text(product.moTa),
                onTap: () {
                  Get.to(() => ProductView(product: product));
                },
              );
            },
          );
        }
      }),
    );
  }
}
