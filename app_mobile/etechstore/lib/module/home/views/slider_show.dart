
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget sliderShow(){
    final Stream<QuerySnapshot> discounts =
      FirebaseFirestore.instance.collection('KhuyenMaiBanner').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: discounts,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
    
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
    
        return CarouselSlider(
          items: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Image.network(data['HinhAnh'],fit: BoxFit.fitHeight,);
              })
              .toList()
              .cast(), 
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            aspectRatio: 2.0,
            initialPage: 2,
          ),);
      },
    );
  }