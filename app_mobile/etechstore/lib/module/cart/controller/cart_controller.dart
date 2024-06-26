import 'dart:math';

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
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final RxBool isSelectAll = RxBool(false);
  var selectedItems = <String, bool>{}.obs;
  var isEditMode = false.obs;
  var productList = <ProductModel>[].obs;
  RxInt quantity = 0.obs;
  var selectedItemCount = 0.obs;
  RxMap priceMap = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
    setTotalPriceAndCheckAll();
  }

  void setSelectedItem({required String id, required bool value}) {
    selectedItems[id] = value;
  }

  void total() {
    double total = 0.0;

    for (var item in cartItems) {
      var productId = item.maSanPham['maSanPham'];
      var color = item.maSanPham['mauSac'] ?? '';
      var storage = item.maSanPham['cauHinh'] ?? '';

      var key = '$color-$storage';

      int price;
      if (selectedItems[item.id] == true) {
        if (priceMap.containsKey(productId) && priceMap[productId]!.containsKey(key)) {
          price = priceMap[productId]![key]!;
        } else if (products.containsKey(productId)) {
          price = products[productId]!.giaTien - (products[productId]!.giaTien * products[productId]!.KhuyenMai) ~/ 100;
        } else {
          price = 0;
        }
        total += price * item.soLuong;
      }
    }

    totalPrice.value = total;
  }

  Future<void> fetchPriceMap(String productId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('MauSanPham').get();
    Map<String, Map<String, int>> prices = {};

    for (var doc in querySnapshot.docs) {
      Map data = doc.data() as Map<String, dynamic>;
      productId = data['MaSanPham'];
      Map<String, int> priceData = Map<String, int>.from(data['GiaTien']);
      prices[productId] = priceData;
    }

    priceMap.value = prices;
  }

  int calculatePrice(CartModel cartItem) {
    String productId = cartItem.maSanPham['maSanPham'];
    String color = cartItem.maSanPham['mauSac'] ?? '';
    String storage = cartItem.maSanPham['cauHinh'] ?? '';
    String key = '$color-$storage';
    String keyColor = '$color-';
    String keyStorage = '$storage-';

    if (priceMap.containsKey(productId)) {
      if (priceMap[productId]!.containsKey(key)) {
        return priceMap[productId]![key]!;
      } else if (priceMap[productId]!.containsKey(keyColor)) {
        return priceMap[productId]![keyColor]!;
      } else if (priceMap[productId]!.containsKey(keyStorage)) {
        return priceMap[productId]![keyStorage]!;
      }
    }

    if (products.containsKey(productId)) {
      return products[productId]!.giaTien - (products[productId]!.giaTien * products[productId]!.KhuyenMai) ~/ 100;
    } else {
      return 0;
    }
  }

  Future<void> setTotalPriceAndCheckAll() async {
    totalPrice.value = 0;
    isSelectAll.value = false;

    final checkitem = _firestore.collection('GioHang').where('maKhachHang', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

    checkitem.then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        for (var cart in cartItems) {
          if (cart.maKhachHang == docSnapshot.data()['maKhachHang'] &&
              cart.maSanPham['cauHinh'] == docSnapshot.data()['mauSanPham']['cauHinh'] &&
              cart.maSanPham['mauSac'] == docSnapshot.data()['mauSanPham']['mauSac']) {
            _firestore.collection('GioHang').doc(docSnapshot.id).update({'trangThai': isSelectAll.value ? 1 : 0 ?? 1}).then((value) {
              setSelectedItem(id: cart.id, value: false);
            });
          }
        }
      }
    });
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
      _firestore.collection('GioHang').where('maKhachHang', isEqualTo: userId).snapshots().listen((snapshot) async {
        var items = snapshot.docs.map((doc) => CartModel.fromMap(doc.data())).toList();
        cartItems.value = items;

        for (var item in items) {
          var productDoc = await _firestore.collection('SanPham').doc(item.maSanPham['maSanPham']).get();
          if (productDoc.exists) {
            products[item.maSanPham['maSanPham']] = ProductModel.fromFirestore(productDoc.data() as Map<String, dynamic>);
            // total();
            updateSelectedItemCount();
            fetchPriceMap(item.maSanPham['maSanPham']);
          }
        }
        localStorageService.saveCartItems(cartItems);
        localStorageService.saveProducts(productList);
      });
    }
  }

  void fetchCartItemsLocally() async {
    List<CartModel> localCartItems = await localStorageService.getCartItems();
    List<ProductModel> localProducts = await localStorageService.getProducts();

    cartItems.assignAll(localCartItems);
    productList.assignAll(localProducts);
  }

  void fetchCartsLocally() async {
    List<CartModel> localCarts = await localStorageService.getCartItems();
    cartItems.assignAll(localCarts);
  }

  Future<void> toggleSelectedItem(String itemId, bool value) async {
    final checkitem = _firestore.collection('GioHang').where('maKhachHang', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

    checkitem.then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        for (var cart in cartItems) {
          if (cart.id == itemId) {
            if (cart.maKhachHang == docSnapshot.data()['maKhachHang'] &&
                cart.maSanPham['cauHinh'] == docSnapshot.data()['mauSanPham']['cauHinh'] &&
                cart.maSanPham['mauSac'] == docSnapshot.data()['mauSanPham']['mauSac']) {
              _firestore.collection('GioHang').doc(docSnapshot.id).update({'trangThai': value == false ? 0 : 1 ?? 0}).then((snapShot) {
                setSelectedItem(id: itemId, value: value);

                total();
                updateSelectedItemCount();
              });
            }
          }
        }
      }
    });
  }

  Future<void> toggleSelectAll() async {
    isSelectAll.value = !isSelectAll.value;

    final checkitem = _firestore.collection('GioHang').where('maKhachHang', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

    checkitem.then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        for (var cart in cartItems) {
          if (cart.maKhachHang == docSnapshot.data()['maKhachHang'] &&
              cart.maSanPham['cauHinh'] == docSnapshot.data()['mauSanPham']['cauHinh'] &&
              cart.maSanPham['mauSac'] == docSnapshot.data()['mauSanPham']['mauSac']) {
            _firestore.collection('GioHang').doc(docSnapshot.id).update({'trangThai': isSelectAll.value ? 1 : 0 ?? 1}).then((value) {
              setSelectedItem(id: cart.id, value: isSelectAll.value);
            });
          }
        }
      }
    });

    updateSelectedItemCount();
  }

  void updateSelectedItemCount() {
    total();
    selectedItemCount.value = selectedItems.values.where((value) => value).length;
  }

  String generateRandomString(int length) {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }

  void addItemToCart(CartModel newItem) async {
    final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
      return;
    } else {
      int index = cartItems
          .indexWhere((item) => item.maSanPham['cauHinh'] == newItem.maSanPham['cauHinh'] && item.maSanPham['mauSac'] == newItem.maSanPham['mauSac']);

      if (index != -1) {
        CartModel existingItem = cartItems[index];

        if (existingItem.maSanPham['cauHinh'] != newItem.maSanPham['cauHinh'] ||
            existingItem.maSanPham['mauSac'] != newItem.maSanPham['mauSac'] ||
            existingItem.maSanPham['maSanPham'] != newItem.maSanPham['maSanPham']) {
          cartItems.add(newItem);
          TLoaders.successSnackBar(title: "Thông báo", message: "Thêm thành công!");
          await saveCartItemToFirestore(newItem);
        } else if (existingItem.id != newItem.id) {
          existingItem.soLuong = newItem.soLuong;
          updateCartItem(existingItem);
          TLoaders.successSnackBar(title: "Thông báo", message: "Thêm thành công!");
        }
      } else {
        cartItems.add(newItem);
        await saveCartItemToFirestore(newItem);
        TLoaders.successSnackBar(title: "Thông báo", message: "Thêm thành công!");
      }
    }
  }

  Future<void> removeItemsWithSameMauSacButDifferentCauHinh(String mauSac) async {
    cartItems.removeWhere((item) => item.maSanPham['mauSac'] == mauSac);
  }

  Future<void> removeItemsWithSameCauHinhButDifferentMauSac(String mauSac) async {
    cartItems.removeWhere((item) => item.maSanPham['mauSac'] == mauSac);
  }

  void removeItemFromCart(CartModel item) async {
    final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
      return;
    } else {
      cartItems.removeWhere((cartItem) => cartItem.id == item.id && cartItem.maSanPham['maSanPham'] == item.maSanPham['maSanPham']);
      selectedItems.remove(item.id);
      removeItemsWithSameMauSacButDifferentCauHinh(item.maSanPham['mauSac']);
      removeItemsWithSameCauHinhButDifferentMauSac(item.maSanPham['cauHinh']);
      await removeCartItemFromFirestore(item.id, item.maKhachHang);

      setTotalPriceAndCheckAll();
    }
  }

  Future<void> removeCartItemFromFirestore(String itemId, String uid) async {
    FullScreenLoader.openWaitforchange('', ImageKey.waitforchangeAnimation);

    var doc = await _firestore.collection('GioHang').where('id', isEqualTo: itemId).where('maKhachHang', isEqualTo: uid).get();
    if (doc.docs.isNotEmpty) {
      await _firestore.collection('GioHang').doc(doc.docs.first.id).delete();
    }
  }

  Future<void> updateCartItem(CartModel item) async {
    final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
      return;
    } else {
      int index = cartItems.indexWhere((element) => element.id == item.id && element.maKhachHang == item.maKhachHang);
      if (index != -1) {
        cartItems[index] = item;
        await updateCartItemInFirestore(item);
        fetchCartItems();
      }
    }
  }

  Future<void> updateCartItemInFirestore(CartModel item) async {
    var doc = await _firestore.collection('GioHang').where('id', isEqualTo: item.id).where('maKhachHang', isEqualTo: item.maKhachHang).get();
    if (doc.docs.isNotEmpty) {
      await _firestore.collection('GioHang').doc(doc.docs.first.id).update(item.toMap());
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
      setTotalPriceAndCheckAll();
    }
  }

  Future<void> saveCartItemToFirestore(CartModel item) async {
    await _firestore.collection('GioHang').add(item.toMap());
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
