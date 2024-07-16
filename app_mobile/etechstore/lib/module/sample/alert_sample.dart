import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

showPopupAlert({required BuildContext context, required String title, required String content, VoidCallback? action, IconData? icon}) {
  showDialog(
    context: context,
    builder: (context) => alert(context: context, title: title, content: content, action: action, icon: icon),
  );
}

alert({required BuildContext context, required String title, required String content, VoidCallback? action, IconData? icon}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Material(
                      child: Text(
                    title,
                    style: const TextStyle(fontSize: 20),
                  )),
                  icon != null ? Icon(icon) : const Icon(Icons.warning_amber)
                ],
              ),
              Material(
                  child: Text(
                content,
                textAlign: TextAlign.center,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (action != null) {
                          action();
                        }
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(horizontal: action != null ? MediaQuery.of(context).size.width / 10 : 0)),
                      child: const Text(
                        'Xác nhận',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent, padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 9)),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    ],
  );
}
