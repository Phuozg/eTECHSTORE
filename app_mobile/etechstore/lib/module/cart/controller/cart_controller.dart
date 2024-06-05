import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/profile/model/local_storage_service.dart';
import 'package:etechstore/utlis/connection/network_manager.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../../product_detail/controller/product_controller.dart';

class CartController extends GetxController {
  final NetworkManager network = Get.put(NetworkManager());

  CartController get instance => Get.find();
  GlobalKey<FormState> DetailProductFormKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalStorageService localStorageService = LocalStorageService();

  var cartItems = <CartModel>[].obs;
  var products = <String, ProductModel>{}.obs;
  var totalPrice = 0.0.obs;
  var isSelectAll = false.obs;
  var selectedItems = <String, bool>{}.obs;
  var isEditMode = false.obs;
  var productList = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
    getCartData();
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  void changeIsconnected() {
    network.isConnectedToInternet.value;
    !network.isConnectedToInternet.value;
  }

  Future<void> fetchCartItems() async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      fetchCartItemsLocally();
      _firestore.collection('GioHang').where('maKhachHang', isEqualTo: userId).where('trangThai', isEqualTo: 1).snapshots().listen((snapshot) async {
        var items = snapshot.docs.map((doc) => CartModel.fromMap(doc.data())).toList();
        cartItems.value = items;

        for (var item in cartItems) {
          selectedItems[item.id] = false;
        }

        for (var item in items) {
          var productDoc = await _firestore.collection('SanPham').doc(item.maSanPham['maSanPham']).get();
          if (productDoc.exists) {
            products[item.maSanPham['maSanPham']] = ProductModel.fromFirestore(productDoc.data() as Map<String, dynamic>);
          }
        }

        localStorageService.saveCartItems(cartItems);
        localStorageService.saveProducts(productList);

        calculateTotalPrice();
      });
    }
  }

  void fetchCartItemsLocally() async {
    List<CartModel> localCartItems = await localStorageService.getCartItems();
    List<ProductModel> localProducts = await localStorageService.getProducts();

    cartItems.assignAll(localCartItems);
    productList.assignAll(localProducts);

    for (var item in cartItems) {
      selectedItems[item.id] = false;
    }

    calculateTotalPrice();
  }

  void fetchCartsLocally() async {
    List<CartModel> localCarts = await localStorageService.getCartItems();
    cartItems.assignAll(localCarts);
  }

  Stream<List<CartModel>> getCartData() {
    return _firestore.collection("GioHang").snapshots().map((snapshot) => snapshot.docs.map((doc) => CartModel.fromMap(doc.data())).toList());
  }

  Stream<int> calculateProductPrice(CartModel item) {
    return _firestore.collection('SanPham').doc(item.maSanPham['maSanPham']).snapshots().asyncMap((productDoc) {
      if (productDoc.exists) {
        int giaTien = productDoc.get('GiaTien');
        int khuyenMai = productDoc.get('KhuyenMai');
        return ((giaTien * (1 - khuyenMai / 100)) * item.soLuong).toInt();
      } else {
        return 0;
      }
    });
  }

  Future<void> calculateTotalPrice() async {
    double total = 0.0;
    for (var item in cartItems) {
      getProductPriceStream(item).listen((itemPrice) {
        total += itemPrice;
        totalPrice.value = total;
      });
    }
  }

  Stream<int> getProductPriceStream(CartModel item) async* {
    await for (int price in calculateProductPrice(item)) {
      if (selectedItems[item.id] == true) {
        yield price;
      } else {
        yield 0;
      }
    }
  }

  void toggleItemSelection(String itemId) {
    selectedItems[itemId] = !selectedItems[itemId]!;
    calculateTotalPrice();
  }

  void toggleSelectAll() {
    isSelectAll.value = !isSelectAll.value;
    for (var key in selectedItems.keys) {
      selectedItems[key] = isSelectAll.value;
    }
    calculateTotalPrice();
  }

  void addItemToCart(CartModel newItem) async {
    final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
      return;
    } else {
      int index = cartItems.indexWhere((item) => item.maSanPham['maSanPham'] == newItem.maSanPham['maSanPham']);

      if (index != -1) {
        CartModel existingItem = cartItems[index];

        if (existingItem.maSanPham['cauHinh'] != newItem.maSanPham['cauHinh'] || existingItem.maSanPham['mauSac'] != newItem.maSanPham['mauSac']) {
          cartItems.add(newItem);
          selectedItems[newItem.id] = false;
          await saveCartItemToFirestore(newItem);
        } else {
          existingItem.soLuong = newItem.soLuong;
          updateCartItem(existingItem);
        }
      } else {
        cartItems.add(newItem);
        selectedItems[newItem.id] = false;
        await saveCartItemToFirestore(newItem);
        TLoaders.successSnackBar(title: "Thông báo", message: "Thêm thành công!");
      }

      calculateTotalPrice();
    }
  }

  void removeItemFromCart(CartModel item) async {
    final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
      return;
    } else {
      cartItems.remove(item);
      selectedItems.remove(item.id);
      await removeCartItemFromFirestore(item.id, item.maKhachHang);
      calculateTotalPrice();
    }
  }

  void updateCartItem(CartModel item) async {
    final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
      return;
    } else {
      int index = cartItems.indexWhere((element) => element.id == item.id && element.maKhachHang == item.maKhachHang);
      if (index != -1) {
        cartItems[index] = item;
        await updateCartItemInFirestore(item);
        calculateTotalPrice();
      }
    }
  }

  void clearCart() async {
    final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
      return;
    } else {
      cartItems.clear();
      selectedItems.clear();
      totalPrice.value = 0.0;
    }
  }

  Future<void> saveCartItemToFirestore(CartModel item) async {
    await _firestore.collection('GioHang').add(item.toMap());
  }

  Future<void> removeCartItemFromFirestore(String itemId, String uid) async {
    FullScreenLoader.openWaitforchange('', ImageKey.waitforchangeAnimation);

    var doc = await _firestore.collection('GioHang').where('id', isEqualTo: itemId).where('maKhachHang', isEqualTo: uid).get();
    if (doc.docs.isNotEmpty) {
      await _firestore.collection('GioHang').doc(doc.docs.first.id).delete();
    }
  }

  Future<void> updateCartItemInFirestore(CartModel item) async {
    var doc = await _firestore.collection('GioHang').where('id', isEqualTo: item.id).where('maKhachHang', isEqualTo: item.maKhachHang).get();
    if (doc.docs.isNotEmpty) {
      await _firestore.collection('GioHang').doc(doc.docs.first.id).update(item.toMap());
    }
  }

  Future<List<String>> getAvailableColors(String maSanPham) async {
    DocumentSnapshot productDoc = await _firestore.collection('MauSanPham').doc(maSanPham).get();
    return List<String>.from(productDoc.get('MauSac'));
  }

  Future<List<String>> getAvailableConfigs(String maSanPham) async {
    DocumentSnapshot productDoc = await _firestore.collection('MauSanPham').doc(maSanPham).get();
    return List<String>.from(productDoc.get('CauHinh'));
  }
}
