import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/home/controllers/product_controller.dart';
import 'package:etechstore/module/home/models/product_model.dart';
import 'package:etechstore/module/products/views/sortable_products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key,required this.title,this.query,this.futureMethod});
  final String title;
  final Query? query;
  final Future<List<ProductModel>>? futureMethod;

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductControllerr());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: ListView(
        shrinkWrap: true,
        children:[
           Padding(
          padding: const EdgeInsets.all(8),
          child: FutureBuilder( 
            future: futureMethod ?? productController.fetchProductsByQuery(query),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return const CircularProgressIndicator();
              }
              final products = snapshot.data!;
              return SortableProducts(products: products);
            },
          ),
        ),
      ]
      )
    );
  }
}