/* import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartView extends StatelessWidget {
  final CartController controller = Get.put(CartController());

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
      ),
      body: Obx(() {
          if (controller.cartItems.isEmpty) {
            return const Center(child: Text('Không có sản phẩm nào trong giỏ hàng'));
          } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    CartModel item = controller.cartItems[index];
                    String selectedColor = item.maSanPham['mauSac'];
                    String selectedConfig = item.maSanPham['cauHinh'];
                    int quantity = item.soLuong;

                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Obx(() => Checkbox(
                                  value: controller.selectedItems[item.id],
                                  onChanged: (bool? value) {
                                    controller.toggleItemSelection(item.id);
                                  },
                                )),
                            title: Text('Sản phẩm: ${item.maSanPham['maSanPham']}'),
                            subtitle: StreamBuilder(
                              stream: controller.calculateProductPrice(item),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Text('Đang tính toán giá...');
                                }
                                if (snapshot.hasError) {
                                  return const Text('Lỗi khi tính toán giá');
                                }
                                int productPrice = snapshot.data ?? 0;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Giá tiền: ${productPrice.toStringAsFixed(2)} VND'),
                                    Row(
                                      children: [
                                        const Text('Quantity:'),
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            if (quantity > 1) {
                                              quantity--;
                                              item.soLuong = quantity;
                                              controller.updateCartItem(item);
                                            }
                                          },
                                        ),
                                        Text('$quantity'),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            quantity++;
                                            item.soLuong = quantity;
                                            controller.updateCartItem(item);
                                          },
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        List<String> availableColors = await controller.getAvailableColors(item.id);
                                        List<String> availableConfigs = await controller.getAvailableConfigs(item.id);

                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            String tempSelectedColor = selectedColor;
                                            String tempSelectedConfig = selectedConfig;

                                            return StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                                return Container(
                                                  
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Text('Chọn màu sắc'),
                                                      DropdownButton<String>(
                                                        value: tempSelectedColor,
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            tempSelectedColor = newValue!;
                                                          });
                                                        },
                                                        items: availableColors.map<DropdownMenuItem<String>>((String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        }).toList(),
                                                      ),
                                                      const SizedBox(height: 16.0),
                                                      const Text('Chọn cấu hình'),
                                                      DropdownButton<String>(
                                                        value: tempSelectedConfig,
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            tempSelectedConfig = newValue!;
                                                          });
                                                        },
                                                        items: availableConfigs.map<DropdownMenuItem<String>>((String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        }).toList(),
                                                      ),
                                                      const SizedBox(height: 16.0),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          selectedColor = tempSelectedColor;
                                                          selectedConfig = tempSelectedConfig;
                                                          item.maSanPham['mauSac'] = selectedColor;
                                                          item.maSanPham['cauHinh'] = selectedConfig;
                                                          controller.updateCartItem(item);
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text('Xác nhận'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        
                                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blue),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text('Màu sắc: $selectedColor, Cấu hình: $selectedConfig'),
                                            const Icon(Icons.edit, color: Colors.blue),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                controller.removeItemFromCart(item);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: controller.isSelectAll.value,
                          onChanged: (bool? value) {
                            controller.toggleSelectAll();
                          },
                        ),
                        const Text('Chọn tất cả'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Tổng tiền: ${controller.totalPrice.value.toStringAsFixed(2)} VND',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              }),
            ],
          );
        }
      }),
    );
  }
}
 */