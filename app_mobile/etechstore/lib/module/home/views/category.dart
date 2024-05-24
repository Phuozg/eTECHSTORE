 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Widget category(){
    final Stream<QuerySnapshot> cateStream =
      FirebaseFirestore.instance.collection('DanhMucSanPham').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: cateStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
    
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
    
        return ListView(
          scrollDirection: Axis.horizontal,
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: ElevatedButton(
                    onPressed: (){}, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(MdiIcons.fromString(data['HinhAnh']),color: Colors.black,),
                        Text(
                          data['TenDanhMuc'],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    )
                  ),
                );
              })
              .toList()
              .cast(),
        );
      },
    );
  }