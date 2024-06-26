import 'package:etechstore/utlis/constants/image_key.dart';
import 'package:flutter/material.dart';

class CartIconWithBadge extends StatelessWidget {
  final int itemCount;

  const CartIconWithBadge({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          const Image(image: AssetImage(ImageKey.iconCart), color: Colors.white, height: 40, width: 40),
          if (itemCount > 0)
            Positioned(
              right: 2,
              top: 3,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 17,
                ),
                child: Text(
                  '$itemCount',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
