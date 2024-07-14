import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/controller/enum.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/cart/view/widget/bottom_cart_widget.dart';
import 'package:etechstore/module/cart/view/widget/cart_is_empty_widget.dart';
import 'package:etechstore/module/cart/view/widget/change_quantity_item_widget.dart';
import 'package:etechstore/module/cart/view/widget/check_box_all_product_widget.dart';
import 'package:etechstore/module/cart/view/widget/delete_item_widget.dart';
import 'package:etechstore/module/cart/view/widget/pay_cart_item_widget.dart';
import 'package:etechstore/module/cart/view/widget/price_product_item_widget.dart';
import 'package:etechstore/module/cart/view/widget/show_modal_bottom_sheet_widget.dart';
import 'package:etechstore/module/cart/view/widget/type_product_item_widget.dart';
import 'package:etechstore/module/fake/simmer.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/payment/controllers/order_items_controller.dart';
import 'package:etechstore/module/payment/views/order_screen.dart';
import 'package:etechstore/module/product_detail/controller/product_controller.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
import 'package:etechstore/module/product_detail/view/widget/sample_bottom_sheet.dart';
import 'package:etechstore/utlis/connection/network_manager.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/line/line_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.put(CartController());
    final ProductSampleController productController =
        Get.put(ProductSampleController());
    final NetworkManager network = Get.put(NetworkManager());

    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        backgroundColor: const Color(0xFFF3F3F4),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF3F3F4),
          title: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30.w,
                ),
                const Text("Giỏ hàng", style: TColros.black_18),
                controller.cartItems.isNotEmpty
                    ? Text(
                        " (${controller.cartItems.length})",
                        style: const TextStyle(fontSize: 14),
                      )
                    : const Text(
                        " (0)",
                        style: TextStyle(fontSize: 14),
                      )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.toggleEditMode();
              },
              child: const Text("Sửa", style: TColros.black_14_w400),
            )
          ],
        ),
        body: Obx(() {
          if (controller.cartItems.isEmpty) {
            return const CartIsEmptyWdiget();
          } else {
            return RefreshIndicator(
                displacement: 3,
                onRefresh: controller.fetchCartItems,
                child: Column(children: [
                  Expanded(
                      child: network.isConnectedToInternet.value
                          ? StreamBuilder<List<ProductSampleModel>>(
                              stream: productController.getSampleProduct(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return ListView.builder(
                                    itemCount: controller.cartItems.length,
                                    itemBuilder: (context, index) {
                                      CartModel item =
                                          controller.cartItems[index];
                                      String selectedColor =
                                          item.maSanPham['mauSac'];
                                      String selectedConfig =
                                          item.maSanPham['cauHinh'];
                                      int quantity = item.soLuong;
                                      final productSample = productController
                                          .productSamples
                                          .firstWhere(
                                        (p) =>
                                            p.MaSanPham ==
                                            item.maSanPham['maSanPham'],
                                        orElse: () => ProductSampleModel(
                                            id: '',
                                            MaSanPham: '',
                                            soLuong: 0,
                                            mauSac: [],
                                            cauHinh: [],
                                            giaTien: []),
                                      );
                                      final product = controller.products[
                                          item.maSanPham['maSanPham']]!;

                                      final price = controller.calculatePrice(
                                          productSample,
                                          product,
                                          selectedColor,
                                          selectedConfig);

                                      return Slidable(
                                        endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            children: [DeleteItem(item: item)]),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.topCenter,
                                                width: double.infinity,
                                                height: 100.h,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 6.w,
                                                    vertical: 3.h),
                                                decoration: BoxDecoration(
                                                    border: null,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            11.r),
                                                    color: Colors.white),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Obx(
                                                          () => Transform.scale(
                                                            scale: 1,
                                                            child: Checkbox(
                                                                checkColor:
                                                                    Colors
                                                                        .white,
                                                                activeColor: Colors
                                                                    .deepOrange,
                                                                value: controller.selectedItems[
                                                                        item
                                                                            .id] ??
                                                                    false,
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                onChanged:
                                                                    (bool?
                                                                        val) {
                                                                  controller
                                                                      .toggleSelectedItem(
                                                                          item.id,
                                                                          val!);
                                                                }),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            DetailScreen(
                                                                              GiaTien: product.giaTien,
                                                                              KhuyenMai: product.KhuyenMai,
                                                                              MaDanhMuc: product.maDanhMuc,
                                                                              MoTa: product.moTa,
                                                                              Ten: product.ten,
                                                                              TrangThai: product.trangThai,
                                                                              id: product.id,
                                                                              thumbnail: product.thumbnail,
                                                                              HinhAnh: product.hinhAnh,
                                                                              isPopular: product.isPopular,
                                                                              NgayNhap: product.NgayNhap,
                                                                            )));
                                                          },
                                                          child: SizedBox(
                                                            width: 70.w,
                                                            height: 60.h,
                                                            child: product !=
                                                                    null
                                                                ? FadeInImage
                                                                    .assetNetwork(
                                                                    image: product
                                                                        .thumbnail,
                                                                    placeholder:
                                                                        ImageKey
                                                                            .whiteBackGround,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    imageErrorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return Center(
                                                                          child:
                                                                              Image.asset(ImageKey.whiteBackGround));
                                                                    },
                                                                  )
                                                                : null,
                                                          ),
                                                        ),
                                                        SizedBox(width: 15.w),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                                height: 13.w),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              DetailScreen(
                                                                            GiaTien:
                                                                                product.giaTien,
                                                                            KhuyenMai:
                                                                                product.KhuyenMai,
                                                                            MaDanhMuc:
                                                                                product.maDanhMuc,
                                                                            MoTa:
                                                                                product.moTa,
                                                                            Ten:
                                                                                product.ten,
                                                                            TrangThai:
                                                                                product.trangThai,
                                                                            id: product.id,
                                                                            thumbnail:
                                                                                product.thumbnail,
                                                                            HinhAnh:
                                                                                product.hinhAnh,
                                                                            isPopular:
                                                                                product.isPopular,
                                                                            NgayNhap:
                                                                                product.NgayNhap,
                                                                          ),
                                                                        ));
                                                                  },
                                                                  child:
                                                                      SizedBox(
                                                                    width:
                                                                        210.w,
                                                                    child: product !=
                                                                            null
                                                                        ? Text(
                                                                            product
                                                                                .ten,
                                                                            style:
                                                                                TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                                                                            overflow: TextOverflow.ellipsis,
                                                                            softWrap: true)
                                                                        : const Text('Loading...'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  for (final sample in productController
                                                                      .productSamples
                                                                      .where((p0) =>
                                                                          product
                                                                              .id ==
                                                                          p0.MaSanPham)) {
                                                                    productController
                                                                        .setSelectedColorIndex(
                                                                            0,
                                                                            sample);
                                                                    productController
                                                                        .setSelectedConfigIndex(
                                                                            0,
                                                                            sample);
                                                                    productController.checkPrice(
                                                                        sample,
                                                                        price
                                                                            .toString());
                                                                    if (sample
                                                                            .cauHinh
                                                                            .isEmpty &&
                                                                        sample
                                                                            .mauSac
                                                                            .isEmpty) {
                                                                      return;
                                                                    } else {
                                                                      showModalBottomSheet(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (ctx) {
                                                                          return ShowCustomModalBottomSheet(
                                                                            cart:
                                                                                item,
                                                                            GiaTien:
                                                                                product.giaTien,
                                                                            KhuyenMai:
                                                                                product.KhuyenMai,
                                                                            sample:
                                                                                sample,
                                                                            thumbnail:
                                                                                product.thumbnail,
                                                                            id: product.id,
                                                                          );
                                                                        },
                                                                      );
                                                                    }
                                                                  }
                                                                },
                                                                child: selectedConfig
                                                                            .isNotEmpty ||
                                                                        selectedColor
                                                                            .isNotEmpty
                                                                    ? TypeProductItemWidget(
                                                                        selectedColor:
                                                                            selectedColor,
                                                                        selectedConfig:
                                                                            selectedConfig,
                                                                      )
                                                                    : Container()),
                                                            SizedBox(
                                                                height: 5.h),
                                                            PriceProductItemWidget(
                                                              product: product,
                                                              pirce: price != 0
                                                                  ? priceFormat(
                                                                      price)
                                                                  : priceFormat((product
                                                                          .giaTien -
                                                                      product.giaTien *
                                                                          product
                                                                              .KhuyenMai ~/
                                                                          100)),
                                                            ),
                                                            SizedBox(
                                                                height: 3.h),
                                                            ChangeQuantityItemWidget(
                                                                item: item,
                                                                quantity: item
                                                                    .soLuong)
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            )
                          : LoadingListPage()),
                ]));
          }
        }),
        bottomNavigationBar: Container(
          color: Colors.blue,
          height: 65.h,
          width: double.infinity,
          child: BottomAppBar(
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: Obx(
                () => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    controller.isEditMode.value
                        ? const BottomCartWidget()
                        : const CheckBoxAllProductWidget(),
                    controller.isEditMode.value
                        ? Container()
                        : const PayCartItem(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
