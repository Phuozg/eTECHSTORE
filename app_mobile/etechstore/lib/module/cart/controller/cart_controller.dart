import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/product_detail/controller/product_sample_controller.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:etechstore/module/profile/model/local_storage_service.dart';
import 'package:etechstore/utlis/connection/network_manager.dart';
import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:etechstore/utlis/constants/text_strings.dart';
import 'package:etechstore/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final NetworkManager network = Get.put(NetworkManager());

  CartController get instance => Get.find();
  GlobalKey<FormState> DetailProductFormKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalStorageService localStorageService = LocalStorageService();
  ProductSampleController productSample = Get.put(ProductSampleController());

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
  var itemPrices = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
    setTotalPriceAndCheckAll();
    fetchCartItemsLocally();
    fetchCartsLocally();
    total();
    productSample.getSampleProduct();
    productSample.fetchProducts();
  }

  void setSelectedItem({required String id, required bool value}) {
    selectedItems[id] = value;
  }

  void addItemSampleToCart(CartModel item) {
    cartItems.add(item);
  }

  int calculatePrice(ProductSampleModel productSample, ProductModel product,
      String selectedColor, String selectedConfig) {
    var colorIndex = productSample.mauSac.indexOf(selectedColor);
    var configIndex = productSample.cauHinh.indexOf(selectedConfig);

    if (colorIndex == -1 && configIndex == -1) {
      return (product.giaTien - product.giaTien * product.KhuyenMai ~/ 100);
    } else {
      if (colorIndex == -1) colorIndex = 0;
      if (configIndex == -1) configIndex = 0;
    }
    final priceIndex = colorIndex * productSample.cauHinh.length + configIndex;

    if (priceIndex >= productSample.giaTien.length) {
      return (product.giaTien - product.giaTien * product.KhuyenMai ~/ 100);
    }
    return int.parse(productSample.giaTien[priceIndex].toString());
  }

  void total() {
    double total = 0.0;

    for (var item in cartItems) {
      if (selectedItems[item.id] == true) {
        final productSampl = productSample.productSamples.firstWhere(
          (p) => p.MaSanPham == item.maSanPham['maSanPham'],
          orElse: () => ProductSampleModel(
              id: '',
              MaSanPham: '',
              soLuong: 0,
              mauSac: [],
              cauHinh: [],
              giaTien: []),
        );
        final product = products[item.maSanPham['maSanPham']]!;

        int price = calculatePrice(productSampl, product,
            item.maSanPham['mauSac'], item.maSanPham['cauHinh']);
        total += price * item.soLuong;
      }
    }
    totalPrice.value = total;
  }

  Future<void> setTotalPriceAndCheckAll() async {
    totalPrice.value = 0;
    isSelectAll.value = false;

    final checkitem = await _firestore
        .collection('GioHang')
        .where('maKhachHang', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var docSnapshot in checkitem.docs) {
      for (var cart in cartItems) {
        if (cart.maKhachHang == docSnapshot.data()['maKhachHang'] &&
            cart.id == docSnapshot.data()['id'] && docSnapshot.data().isNotEmpty) {
          await _firestore.collection('GioHang').doc(docSnapshot.id).update({
            'trangThai': isSelectAll.value ? 1 : 0,
          });
          setSelectedItem(id: cart.id, value: false);
        }
      }
    }
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
      _firestore
          .collection('GioHang')
          .where('maKhachHang', isEqualTo: userId)
          .snapshots()
          .listen((snapshot) async {
        var items =
            snapshot.docs.map((doc) => CartModel.fromMap(doc.data())).toList();
        cartItems.value = items;

        for (var item in items) {
          var productDoc = await _firestore
              .collection('SanPham')
              .doc(item.maSanPham['maSanPham'])
              .get();
          if (productDoc.exists) {
            products[item.maSanPham['maSanPham']] = ProductModel.fromFirestore(
                productDoc.data() as Map<String, dynamic>);
            updateSelectedItemCount();
          }
        }
        localStorageService.saveCartItems(cartItems);
        localStorageService.saveProducts(productList);
        await localStorageService.saveItemPrices(itemPrices);
      });
    }
  }

  void fetchCartItemsLocally() async {
    List<CartModel> localCartItems = await localStorageService.getCartItems();
    List<ProductModel> localProducts = await localStorageService.getProducts();
    Map<String, String> itemPricesLocal =
        await localStorageService.getItemPrices();

    cartItems.assignAll(localCartItems);
    itemPrices.assignAll(itemPricesLocal);
    productList.assignAll(localProducts);
  }

  void fetchCartsLocally() async {
    List<CartModel> localCarts = await localStorageService.getCartItems();
    Map<String, String> itemPricesLocal =
        await localStorageService.getItemPrices();
    itemPrices.assignAll(itemPricesLocal);
    cartItems.assignAll(localCarts);
  }

  Future<void> toggleSelectedItem(String itemId, bool value) async {
    final checkitem = await _firestore
        .collection('GioHang')
        .where('maKhachHang', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var docSnapshot in checkitem.docs) {
      for (var cart in cartItems) {
        if (cart.id == itemId) {
          if (cart.maKhachHang == docSnapshot.data()['maKhachHang'] &&
              cart.id == docSnapshot.data()['id']) {
            await _firestore.collection('GioHang').doc(docSnapshot.id).update({
              'trangThai': value ? 1 : 0,
            });
            setSelectedItem(id: itemId, value: value);
            total();
            updateSelectedItemCount();
          }
        }
      }
    }
  }

  Future<void> toggleSelectAll() async {
    isSelectAll.value = !isSelectAll.value;

    final checkitem = await _firestore
        .collection('GioHang')
        .where('maKhachHang', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var docSnapshot in checkitem.docs) {
      for (var cart in cartItems) {
        if (cart.maKhachHang == docSnapshot.data()['maKhachHang'] &&
            cart.maSanPham['cauHinh'] ==
                docSnapshot.data()['mauSanPham']['cauHinh'] &&
            cart.maSanPham['mauSac'] ==
                docSnapshot.data()['mauSanPham']['mauSac']) {
          await _firestore.collection('GioHang').doc(docSnapshot.id).update({
            'trangThai': isSelectAll.value ? 1 : 0,
          });
          setSelectedItem(id: cart.id, value: isSelectAll.value);
        }
      }
    }

    updateSelectedItemCount();
  }

  void updateSelectedItemCount() {
    total();
    selectedItemCount.value =
        selectedItems.values.where((value) => value).length;
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
      TLoaders.errorSnackBar(
          title: TTexts.thongBao, message: "Không có kết nối internet");
      return;
    } else {
      int index = cartItems.indexWhere((item) =>
          item.maSanPham['cauHinh'] == newItem.maSanPham['cauHinh'] &&
          item.maSanPham['mauSac'] == newItem.maSanPham['mauSac']);

      if (index != -1) {
        CartModel existingItem = cartItems[index];

        if (existingItem.maSanPham['cauHinh'] != newItem.maSanPham['cauHinh'] ||
            existingItem.maSanPham['mauSac'] != newItem.maSanPham['mauSac'] ||
            existingItem.maSanPham['maSanPham'] !=
                newItem.maSanPham['maSanPham']) {
          addItemSampleToCart(newItem);
          cartItems.add(newItem);
          TLoaders.successSnackBar(
              title: "Thông báo", message: "Thêm thành công!");
          await saveCartItemToFirestore(newItem);
        } else if (existingItem.id != newItem.id) {
          existingItem.soLuong = newItem.soLuong;
          updateCartItem(existingItem);
          TLoaders.successSnackBar(
              title: "Thông báo", message: "Thêm thành công!");
        }
      } else {
        cartItems.add(newItem);
        await saveCartItemToFirestore(newItem);
        TLoaders.successSnackBar(
            title: "Thông báo", message: "Thêm thành công!");
      }
    }
  }

  void removeItemFromCart(CartModel item) async {
    final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      TLoaders.errorSnackBar(
          title: TTexts.thongBao, message: "Không có kết nối internet");
      return;
    } else {
      cartItems.removeWhere((cartItem) =>
          cartItem.id == item.id &&
          cartItem.maSanPham['maSanPham'] == item.maSanPham['maSanPham']);
      selectedItems.remove(item.id);

      await removeCartItemFromFirestore(item.id, item.maKhachHang);

      setTotalPriceAndCheckAll();
    }
  }

  Future<void> removeCartItemFromFirestore(String itemId, String uid) async {
    Future.delayed(
        const Duration(seconds: 1),
        () => FullScreenLoader.openWaitforchange(
            '', ImageKey.waitforchangeAnimation));

    var doc = await _firestore
        .collection('GioHang')
        .where('id', isEqualTo: itemId)
        .where('maKhachHang', isEqualTo: uid)
        .get();
    if (doc.docs.isNotEmpty) {
      await _firestore.collection('GioHang').doc(doc.docs.first.id).delete();
    }
  }

  Timer? _debounce;

  Future<void> updateCartItem(CartModel item) async {
    final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      TLoaders.errorSnackBar(
          title: TTexts.thongBao, message: "Không có kết nối internet");
      return;
    } else {
      int index = cartItems.indexWhere((element) =>
          element.id == item.id && element.maKhachHang == item.maKhachHang);
      if (index != -1) {
        cartItems[index] = item;

        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () async {
          await updateCartItemInFirestore(item);
          fetchCartItems();
        });
      }
    }
  }

  Future<void> updateCartItemInFirestore(CartModel item) async {
    var doc = await _firestore
        .collection('GioHang')
        .where('id', isEqualTo: item.id)
        .where('maKhachHang', isEqualTo: item.maKhachHang)
        .get();
    if (doc.docs.isNotEmpty) {
      await _firestore
          .collection('GioHang')
          .doc(doc.docs.first.id)
          .update(item.toMap());
    }
  }

  void clearCart() async {
    final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      TLoaders.errorSnackBar(
          title: TTexts.thongBao, message: "Không có kết nối internet");
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
}
