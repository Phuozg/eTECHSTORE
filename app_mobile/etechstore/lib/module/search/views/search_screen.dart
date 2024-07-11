import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etechstore/module/home/models/product_model_home.dart';
import 'package:etechstore/module/sample/product_horizontal_listtile.dart';
import 'package:flutter/material.dart';
import "package:unorm_dart/unorm_dart.dart" as unorm;

class SearchSreen extends StatefulWidget {
  const SearchSreen({super.key});

  @override
  State<SearchSreen> createState() => _SearchSreenState();
}

class _SearchSreenState extends State<SearchSreen> {
  FocusNode myFocusNode = FocusNode();
  String name = "";
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => myFocusNode.requestFocus());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Color(0xFF383CA0)),
        ),
        title: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
          child: TextField(
            focusNode: myFocusNode,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                hintText: 'Tên sản phẩm',
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                )),
            onChanged: (value) {
              setState(() {
                name = removeDiacritics(value);
              });
            },
          ),
        ),
      ),
      body: Container(
        color: Colors.grey.shade300,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('SanPham').snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      ProductModel product = ProductModel.fromQuerySnapshot(
                          snapshot.data!.docs[index]);

                      if (name.isEmpty) {
                        return productHorizontalListTile(context, product);
                      }
                      if (removeDiacritics(product.Ten.toString())
                          .toLowerCase()
                          .contains(name.toLowerCase())) {
                        return productHorizontalListTile(context, product);
                      }
                      return Container();
                    });
          },
        ),
      ),
    );
  }
}

String removeDiacritics(String input) {
  return unorm.nfd(input).replaceAll(RegExp(r'[\u0300-\u036f]'), '');
}
