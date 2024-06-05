/* import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/fake/views/auth_controller.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../fake/views/cart_view_fake.dart';
import '../../product_detail/controller/product_controller.dart';
import '../../product_detail/model/product_sample_model.dart';

class ProductView extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());
  final AuthController authController = Get.put(AuthController());
  ProductView({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Samples'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Get.to(CartView());
            },
          )
        ],
      ),/*  */
      body: Obx(() {
        if (controller.productSamples.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: controller.productSamples.length,
            itemBuilder: (context, index) {
              ProductSampleModel sample = controller.productSamples[index];
              String selectedColor = sample.mauSac.first;
              String selectedConfig = sample.cauHinh.first;
              int quantity = 1;

              return Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(sample.MaSanPham),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Số lượng: ${sample.soLuong}'),
                          DropdownButton<String>(
                            value: selectedColor,
                            onChanged: (String? newValue) {
                              selectedColor = newValue!;
                            },
                            items: sample.mauSac.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          DropdownButton<String>(
                            value: selectedConfig,
                            onChanged: (String? newValue) {
                              selectedConfig = newValue!;
                            },
                            items: sample.cauHinh.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          Row(
                            children: [
                              const Text('Quantity:'),
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (quantity > 1) {
                                    quantity--;
                                  }
                                },
                              ),
                              Text('$quantity'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  quantity++;
                                  final FirebaseAuth auth = FirebaseAuth.instance;

                                  User? user = auth.currentUser;
                                  print(user!.uid);
                                },
                              ),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
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
                                                  cartController.addItemToCart(cartItem);
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
                              child: const Text("Đăng xuất")),
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
                              cartController.addItemToCart(cartItem);
                            },
                            child: const Text('Add to Cart'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }
}
 */