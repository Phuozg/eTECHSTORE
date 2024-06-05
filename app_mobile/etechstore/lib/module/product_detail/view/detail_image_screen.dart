import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class DetailImageScreen extends GetView {
  const DetailImageScreen({super.key, required this.imageUrl});
  final imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              )),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: FadeInImage.assetNetwork(
                image: imageUrl,
                placeholder: ImageKey.whiteBackGround,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text("Lỗi kết nối"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
