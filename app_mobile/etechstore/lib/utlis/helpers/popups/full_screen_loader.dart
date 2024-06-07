import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/popups/animation_loader.dart';
import 'package:etechstore/utlis/helpers/popups/animation_wait.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      barrierDismissible: false,
      context: Get.overlayContext!,
      builder: (_) => PopScope(
        canPop: false,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              AnimationLoaderWidget(text: text, animation: animation)
            ],
          ),
        ),
      ),
    );
  }

  static void openWaitforchange(String text, String animation) {
    showDialog(
      barrierDismissible: false,
      context: Get.overlayContext!,
      builder: (_) => PopScope(
        canPop: false,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              AnimationWaitWidget(text: text, animation: animation)
            ],
          ),
        ),
      ),
    );
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }

  static void show(BuildContext ctx, String hinhAnh, int soLuong, String mauSac, int giaTien, String ten, String giamGia) {
    showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      elevation: 10,
      backgroundColor: Colors.white,
      context: ctx,
      builder: (ctx) => Container(
        padding: const EdgeInsets.only(top: 20, left: 30),
        width: double.infinity,
        height: 375,
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 120,
                    height: 110,
                    child: Image.network(
                      hinhAnh,
                      fit: BoxFit.fill,
                    )),
                const SizedBox(width: 13),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: const SizedBox(
                            width: 15,
                            height: 12,
                            child: (Image(
                              image: AssetImage(ImageKey.iconVoucher),
                              fit: BoxFit.fill,
                            )),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              priceFormat((giaTien)),
                              style: TColros.red_18_w500,
                            ),
                            Text(
                              giamGia,
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                                color: Color(0xFFC4C4C4),
                              ),
                            )
                          ],
                        ),
                        //   IconButton(onPressed: () {}, icon: const Icon(Icons.close))
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 25, bottom: 9),
              child: Text("Phân loại", style: TColros.black_13_w500),
            ),
            Row(
              children: [
                Container(width: 30, height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.red)),
                const SizedBox(width: 25),
                Container(width: 30, height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.green)),
                const SizedBox(width: 25),
                Container(width: 30, height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.yellow))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Số lượng", style: TColros.black_13_w500),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(border: Border.all(width: .5), borderRadius: BorderRadius.circular(30), color: const Color(0xFFF3F3F4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        child: Container(child: const Text("-", style: TColros.black_20_w600)),
                        onTap: () {

                          // controller.addToCart();
                        },
                      ),
                      const Text(
                        "3",
                      ),
                      GestureDetector(
                        child: Container(child: const Text("+", style: TColros.black_14_w600)),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(left: 5),
                alignment: Alignment.center,
                width: 287,
                height: 40,
                decoration: BoxDecoration(
                  color: TColros.purple_line,
                  border: Border.all(width: .5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      TTexts.themVaoGioHang,
                      style: TColros.white_14_w600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
