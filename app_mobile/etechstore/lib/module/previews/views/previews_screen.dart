import 'package:etechstore/module/previews/controllers/preview_controller.dart';
import 'package:etechstore/module/previews/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreviewsScreen extends StatelessWidget {
  const PreviewsScreen({super.key, required this.productID});
  final String productID;
  @override
  Widget build(BuildContext context) {
    final previewsController = Get.put(PreviewsController());
    previewsController.fetchPreviews(productID);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Color(0xFF383CA0)),
          ),
          title: const Text(
            "Đánh giá",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Obx(() {
          if (previewsController.previewsOfProduct.isEmpty) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Color(0xFF383CA0), spreadRadius: 1),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Sản phẩm chưa có đánh giá nào"),
                ),
              ),
            );
          }
          return ListView.builder(
              itemCount: previewsController.previewsOfProduct.length,
              itemBuilder: (context, index) {
                final preview = previewsController.previewsOfProduct[index];
                final userPreview = previewsController.user.firstWhere(
                  (user) => user.uid == preview.MaKhachHang,
                  orElse: () => UserModel.empty(),
                );
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Color(0xFF383CA0), spreadRadius: 1),
                    ],
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Khách hàng:  ',
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                Text(userPreview.HoTen),
                              ],
                            ),
                            Row(
                              children: [
                                for (var i = 0; i < preview.SoSao; i++)
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                              ],
                            ),
                            Text(
                              softWrap: true,
                              preview.DanhGia,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              });
        }));
  }
}
