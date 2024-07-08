import 'package:etechstore/module/home/controllers/product_controller.dart';
import 'package:etechstore/module/home/models/product_model_home.dart';
import 'package:etechstore/module/sample/product_vertical_sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SortableProducts extends StatefulWidget {
  const SortableProducts({super.key, required this.products});
  final List<ProductModel> products;

  @override
  _SortableProductsState createState() => _SortableProductsState();
}

class _SortableProductsState extends State<SortableProducts> {
  final productController = Get.put(ProductControllerr());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.assignProducts(widget.products);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Obx(
                () => SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: DropdownButtonFormField(
                    decoration:
                        const InputDecoration(prefixIcon: Icon(Icons.sort)),
                    value: productController.selectedSortOption.value,
                    onChanged: (value) {
                      productController.sortProducts(value!);
                    },
                    items: [
                      'Tên',
                      'Giá cao',
                      'Giá thấp',
                      'Khuyến mãi',
                      'Mới nhất'
                    ]
                        .map((option) => DropdownMenuItem(
                            value: option, child: Text(option)))
                        .toList(),
                  ),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt)),
            ],
          ),
          Obx(() => productVerticalSample(context, productController.products))
        ],
      ),
    );
  }
}
