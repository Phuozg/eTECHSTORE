import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/orders/controller/orders_controller.dart';
import 'package:etechstore/module/orders/model/detail_orders.dart';
import 'package:etechstore/module/orders/model/orders_model.dart';
import 'package:etechstore/module/product_detail/controller/product_controller.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
import 'package:etechstore/module/profile/controller/profile_controller.dart';
import 'package:etechstore/module/profile/model/profile_model.dart';
import 'package:etechstore/module/profile/views/edit_views/profile_edit_screen.dart';
import 'package:etechstore/utlis/constants/colors.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/helpers/line/line_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../home/views/home_screen.dart';

class DetailOrderSreen extends StatelessWidget {
  final OrdersController controller = Get.put(OrdersController());
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ProfileController profileController = Get.put(ProfileController());
  final CartController cartController = Get.put(CartController());

  DetailOrderSreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // Gọi hàm fetchProfiles để tải dữ liệu
    profileController.fetchProfilesStream(user!.uid);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 244),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F4),
        iconTheme: const IconThemeData(color: TColros.purple_line),
        title: const Text(
          'Thông tin đơn hàng',
          style: TColros.black_18,
        ),
        centerTitle: true,
      ),
      body: ScreenUtilInit(
        builder: (context, child) => StreamBuilder<List<OrdersModel>>(
          stream: controller.getOrder(),
          builder: (context, snapshotDonHang) {
            if (!snapshotDonHang.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            List<OrdersModel> donHangs = snapshotDonHang.data!;

            String currentUserUid = auth.currentUser?.uid ?? '';

            List<OrdersModel> userOrders = donHangs.where((order) => order.maKhachHang == currentUserUid).toList();
            print(currentUserUid);
            if (userOrders.isEmpty) {
              return Container(
                child: const Text('No orders found for current user.'),
              );
            }

            return StreamBuilder<List<ProductModel>>(
              stream: controller.getProduct(),
              builder: (context, snapshotProduct) {
                if (!snapshotProduct.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<ProductModel> sanPham = snapshotProduct.data!;

                  List<ProductModel> filterProduct = sanPham.toList();
                  List<OrdersModel> fillterOrder = donHangs.toList();
                  return StreamBuilder<List<DetailOrders>>(
                    stream: controller.getCTDonHangs(),
                    builder: (context, snapshotCTDonHang) {
                      if (!snapshotCTDonHang.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      List<DetailOrders> ctDonHangs = snapshotCTDonHang.data!;
                      List<DetailOrders> filteredCTDonHangs =
                          ctDonHangs.where((ctDonHang) => userOrders.any((donHang) => donHang.id == ctDonHang.maDonHang)).toList();

                      return StreamBuilder<List<ProfileModel>>(
                        stream: profileController.fetchProfilesStream(user.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No profiles found'));
                          } else {
                            final profiles = snapshot.data!;
                            List<OrdersModel> orders = [];

                            orders = fillterOrder.where((order) => order.maKhachHang == currentUserUid).toList();
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: profiles.length,
                                    itemBuilder: (context, index) {
                                      final profile = profiles[index];

                                      return ConstrainedBox(
                                        constraints: BoxConstraints(maxHeight: 100.h, minHeight: 100.h),
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.white,
                                          padding: EdgeInsets.only(left: 15.w, right: 5.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.location_on_outlined, size: 18.sp),
                                                      SizedBox(width: 5.w),
                                                      Text(
                                                        "Địa chỉ nhận hàng",
                                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),
                                                      ),
                                                    ],
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.to(EditProfileScreen());
                                                      },
                                                      child: const Text(
                                                        "Sửa",
                                                        style: TextStyle(color: TColros.purple_line),
                                                      ))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(profile.HoTen),
                                                  const Text(" | "),
                                                  Text("0${profile.SoDienThoai}"),
                                                ],
                                              ),
                                              Text(
                                                profile.DiaChi,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 3.h),
                                  Obx(
                                    () => ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: (controller.itemsToShow.value >= filteredCTDonHangs.length)
                                          ? filteredCTDonHangs.length
                                          : controller.itemsToShow.value + 1,
                                      itemBuilder: (context, index) {
                                        if (index == controller.itemsToShow.value) {
                                          return filteredCTDonHangs.length > controller.itemsToShow.value
                                              ? TextButton(
                                                  onPressed: controller.loadMore,
                                                  child: const Text('Xem thêm'),
                                                )
                                              : Container();
                                        }

                                        DetailOrders ctDonHang = filteredCTDonHangs[index];
                                        ProductModel product = filterProduct.firstWhere((p) => p.id == ctDonHang.maMauSanPham['MaSanPham']);
                                        OrdersModel order = fillterOrder.firstWhere((o) => o.id == ctDonHang.maDonHang);
                                        orders.add(order);
                                        return SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 5.w),
                                              GestureDetector(
                                                onTap: () {
                                                  cartController.fetchCartItems();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => DetailScreen(
                                                            GiaTien: product.giaTien,
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
                                                child: Container(
                                                  width: double.infinity,
                                                  color: Colors.white,
                                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                SizedBox(width: 3.w),
                                                                product.thumbnail != null
                                                                    ? GestureDetector(
                                                                        onTap: () {
                                                                          Get.to(DetailOrderSreen());
                                                                        },
                                                                        child: FadeInImage.assetNetwork(
                                                                          image: product.thumbnail.toString(),
                                                                          placeholder: ImageKey.whiteBackGround,
                                                                          width: 60.w,
                                                                          height: 60.h,
                                                                          fit: BoxFit.cover,
                                                                          imageErrorBuilder: (context, error, stackTrace) {
                                                                            return Center(
                                                                                child: Image.asset(
                                                                              ImageKey.whiteBackGround,
                                                                              width: 60.w,
                                                                              height: 60.h,
                                                                              fit: BoxFit.cover,
                                                                            ));
                                                                          },
                                                                        ))
                                                                    : Container(),
                                                                SizedBox(width: 20.w),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    product.ten != null
                                                                        ? GestureDetector(
                                                                            onTap: () {},
                                                                            child: SizedBox(
                                                                              width: 150.w,
                                                                              child: Text(
                                                                                product.ten,
                                                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
                                                                                overflow: TextOverflow.ellipsis,
                                                                                softWrap: true,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : const Text("Loading..."),
                                                                    SizedBox(height: 5.h),
                                                                    Row(
                                                                      children: [
                                                                        const Text("Loại:", style: TextStyle(color: Colors.grey)),
                                                                        ctDonHang.maMauSanPham['MauSac'] != null
                                                                            ? Text(" ${ctDonHang.maMauSanPham['MauSac']}",
                                                                                style: const TextStyle(fontWeight: FontWeight.w400))
                                                                            : const Text("Loading..."),
                                                                        Text(
                                                                          " | ",
                                                                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                                                        ),
                                                                        ctDonHang.maMauSanPham['CauHinh'] != null
                                                                            ? Text(" ${ctDonHang.maMauSanPham['CauHinh']}",
                                                                                style: const TextStyle(fontWeight: FontWeight.w400))
                                                                            : const Text("Loading..."),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Text("Số lượng: ",
                                                                            style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey)),
                                                                        ctDonHang.soLuong != null
                                                                            ? Text("${ctDonHang.soLuong}")
                                                                            : const Text("Loading..."),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10.h),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 160.0.w),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                priceFormat(product.giaTien),
                                                                style: const TextStyle(
                                                                  color: Colors.grey,
                                                                  decoration: TextDecoration.lineThrough,
                                                                ),
                                                              ),
                                                              SizedBox(width: 10.w),
                                                              Text(
                                                                priceFormat(ctDonHang.khuyenMai),
                                                                style: const TextStyle(fontWeight: FontWeight.w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 10.w),
                                                        Linehelper(color: const Color.fromARGB(94, 217, 217, 217), height: 1),
                                                        const SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            ctDonHang.soLuong != null
                                                                ? Text(
                                                                    "${ctDonHang.soLuong} sản phẩm",
                                                                    style: TextStyle(color: const Color.fromARGB(255, 41, 40, 40), fontSize: 13.sp),
                                                                  )
                                                                : const Text("Loading..."),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Thành tiền:",
                                                                  style: TextStyle(color: const Color.fromARGB(255, 41, 40, 40), fontSize: 15.sp),
                                                                ),
                                                                SizedBox(width: 5.w),
                                                                Text(
                                                                  priceFormat(ctDonHang.khuyenMai),
                                                                  style: TextStyle(
                                                                      fontSize: 15.sp, fontWeight: FontWeight.w500, color: Colors.redAccent),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  if (orders.isNotEmpty)
                                    Container(
                                        height: 120.h,
                                        color: Colors.white,
                                        width: double.infinity,
                                        margin: EdgeInsets.only(top: 8.h, bottom: 10.h),
                                        padding: EdgeInsets.only(left: 12.w, top: 10.h, bottom: 5.h, right: 5.w),
                                        child: Column(
                                          children: orders.map((order) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Chi tiết đơn hàng",
                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),
                                                ),
                                                SizedBox(height: 10.h),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Mã đơn hàng", style: TextStyle(fontSize: 13.sp)),
                                                    Text(order.id),
                                                  ],
                                                ),
                                                SizedBox(height: 5.h),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Phương thức thanh toán", style: TextStyle(fontSize: 13.sp)),
                                                    Text("Thanh toán qua ngân hàng", style: TextStyle(fontSize: 13.sp)),
                                                  ],
                                                ),
                                                SizedBox(height: 5.h),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Ngày đặt hàng", style: TextStyle(fontSize: 13.sp)),
                                                    Text("${order.ngayTaoDon.toDate()}", style: TextStyle(fontSize: 13.sp)),
                                                  ],
                                                )
                                              ],
                                            );
                                          }).toList(),
                                        ))
                                ],
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
