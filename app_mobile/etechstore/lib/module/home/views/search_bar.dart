import 'package:etechstore/module/search/views/search_screen.dart';
import 'package:flutter/material.dart';

Widget searchBar(BuildContext context){
     return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: ElevatedButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (builder)=>const SearchSreen()));
        }, 
        child: const Row(
          children: [
            Icon(Icons.search),
            Text("Tìm kiếm"),
          ],
        )
      )
    );
  }