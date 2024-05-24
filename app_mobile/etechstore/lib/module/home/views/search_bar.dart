import 'package:flutter/material.dart';

Widget searchBar(){
     return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: const TextField(
                decoration: InputDecoration(
                  label: Text("Tìm kiếm sản phẩm",style: TextStyle(
                    color: Colors.white
                  ),),
                  prefixIcon: Icon(Icons.search,color: Colors.white,)
                ),
              ),
    );
  }