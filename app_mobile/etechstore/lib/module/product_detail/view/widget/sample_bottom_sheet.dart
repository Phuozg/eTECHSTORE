import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:etechstore/utlis/connection/network_manager.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SampleBottomSheet extends StatelessWidget {
  final ProductSampleModel sample;

  final String thumbnail;
  final String id;
  final int GiaTien;
  final int KhuyenMai;

  SampleBottomSheet({super.key, required this.sample, required this.thumbnail, required this.GiaTien, required this.id, required this.KhuyenMai});

  final NetworkManager network = Get.put(NetworkManager());

  ProductSampleController controller = Get.put(ProductSampleController());

  CartController cartController = Get.put(CartController());

  int quantity = 1;

  int price = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.0),
          topLeft: Radius.circular(40.0),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 25.w, top: 5.h),
      width: double.infinity,
      height: sample.cauHinh.isEmpty || sample.mauSac.isEmpty ? 280.h : 450.h,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(context),
            sample.mauSac.isNotEmpty ? buildColorOptions() : Container(),
            sample.cauHinh.isNotEmpty ? buildConfigOptions() : Container(),
            buildQuantitySelector(),
            buildAddToCartButton(context),
            const Padding(padding: EdgeInsets.only(bottom: 5))
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
              child: Container(
            margin: EdgeInsets.only(right: 40.w, bottom: 5),
            width: 40.w,
            height: 5.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color.fromARGB(126, 209, 207, 207)),
          )),
        ),
        const Padding(padding: EdgeInsets.only(top: 5)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 90.w,
                height: 80.h,
                child: Image.network(
                  thumbnail,
                  fit: BoxFit.fill,
                )),
            SizedBox(width: 13.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 5.h),
                      child: SizedBox(
                        width: 15.w,
                        height: 12.h,
                        child: (const Image(
                          image: AssetImage(ImageKey.iconVoucher),
                          fit: BoxFit.fill,
                        )),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Text(
                            ((controller.currentPrice.value)),
                            style: TColros.red_18_w500,
                          );
                        }),
                        Text(
                          "${priceFormat(GiaTien)} ",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14,
                            color: Color(0xFFC4C4C4),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildColorOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
          child: const Text("Màu sắc", style: TColros.black_13_w500),
        ),
        Obx(
          () => Wrap(
            spacing: 8,
            children: sample.mauSac.asMap().entries.map((entry) {
              int index = entry.key;
              String color = entry.value;
              return Column(
                children: [
                  ChoiceChip(
                    checkmarkColor: Colors.redAccent,
                    shape: ContinuousRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: .2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: const MaterialStatePropertyAll(Colors.transparent),
                    label: Text(color),
                    selected: controller.selectedColorIndex.value == index,
                    onSelected: (selected) {
                      controller.selectedColorIndex.value = index;
                      controller.checkPrice(sample, priceFormat((GiaTien - GiaTien * KhuyenMai ~/ 100)));
                    },
                  ),
                ],
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget buildConfigOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.h, bottom: 5.h),
          child: const Text("Loại", style: TColros.black_14_w500),
        ),
        Obx(
          () => Wrap(
            spacing: 8,
            children: sample.cauHinh.asMap().entries.map((entry) {
              int index = entry.key;
              String config = entry.value;
              return config.isNotEmpty
                  ? ChoiceChip(
                      checkmarkColor: Colors.redAccent,
                      shape: ContinuousRectangleBorder(
                        side: const BorderSide(color: Colors.black, width: .2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: const MaterialStatePropertyAll(Colors.transparent),
                      label: Text(config),
                      selected: controller.selectedConfigIndex.value == index,
                      onSelected: (selected) {
                        controller.selectedConfigIndex.value = index;
                        controller.checkPrice(sample, priceFormat((GiaTien - GiaTien * KhuyenMai ~/ 100)));
                      },
                    )
                  : Container();
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget buildQuantitySelector() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Số lượng", style: TColros.black_14_w500),
        Container(
          margin: const EdgeInsets.only(right: 15, top: 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(width: .4)),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  cartController.quantity.value--;
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: 20,
                  child: const Text(
                    "-",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Obx(() => Container(
                    decoration: const BoxDecoration(border: Border(left: BorderSide(width: .4), right: BorderSide(width: .4))),
                    alignment: Alignment.center,
                    height: 20,
                    width: 25,
                    child: Text("${cartController.quantity.value}"),
                  )),
              GestureDetector(
                onTap: () {
                  cartController.quantity.value++;
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: 20,
                  child: const Text("+"),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildAddToCartButton(BuildContext context) {
    final CartController cartController = Get.put(CartController());

    return ScreenUtilInit(
      builder: (context, child) => GestureDetector(
        onTap: () {
          String selectedColor = controller.selectedColorIndex.value < sample.mauSac.length ? sample.mauSac[controller.selectedColorIndex.value] : '';

          String selectedConfig =
              controller.selectedConfigIndex.value < sample.cauHinh.length ? sample.cauHinh[controller.selectedConfigIndex.value] : '';

          var maSanPham = {'maSanPham': sample.MaSanPham, 'mauSac': selectedColor, 'cauHinh': selectedConfig};
          final FirebaseAuth auth = FirebaseAuth.instance;
          User? user = auth.currentUser;
          var cartItem = CartModel(
            id: cartController.generateRandomString(20),
            maKhachHang: user!.uid,
            soLuong: cartController.quantity.value,
            trangThai: 0,
            maSanPham: maSanPham,
          );

          cartController.addItemToCart(cartItem);

          Navigator.pop(context);
        },
        child: Center(
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h, top: 20, right: 35.w),
            alignment: Alignment.center,
            width: 270.w,
            height: 35.h,
            decoration: BoxDecoration(
              color: TColros.purple_line,
              border: Border.all(width: .5),
              borderRadius: BorderRadius.circular(30.r),
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
      ),
    );
  }
}

class BuySampleSingle extends StatefulWidget {
  final ProductSampleModel sample;

  final String thumbnail;
  final int GiaTien;
  final int KhuyenMai;

  const BuySampleSingle({
    super.key,
    required this.sample,
    required this.thumbnail,
    required this.GiaTien,
    required this.KhuyenMai,
  });
  @override
  State<BuySampleSingle> createState() => _BuySampleSingleState();
}

class _BuySampleSingleState extends State<BuySampleSingle> {
  late String selectedColor;
  late String selectedConfig;
  int quantity = 1;
  CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.0),
          topLeft: Radius.circular(40.0),
        ),
      ),
      padding: EdgeInsets.only(left: 25.w, top: 5),
      width: double.infinity,
      height: 200.h,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(context),
            buildQuantitySelector(),
            buildAddToCartButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
              child: Container(
            margin: EdgeInsets.only(right: 40.w, bottom: 5),
            width: 35.w,
            height: 5.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color.fromARGB(126, 209, 207, 207)),
          )),
        ),
        const Padding(padding: EdgeInsets.only(top: 5)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 90.w,
                height: 80.h,
                child: Image.network(
                  widget.thumbnail,
                  fit: BoxFit.fill,
                )),
            SizedBox(width: 13.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 5.h),
                      child: SizedBox(
                        width: 15.w,
                        height: 12.h,
                        child: (const Image(
                          image: AssetImage(ImageKey.iconVoucher),
                          fit: BoxFit.fill,
                        )),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${priceFormat((widget.GiaTien - (widget.GiaTien * widget.KhuyenMai / 100)).round())} ",
                          style: TColros.red_18_w500,
                        ),
                        Text(
                          "${priceFormat(widget.GiaTien)} ",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14,
                            color: Color(0xFFC4C4C4),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildQuantitySelector() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Số lượng", style: TColros.black_14_w500),
        Container(
          margin: const EdgeInsets.only(right: 15, top: 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(width: .4)),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  controller.quantity.value--;
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: 20,
                  child: const Text(
                    "-",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Obx(() => Container(
                    decoration: const BoxDecoration(border: Border(left: BorderSide(width: .4), right: BorderSide(width: .4))),
                    alignment: Alignment.center,
                    height: 20,
                    width: 25,
                    child: Text("${controller.quantity.value}"),
                  )),
              GestureDetector(
                onTap: () {
                  controller.quantity.value++;
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: 20,
                  child: const Text("+"),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildAddToCartButton(BuildContext context) {
    final CartController cartController = Get.put(CartController());

    return ScreenUtilInit(
      builder: (context, child) => GestureDetector(
        onTap: () {
          final FirebaseAuth auth = FirebaseAuth.instance;
          User? user = auth.currentUser;
          var cartItem = CartModel(
            id: cartController.generateRandomString(20),
            maKhachHang: user!.uid,
            soLuong: cartController.quantity.value,
            trangThai: 0,
            maSanPham: {
              'maSanPham': widget.sample.MaSanPham,
              'mauSac': '',
              'cauHinh': '',
            },
          );
          cartController.addItemToCart(cartItem);
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.only(left: 18.w, bottom: 15.h, top: 20),
          alignment: Alignment.center,
          width: 260.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: TColros.purple_line,
            border: Border.all(width: .5),
            borderRadius: BorderRadius.circular(30.r),
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
    );
  }
}
