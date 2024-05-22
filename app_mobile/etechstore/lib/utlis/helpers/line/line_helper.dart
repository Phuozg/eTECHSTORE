import 'package:flutter/cupertino.dart';

class Linehelper extends StatelessWidget {
    Linehelper({super.key, required this.color, required this.height});
  double height;
  Color color;
  @override
  Widget build(BuildContext context) {
    return Container(color: color, width: double.infinity, height: height);
  }
}
