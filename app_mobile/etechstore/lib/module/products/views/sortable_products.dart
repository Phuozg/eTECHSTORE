import 'package:etechstore/module/home/controllers/product_controller.dart';
import 'package:etechstore/module/home/models/product_model_home.dart';
import 'package:etechstore/module/sample/product_vertical_sample.dart';
import 'package:flutter/material.dart';
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Obx(
                () => SizedBox(
                  width: MediaQuery.of(context).size.width,
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
              // IconButton(
              //     onPressed: () {
              //       // Rx<RangeValues> selectedRange =
              //       //     const RangeValues(0.0, 100000000.0).obs;

              //       // showDialog(
              //       //   context: context,
              //       //   builder: (BuildContext context) {
              //       //     return AlertDialog(
              //       //       title: const Text('Tiêu chí'),
              //       //       content: Column(
              //       //         children: [
              //       //           Obx(() {
              //       //             return Row(
              //       //               mainAxisAlignment:
              //       //                   MainAxisAlignment.spaceBetween,
              //       //               children: [
              //       //                 Text(priceFormat(
              //       //                     selectedRange.value.start.toInt())),
              //       //                 Text(priceFormat(
              //       //                     selectedRange.value.end.toInt()))
              //       //               ],
              //       //             );
              //       //           }),
              //       //           Obx(() => RangeSlider(
              //       //                 values: selectedRange.value,
              //       //                 min: 0,
              //       //                 max: 100000000,
              //       //                 onChanged: (RangeValues newRange) {
              //       //                   selectedRange.value = newRange;
              //       //                 },
              //       //               )),
              //       //         ],
              //       //       ),
              //       //       actions: [
              //       //         Row(
              //       //           children: [
              //       //             TextButton(
              //       //               onPressed: () {
              //       //                 productController.filter(
              //       //                     selectedRange.value.start,
              //       //                     selectedRange.value.end);
              //       //                 Navigator.of(context).pop();
              //       //               },
              //       //               child: const Text('Xem kết quả'),
              //       //             ),
              //       //             TextButton(
              //       //               onPressed: () {
              //       //                 Navigator.of(context).pop();
              //       //               },
              //       //               child: const Text('Đóng'),
              //       //             ),
              //       //           ],
              //       //         )
              //       //       ],
              //       //     );
              //       //   },
              //       // );
              //     },
              //     icon: const Icon(Icons.filter_alt)),
            ],
          ),
          productVerticalSample(context, widget.products)
        ],
      ),
    );
  }
}
