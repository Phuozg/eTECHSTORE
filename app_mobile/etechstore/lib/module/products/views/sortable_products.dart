import 'package:etechstore/module/home/controllers/product_controller.dart';
import 'package:etechstore/module/home/models/product_model.dart';
import 'package:etechstore/module/sample/product_vertical_sample.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SortableProducts extends StatelessWidget {
  const SortableProducts({super.key,required this.products});
  final List<ProductModel> products;
  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductControllerr());
    productController.assignProducts(products);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [ 
          DropdownButtonFormField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.sort)),
            value: productController.selectedSortOption.value,
            onChanged: (value){
              productController.sortProducts(value!);
            },
            items: ['Tên','Giá cao','Giá thấp','Khuyến mãi','Mới nhất']
            .map((option) => DropdownMenuItem(value: option,child: Text(option))).toList(),
            ),
          Obx(() => productVerticalSample(context,productController.products))
        ],
      ),
    );
  }
}