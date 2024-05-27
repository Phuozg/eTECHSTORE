import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/controller/enum.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/fake/views/auth_controller.dart';
import 'package:etechstore/module/home/home_screen.dart';
import 'package:etechstore/module/product_detail/controller/product_controller.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.put(CartController());
    final AuthController auth = Get.put(AuthController());
    final ProductController productController = Get.put(ProductController());

    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
          backgroundColor: const Color(0xFFF3F3F4),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF3F3F4),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30.w,
                ),
                const Text("Giỏ hàng", style: TColros.black_18),
                const Text(
                  " (4)",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  auth.logout();
                },
                child: const Text("Sửa", style: TColros.black_14_w400),
              )
            ],
          ),
          body: ListView.builder(
            itemCount: controller.cartItems.length,
            itemBuilder: (context, index) {
              CartModel item = controller.cartItems[index];
              String selectedColor = item.maSanPham['mauSac'];
              String selectedConfig = item.maSanPham['cauHinh'];
              int quantity = item.soLuong;
              var product = controller.products[item.maSanPham['maSanPham']];

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        /*   Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                  GiaTien: product['GiaTien'],
                                  KhuyenMai: product['KhuyenMai'],
                                  MaDanhMuc: product['MaDanhMuc'],
                                  MoTa: product['MoTa'],
                                  SoLuong: product['SoLuong'],
                                  Ten: product['Ten'],
                                  TrangThai: product['TrangThai'],
                                  id: product['id'],
                                  thumbnail: product['thumbnail'],
                                  HinhAnh: product['HinhAnh']),
                            )); */
                      },
                      child: StreamBuilder(
                        stream: controller.calculateProductPrice(item),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text('Đang tính toán giá...');
                          }
                          if (snapshot.hasError) {
                            return const Text('Lỗi khi tính toán giá');
                          }
                          int productPrice = snapshot.data ?? 0;

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
                                    SizedBox(
                                      width: 70.w,
                                      height: 60.h,
                                      child: product != null
                                          ? Image.network(
                                              product.thumbnail,
                                              fit: BoxFit.fill,
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 15.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 13.w),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
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
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                ProductSampleModel sample = productController.productSamples[index];

                                                String selectedColor = sample.mauSac.first;
                                                String selectedConfig = sample.cauHinh.first;
                                                int quantity = 1;

                                                return StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setState) {
                                                    return Container(
                                                      padding: const EdgeInsets.all(16.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          const Text('Chọn màu sắc'),
                                                          SizedBox(
                                                            height: 100,
                                                            child: GridView.builder(
                                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount: 3,
                                                                mainAxisSpacing: 10,
                                                                crossAxisSpacing: 10,
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
                                                                    decoration: BoxDecoration(
                                                                      color: selectedColor == color ? Colors.blue : Colors.grey,
                                                                      borderRadius: BorderRadius.circular(8),
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(color, style: const TextStyle(color: Colors.white)),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(height: 16.0),
                                                          const Text('Chọn cấu hình'),
                                                          SizedBox(
                                                            height: 100,
                                                            child: GridView.builder(
                                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount: 3,
                                                                mainAxisSpacing: 10,
                                                                crossAxisSpacing: 10,
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
                                                                    decoration: BoxDecoration(
                                                                      color: selectedConfig == config ? Colors.blue : Colors.grey,
                                                                      borderRadius: BorderRadius.circular(8),
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(config, style: const TextStyle(color: Colors.white)),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(height: 16.0),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              const Text('Số lượng'),
                                                              Row(
                                                                children: [
                                                                  IconButton(
                                                                    icon: const Icon(Icons.remove),
                                                                    onPressed: () {
                                                                      if (quantity > 1) {
                                                                        setState(() {
                                                                          quantity--;
                                                                        });
                                                                      }
                                                                    },
                                                                  ),
                                                                  Text('$quantity'),
                                                                  IconButton(
                                                                    icon: const Icon(Icons.add),
                                                                    onPressed: () {
                                                                      setState(() {
                                                                        quantity++;
                                                                      });
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 16.0),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              final FirebaseAuth auth = FirebaseAuth.instance;

                                                              User? user = auth.currentUser;
                                                              var cartItem = CartModel(
                                                                id: sample.id,
                                                                maKhachHang: user!.uid, // Thay bằng mã khách hàng thực tế
                                                                soLuong: quantity,
                                                                trangThai: 1, // Trạng thái mặc định, có thể thay đổi tuỳ vào logic của bạn
                                                                maSanPham: {
                                                                  'maSanPham': sample.MaSanPham,
                                                                  'mauSac': selectedColor,
                                                                  'cauHinh': selectedConfig,
                                                                },
                                                              );
                                                              controller.addItemToCart(cartItem);
                                                            },
                                                            child: const Text('Thêm vào giỏ hàng'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                "Phân loại: ",
                                                style: TextStyle(color: Colors.grey.shade400),
                                              ),
                                              Text(
                                                '$selectedColor - ',
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                              Text(
                                                selectedConfig,
                                                style: const TextStyle(color: Colors.black),
                                              )
                                            ],
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
                                                    Text(
                                                      productPrice.toStringAsFixed(2),
                                                      style: TextStyle(color: const Color(0xFFEB4335), fontSize: 16.sp),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    const Text(
                                                      "4.700.000",
                                                      style: TextStyle(
                                                        decoration: TextDecoration.lineThrough,
                                                        inherit: true,
                                                        color: Color(0xFFC4C4C4),
                                                        fontWeight: FontWeight.w300,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: 60.w,
                                          height: 16.5.h,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: .5.w),
                                              borderRadius: BorderRadius.circular(5.r),
                                              color: const Color(0xFFF3F3F4)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                child: Container(child: const Text("-")),
                                                onTap: () {
                                                  if (quantity > 1) {
                                                    quantity--;
                                                    item.soLuong = quantity;
                                                    controller.updateCartItem(item);
                                                  }
                                                },
                                              ),
                                              Text(
                                                '$quantity',
                                                style: const TextStyle(fontSize: 14),
                                              ),
                                              GestureDetector(
                                                child: Container(child: const Text("+")),
                                                onTap: () {
                                                  quantity++;
                                                  item.soLuong = quantity;
                                                  controller.updateCartItem(item);
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: SizedBox(
            height: 65.h,
            width: double.infinity,
            child: BottomAppBar(
              color: Colors.white,
              child: Container(
                child: Obx(
                  () => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
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
                      SizedBox(width: 6.h),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6.h),
                              const Text("Tổng thanh toán", style: TextStyle(fontSize: 10)),
                              Text(
                                controller.totalPrice.value.toStringAsFixed(2),
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.redAccent),
                              ),
                              //  Text("Giảm 600.000", style: TextStyle(fontSize: 10.sp, color: const Color(0xFFCB291C)))
                            ],
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 114.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                                border: Border.all(width: .5.w), borderRadius: BorderRadius.circular(10.w), color: const Color(0xFFCB291C)),
                            child: const Text(
                              "Thanh thoán (0)",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
