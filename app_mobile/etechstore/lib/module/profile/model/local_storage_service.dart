import 'package:etechstore/module/cart/model/cart_model.dart';
import 'package:etechstore/module/product_detail/model/product_model.dart';
import 'package:etechstore/module/product_detail/model/product_sample_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'profile_model.dart';

class LocalStorageService {
  //Profile
  Future<void> saveProfiles(List<ProfileModel> profiles) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> profilesJson = profiles.map((profile) => jsonEncode(profile.toJson())).toList();
    await prefs.setStringList('profiles', profilesJson);
  }

  Future<List<ProfileModel>> getProfiles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? profilesJson = prefs.getStringList('profiles');
    if (profilesJson != null) {
      return profilesJson.map((json) => ProfileModel.fromJson(jsonDecode(json))).toList();
    }
    return [];
  }

  Future<void> clearProfiles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('profiles');
  }

  //Cart
  Future<void> saveCartItems(List<CartModel> cartItems) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItemsJson = cartItems.map((item) => jsonEncode(item.toMap())).toList();
    await prefs.setStringList('cartItems', cartItemsJson);
  }

  Future<List<CartModel>> getCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList('cartItems');
    if (cartItemsJson != null) {
      return cartItemsJson.map((json) => CartModel.fromMap(jsonDecode(json))).toList();
    }
    return [];
  }

  //product
  Future<void> saveProducts(List<ProductModel> products) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productsJson = products.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('products', (productsJson));
  }

  Future<List<ProductModel>> getProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? productsJson = prefs.getStringList('products');
    if (productsJson != null) {
      return productsJson.map((json) => ProductModel.fromJson(jsonDecode(json))).toList();
    }
    return [];
  }

  Future<void> saveProductSamples(List<ProductSampleModel> productSamples) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> samplesJson = productSamples.map((sample) => jsonEncode(sample.toMap())).toList();
    await prefs.setStringList('productSamples', samplesJson);
  }

  Future<List<ProductSampleModel>> getProductSamples() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? samplesJson = prefs.getStringList('productSamples');
    if (samplesJson != null) {
      return samplesJson.map((json) => ProductSampleModel.fromFirestore(jsonDecode(json))).toList();
    }
    return [];
  }

  Future<void> clearCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
    await prefs.remove('products');
     await prefs.remove('productSamples'); await prefs.remove('profiles');
  }
}
