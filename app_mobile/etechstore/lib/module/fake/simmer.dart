import 'package:etechstore/module/cart/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class LoadingListPage extends StatelessWidget {
  LoadingListPage({super.key});

  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 2),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: ListView(
        children: const [
          SizedBox(height: 16.0),
          ContentPlaceholder(
            lineType: ContentLineType.threeLines,
          ),
          SizedBox(height: 16.0),
          ContentPlaceholder(
            lineType: ContentLineType.twoLines,
          ),
          SizedBox(height: 16.0),
          ContentPlaceholder(
            lineType: ContentLineType.twoLines,
          ),
          SizedBox(height: 16.0),
          ContentPlaceholder(
            lineType: ContentLineType.threeLines,
          ),
          SizedBox(height: 16.0),
          ContentPlaceholder(
            lineType: ContentLineType.twoLines,
          ),
          SizedBox(height: 16.0),
          ContentPlaceholder(
            lineType: ContentLineType.twoLines,
          ),
        ],
      ),
    );
  }
}

enum ContentLineType {
  twoLines,
  threeLines,
}

class ContentPlaceholder extends StatelessWidget {
  final ContentLineType lineType;

  const ContentPlaceholder({
    super.key,
    required this.lineType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 96.0,
            height: 72.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8.0),
                ),
                if (lineType == ContentLineType.threeLines)
                  Container(
                    width: double.infinity,
                    height: 10.0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8.0),
                  ),
                Container(
                  width: 100.0,
                  height: 10.0,
                  color: Colors.white,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
