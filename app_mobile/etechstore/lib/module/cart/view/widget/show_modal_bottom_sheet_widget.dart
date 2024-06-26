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

class ShowCustomModalBottomSheet extends StatefulWidget {
  final ProductSampleModel sample;

  final String thumbnail;
  final int GiaTien;
  final int KhuyenMai;
  final String id;
  final CartModel item;

  const ShowCustomModalBottomSheet(
      {super.key,
      required this.sample,
      required this.thumbnail,
      required this.GiaTien,
      required this.KhuyenMai,
      required this.id,
      required this.item});

  @override
  _ShowCustomModalBottomSheetState createState() => _ShowCustomModalBottomSheetState();
}

class _ShowCustomModalBottomSheetState extends State<ShowCustomModalBottomSheet> {
  final NetworkManager network = Get.put(NetworkManager());
  ProductSampleController controller = Get.put(ProductSampleController());
  @override
  void initState() {
    controller.resetIndex();
    super.initState();
    controller.fetchProductAttributes(widget.id).then((product) {
      setState(() {
        controller.colors = product!.mauSac;
        controller.storages = product.cauHinh;
        controller.priceMap = product.giaTien;
        if (controller.colors.isNotEmpty) {
          controller.selectedColor1 = controller.colors.first;
        }
        if (controller.storages.isNotEmpty) {
          controller.selectedStorage = controller.storages.first;
        }
        controller.updatePrice();
      });
    });
  }

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
      padding: EdgeInsets.only(left: 20.w, top: 5),
      width: double.infinity,
      height: controller.selectedColor1.isEmpty || controller.selectedStorage.isEmpty ? 280.h : 450.h,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(context),
            controller.selectedColor1.isNotEmpty ? buildColorOptions() : Container(),
            controller.selectedStorage.isNotEmpty ? buildConfigOptions() : Container(),
            buildQuantitySelector(),
            buildAddToCartButton(context, widget.item),
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
                        controller.price == 0
                            ? Text(
                                "${priceFormat(widget.GiaTien - (widget.GiaTien * widget.KhuyenMai) ~/ 100)} ",
                                style: TColros.red_18_w500,
                              )
                            : Text(
                                "${priceFormat(controller.price)} ",
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

  Widget buildColorOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
          child: const Text("Màu sắc", style: TColros.black_13_w500),
        ),
        Wrap(
          spacing: 8,
          children: controller.colors.map((color) {
            return ChoiceChip(
              checkmarkColor: Colors.redAccent,
              shape: ContinuousRectangleBorder(
                side: const BorderSide(color: Colors.black, width: .2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: const MaterialStatePropertyAll(Colors.transparent),
              label: Text(color),
              selected: controller.selectedColor1 == color,
              onSelected: (selected) {
                setState(() {
                  controller.selectedColor1 = color;
                  controller.updatePrice();
                });
              },
            );
          }).toList(),
        )
      ],
    );
  }

  Widget buildConfigOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25.h, bottom: 9.h),
          child: const Text("Loại", style: TColros.black_14_w500),
        ),
        Wrap(
          spacing: 8,
          children: controller.storages.map((storage) {
            return ChoiceChip(
              checkmarkColor: Colors.redAccent,
              shape: ContinuousRectangleBorder(
                side: const BorderSide(color: Colors.black, width: .2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: const MaterialStatePropertyAll(Colors.transparent),
              label: Text(storage),
              selected: controller.selectedStorage == storage,
              onSelected: (selected) {
                setState(() {
                  controller.selectedStorage = storage;
                  controller.updatePrice();
                });
              },
            );
          }).toList(),
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
          margin: const EdgeInsets.only(right: 15, top: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(width: .4)),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    controller.quantity--;
                  });
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
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: const BoxDecoration(border: Border(left: BorderSide(width: .4), right: BorderSide(width: .4))),
                  alignment: Alignment.center,
                  height: 20,
                  width: 25,
                  child: Text("${controller.quantity}"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    controller.quantity++;
                  });
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

  Widget buildAddToCartButton(BuildContext context, CartModel item) {
    final CartController controller = Get.put(CartController());
    ProductSampleController controllerSample = Get.put(ProductSampleController());

    return ScreenUtilInit(
      builder: (context, child) => GestureDetector(
        onTap: () {
          controllerSample.selectedColor1 = controllerSample.selectedColor1;
          controllerSample.selectedStorage = controllerSample.selectedStorage;
          item.maSanPham['mauSac'] = controllerSample.selectedColor1;
          item.maSanPham['cauHinh'] = controllerSample.selectedStorage;
          item.soLuong = controllerSample.quantity.value;
          controller.updateCartItem(item);
          Navigator.pop(context);
        },
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(right: 35, top: 20),
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
