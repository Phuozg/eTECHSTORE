import 'package:etechstore/module/home/controllers/category_controller.dart';
import 'package:etechstore/module/home/controllers/product_controller.dart';
import 'package:etechstore/module/products/views/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Categories extends StatelessWidget {
  const Categories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final productController = Get.put(ProductControllerr());
    return Obx(() {
      if (categoryController.allCategories.isEmpty) {
        return const Center(
          child: Text("Không có dữ liệu"),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        itemCount: categoryController.allCategories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final category = categoryController.allCategories[index];
          return Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => ProductScreen(
                                title: category.TenDanhMuc,
                                futureMethod: productController
                                    .getProductsForCate(catId: category.id),
                              )));
                },
                style: ElevatedButton.styleFrom(
                  // backgroundColor: const Color.fromARGB(255, 122, 125, 191),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MdiIcons.fromString(category.HinhAnh),
                      color: const Color(0xFF383CA0),
                    ),
                    Text(
                      category.TenDanhMuc,
                      style: const TextStyle(color: Color(0xFF383CA0)),
                    ),
                  ],
                )),
          );
        },
      );
    });
  }
}
