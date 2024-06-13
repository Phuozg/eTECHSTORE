import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/controller/enum.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/cart/view/widget/change_quantity_item_widget.dart';
import 'package:etechstore/module/cart/view/widget/delete_item_widget.dart';
import 'package:etechstore/module/fake/simmer.dart';
import 'package:etechstore/module/fake/views/auth_controller.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/payment/controllers/order_items_controller.dart';
import 'package:etechstore/module/payment/views/order_screen.dart';
import 'package:etechstore/module/product_detail/controller/product_controller.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
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
    final ProductSampleController productController = Get.put(ProductSampleController());
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
                Text(
                  " (${controller.selectedItems.length})",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.toggleEditMode();
                print(controller.isEditMode.value);
              },
              child: const Text("Sửa", style: TColros.black_14_w400),
            )
          ],
        ),
        body: Obx(() {
          if (controller.cartItems.isEmpty) {
            return Column(
              children: [
                SizedBox(height: 180.h),
                Image.asset(
                  ImageKey.cartEmpty,
                  width: 100.w,
                  height: 100.h,
                ),
                SizedBox(height: 20.h),
                const Center(
                    child: Text(
                  "Chưa có sản phẩm nào",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                )),
                const SizedBox(height: 60),
              ],
            );
          } else {
            return RefreshIndicator(
                displacement: 3,
                onRefresh: controller.fetchCartItems,
                child: Column(children: [
                  Expanded(
                      child: network.isConnectedToInternet.value
                          ? ListView.builder(
                              itemCount: controller.cartItems.length,
                              itemBuilder: (context, index) {
                                CartModel item = controller.cartItems[index];
                                String selectedColor = item.maSanPham['mauSac'];
                                String selectedConfig = item.maSanPham['cauHinh'];
                                int quantity = item.soLuong;
                                var product = controller.products[item.maSanPham['maSanPham']];
                                return Slidable(
                                  endActionPane: ActionPane(motion: const ScrollMotion(), children: [DeleteItem(item: item)]),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        StreamBuilder(
                                          stream: controller.calculateProductPrice(item),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return const Center(child: CircularProgressIndicator());
                                            }
                                            if (snapshot.hasError) {
                                              return const Text('Lỗi khi tính toán giá');
                                            }
                                            int productPrice = (snapshot.data ?? 0);

                                            return Container(
                                              alignment: Alignment.topCenter,
                                              width: double.infinity,
                                              height: 100.h,
                                              margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                                              decoration: BoxDecoration(border: null, borderRadius: BorderRadius.circular(11.r), color: Colors.white),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Obx(
                                                        () => Transform.scale(
                                                          scale: 1,
                                                          child: Checkbox(
                                                            checkColor: Colors.white,
                                                            activeColor: Colors.deepOrange,
                                                            value: controller.selectedItems[item.id],
                                                            side: BorderSide(color: Colors.grey.shade400),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                            onChanged: (val) {
                                                              controller.toggleItemSelection(item.id);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => DetailScreen(
                                                                    GiaTien: product!.giaTien,
                                                                    KhuyenMai: product.KhuyenMai,
                                                                    MaDanhMuc: product.maDanhMuc,
                                                                    MoTa: product.moTa,
                                                                    Ten: product.ten,
                                                                    TrangThai: product.trangThai,
                                                                    id: product.id,
                                                                    thumbnail: product.thumbnail,
                                                                    HinhAnh: product.hinhAnh),
                                                              ));
                                                        },
                                                        child: SizedBox(
                                                          width: 70.w,
                                                          height: 60.h,
                                                          child: product != null
                                                              ? FadeInImage.assetNetwork(
                                                                  image: product.thumbnail,
                                                                  placeholder: ImageKey.whiteBackGround,
                                                                  fit: BoxFit.cover,
                                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                                    return Center(child: Image.asset(ImageKey.whiteBackGround));
                                                                  },
                                                                )
                                                              : null,
                                                        ),
                                                      ),
                                                      SizedBox(width: 15.w),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 13.w),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => DetailScreen(
                                                                            GiaTien: product!.giaTien,
                                                                            KhuyenMai: product.KhuyenMai,
                                                                            MaDanhMuc: product.maDanhMuc,
                                                                            MoTa: product.moTa,
                                                                            Ten: product.ten,
                                                                            TrangThai: product.trangThai,
                                                                            id: product.id,
                                                                            thumbnail: product.thumbnail,
                                                                            HinhAnh: product.hinhAnh),
                                                                      ));
                                                                },
                                                                child: SizedBox(
                                                                  width: 210.w,
                                                                  child: product != null
                                                                      ? Text(
                                                                          product.ten,
                                                                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                                                                          overflow: TextOverflow.ellipsis,
                                                                          softWrap: true,
                                                                        )
                                                                      : const Text('Loading...'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              for (final sample
                                                                  in productController.productSamples.where((p0) => product?.id == p0.MaSanPham)) {
                                                                showModalBottomSheet(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    String selectedColor = sample.mauSac.first;
                                                                    String selectedConfig = sample.cauHinh.first;
                                                                    int quantity = 1;

                                                                    return StatefulBuilder(
                                                                      builder: (BuildContext context, StateSetter setState) {
                                                                        return Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            Container(
                                                                              color: Colors.white,
                                                                              width: double.infinity,
                                                                              child: Container(
                                                                                padding: EdgeInsets.only(top: 20.h, left: 30.w),
                                                                                width: double.infinity,
                                                                                height: 375,
                                                                                color: Colors.white,
                                                                                alignment: Alignment.center,
                                                                                child: SingleChildScrollView(
                                                                                  child:
                                                                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            SizedBox(
                                                                                                width: 90.w,
                                                                                                height: 80.h,
                                                                                                child: product?.thumbnail != null
                                                                                                    ? FadeInImage.assetNetwork(
                                                                                                        image: product!.thumbnail,
                                                                                                        placeholder: ImageKey.whiteBackGround,
                                                                                                        fit: BoxFit.cover,
                                                                                                        imageErrorBuilder:
                                                                                                            (context, error, stackTrace) {
                                                                                                          return Center(
                                                                                                              child: Image.asset(
                                                                                                                  ImageKey.whiteBackGround));
                                                                                                        },
                                                                                                      )
                                                                                                    : null),
                                                                                            const SizedBox(width: 13),
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
                                                                                                        height: 12.w,
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
                                                                                                        product?.giaTien != null &&
                                                                                                                product?.KhuyenMai != null
                                                                                                            ? Text(
                                                                                                                "${priceFormat((product!.giaTien - (product.giaTien * product.KhuyenMai / 100)).round())} ",
                                                                                                                style: TColros.red_18_w500,
                                                                                                              )
                                                                                                            : const Text('Loading...'),
                                                                                                        product?.giaTien != null
                                                                                                            ? Text(
                                                                                                                "${priceFormat(product!.giaTien)} ",
                                                                                                                style: TextStyle(
                                                                                                                  decoration:
                                                                                                                      TextDecoration.lineThrough,
                                                                                                                  fontSize: 14.sp,
                                                                                                                  color: const Color(0xFFC4C4C4),
                                                                                                                ),
                                                                                                              )
                                                                                                            : const Text("Loading...")
                                                                                                      ],
                                                                                                    ),
                                                                                                    GestureDetector(
                                                                                                      onTap: () {
                                                                                                        Navigator.pop(context);
                                                                                                      },
                                                                                                      child: Container(
                                                                                                          margin: EdgeInsets.only(
                                                                                                              left: 70.w, bottom: 40.h),
                                                                                                          padding: EdgeInsets.only(bottom: 20.h),
                                                                                                          alignment: Alignment.topRight,
                                                                                                          child: const Text(
                                                                                                            "x",
                                                                                                            style: TextStyle(
                                                                                                                fontSize: 20,
                                                                                                                fontWeight: FontWeight.w600),
                                                                                                          )),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: EdgeInsets.only(top: 25.h, bottom: 9.h),
                                                                                          child: const Text("Màu sắc", style: TColros.black_13_w500),
                                                                                        ),
                                                                                        Container(
                                                                                          color: Colors.white,
                                                                                          width: double.infinity,
                                                                                          height: 70.h,
                                                                                          child: GridView.builder(
                                                                                            shrinkWrap: true,
                                                                                            physics: const NeverScrollableScrollPhysics(),
                                                                                            gridDelegate:
                                                                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                                                              crossAxisCount: 3,
                                                                                              mainAxisExtent: 25,
                                                                                              mainAxisSpacing: 15,
                                                                                              crossAxisSpacing: CupertinoCheckbox.width,
                                                                                            ),
                                                                                            itemCount: sample.mauSac.length,
                                                                                            itemBuilder: (context, index) {
                                                                                              String color = sample.mauSac[index];
                                                                                              return GestureDetector(
                                                                                                onTap: () {
                                                                                                  setState(() {
                                                                                                    selectedColor = color;
                                                                                                  });
                                                                                                },
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  margin: EdgeInsets.only(right: 15.w),
                                                                                                  decoration: BoxDecoration(
                                                                                                    border: Border.all(
                                                                                                      width: 1,
                                                                                                      color: selectedColor == color
                                                                                                          ? Colors.redAccent
                                                                                                          : Colors.white,
                                                                                                    ),
                                                                                                    color: const Color.fromARGB(35, 158, 158, 158),
                                                                                                  ),
                                                                                                  child: Center(child: Text(color.toString())),
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: EdgeInsets.only(top: 10.h, bottom: 9.h),
                                                                                          child: const Text("Loại", style: TColros.black_14_w500),
                                                                                        ),
                                                                                        Container(
                                                                                          color: Colors.white,
                                                                                          width: double.infinity,
                                                                                          height: 70.h,
                                                                                          child: GridView.builder(
                                                                                            shrinkWrap: true,
                                                                                            physics: const NeverScrollableScrollPhysics(),
                                                                                            gridDelegate:
                                                                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                                                              crossAxisCount: 3,
                                                                                              mainAxisExtent: 25,
                                                                                              mainAxisSpacing: 15,
                                                                                              crossAxisSpacing: CupertinoCheckbox.width,
                                                                                            ),
                                                                                            itemCount: sample.cauHinh.length,
                                                                                            itemBuilder: (context, index) {
                                                                                              String config = sample.cauHinh[index];
                                                                                              return GestureDetector(
                                                                                                onTap: () {
                                                                                                  setState(() {
                                                                                                    selectedConfig = config;
                                                                                                  });
                                                                                                },
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  margin: EdgeInsets.only(right: 15.w),
                                                                                                  decoration: BoxDecoration(
                                                                                                    border: Border.all(
                                                                                                      width: 1,
                                                                                                      color: selectedConfig == config
                                                                                                          ? Colors.redAccent
                                                                                                          : Colors.white,
                                                                                                    ),
                                                                                                    color: const Color.fromARGB(35, 158, 158, 158),
                                                                                                  ),
                                                                                                  child: Center(child: Text(config.toString())),
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(height: 16.0.h),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            const Text("Số lượng", style: TColros.black_14_w500),
                                                                                            Container(
                                                                                              margin: EdgeInsets.only(right: 20.w),
                                                                                              width: 85.w,
                                                                                              height: 23.h,
                                                                                              decoration: BoxDecoration(
                                                                                                  border: Border.all(width: .5),
                                                                                                  borderRadius: BorderRadius.circular(30),
                                                                                                  color: const Color(0xFFF3F3F4)),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                children: [
                                                                                                  GestureDetector(
                                                                                                      onTap: () {
                                                                                                        if (quantity > 1) {
                                                                                                          setState(() {
                                                                                                            quantity--;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        width: 8.w,
                                                                                                        height: 2.h,
                                                                                                        color: Colors.black,
                                                                                                        alignment: Alignment.center,
                                                                                                        margin: EdgeInsets.only(left: 5.w),
                                                                                                      )),
                                                                                                  Container(
                                                                                                    height: double.infinity,
                                                                                                    color: Colors.black,
                                                                                                    width: .5,
                                                                                                  ),
                                                                                                  Container(
                                                                                                    padding: EdgeInsets.only(bottom: 1.h),
                                                                                                    child: Text(
                                                                                                      quantity.toString(),
                                                                                                      style: TextStyle(fontSize: 17.sp),
                                                                                                      textAlign: TextAlign.center,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    height: double.infinity,
                                                                                                    color: Colors.black,
                                                                                                    width: .5,
                                                                                                  ),
                                                                                                  GestureDetector(
                                                                                                    onTap: () {
                                                                                                      setState(() {
                                                                                                        quantity++;
                                                                                                      });
                                                                                                    },
                                                                                                    child: Container(
                                                                                                        margin: EdgeInsets.only(right: 5.w),
                                                                                                        child: const Text("+",
                                                                                                            style: TColros.black_14_w600)),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 16.0.h),
                                                                                        GestureDetector(
                                                                                          onTap: () {
                                                                                            selectedColor = selectedColor;
                                                                                            selectedConfig = selectedConfig;
                                                                                            item.maSanPham['mauSac'] = selectedColor;
                                                                                            item.maSanPham['cauHinh'] = selectedConfig;
                                                                                            item.soLuong = quantity;
                                                                                            controller.updateCartItem(item);
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                          child: Container(
                                                                                            margin: EdgeInsets.only(left: 10.w, bottom: 20.h),
                                                                                            alignment: Alignment.center,
                                                                                            width: 287.w,
                                                                                            height: 40.h,
                                                                                            decoration: BoxDecoration(
                                                                                              color: TColros.purple_line,
                                                                                              border: Border.all(width: .5),
                                                                                              borderRadius: BorderRadius.circular(30.r),
                                                                                            ),
                                                                                            child: const Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Xác nhận',
                                                                                                  style: TColros.white_14_w600,
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ]),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child: Container(
                                                              constraints: BoxConstraints(
                                                                maxWidth: MediaQuery.of(context).size.width * 2.5,
                                                              ),
                                                              alignment: Alignment.center,
                                                              width: 163.w,
                                                              height: 18.h,
                                                              color: const Color.fromARGB(58, 189, 189, 189),
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  Text(
                                                                    "Phân loại:",
                                                                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12.sp),
                                                                  ),
                                                                  Text(
                                                                    '$selectedColor  -',
                                                                    style: TextStyle(color: Colors.black, fontSize: 12.sp),
                                                                  ),
                                                                  Text(
                                                                    selectedConfig,
                                                                    style: TextStyle(color: Colors.black, fontSize: 12.sp),
                                                                  ),
                                                                  Container(
                                                                      margin: EdgeInsets.only(bottom: 9.h),
                                                                      child: const Icon(
                                                                        Icons.keyboard_arrow_down_outlined,
                                                                        size: 20,
                                                                      ))
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5.h),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      product?.giaTien != null || product?.KhuyenMai != null
                                                                          ? Text(
                                                                              "${priceFormat((product!.giaTien - (product.giaTien * product.KhuyenMai / 100)).round())} ",
                                                                              style: TextStyle(color: const Color(0xFFEB4335), fontSize: 16.sp),
                                                                            )
                                                                          : const Text("Loading..."),
                                                                      SizedBox(
                                                                        width: 5.w,
                                                                      ),
                                                                      product?.giaTien != null
                                                                          ? Text(
                                                                              priceFormat(product!.giaTien),
                                                                              style: const TextStyle(
                                                                                decoration: TextDecoration.lineThrough,
                                                                                inherit: true,
                                                                                color: Color(0xFFC4C4C4),
                                                                                fontWeight: FontWeight.w300,
                                                                              ),
                                                                            )
                                                                          : const Text("Loading..."),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 3.h),
                                                          ChangeQuantityItemWidget(item: item, quantity: quantity)
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
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
                        ? Row(
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 1,
                                    child: Checkbox(
                                      checkColor: Colors.white,
                                      activeColor: Colors.deepOrange,
                                      value: controller.isSelectAll.value,
                                      side: BorderSide(color: Colors.grey.shade400),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      onChanged: (val) {
                                        controller.toggleSelectAll();
                                      },
                                    ),
                                  ),
                                  Text(
                                    "Tất cả",
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
                                  ),
                                ],
                              ),
                              SizedBox(width: 39.w),
                              GestureDetector(
                                onTap: () {
                                  // Thêm vào yêu thích
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 7.h, vertical: 12.w),
                                  padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 3.5.w),
                                  decoration:
                                      BoxDecoration(border: Border.all(width: .5, color: Colors.redAccent), borderRadius: BorderRadius.circular(5.r)),
                                  child: Text(
                                    "Lưu vào yêu thích",
                                    style: TextStyle(fontSize: 12.sp, color: Colors.redAccent),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  List<CartModel> itemsToRemove = [];
                                  controller.selectedItems.forEach((id, isSelected) {
                                    if (isSelected) {
                                      CartModel? item = controller.cartItems.firstWhereOrNull((item) => item.id == id);
                                      if (item != null) {
                                        itemsToRemove.add(item);
                                      }
                                    }
                                  });

                                  // Xóa các mục đã chọn khỏi giỏ hàng
                                  for (var item in itemsToRemove) {
                                    controller.removeItemFromCart(item);
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 7.h, vertical: 12.w),
                                  padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(border: Border.all(width: .5), borderRadius: BorderRadius.circular(5.r)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Delete",
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Transform.scale(
                                scale: 1,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: Colors.deepOrange,
                                  value: controller.isSelectAll.value,
                                  side: BorderSide(color: Colors.grey.shade400),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  onChanged: (val) {
                                    controller.toggleSelectAll();
                                  },
                                ),
                              ),
                              Text(
                                "Tất cả",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
                              ),
                            ],
                          ),
                    controller.isEditMode.value
                        ? Container()
                        : Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 6.h),
                                  Text("Tổng thanh toán", style: TextStyle(fontSize: 10.sp)),
                                  Text(
                                    priceFormat(controller.totalPrice.value.toInt()),
                                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.redAccent),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10.w),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderScreen()));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 114.w,
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: .5.w),
                                    borderRadius: BorderRadius.circular(10.w),
                                    color: const Color(0xFFCB291C),
                                  ),
                                  child: Text(
                                    "Thanh thoán (${controller.selectedItems.length})",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
