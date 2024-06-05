import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  bool isConnectedToInternet = false;

  StreamSubscription? _internetConnectionStreamSubcription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _internetConnectionStreamSubcription = InternetConnection().onStatusChange.listen((event) {
      print(event);
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnectedToInternet = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnectedToInternet = false;
          });
          break;
        default:
          setState(() {
            isConnectedToInternet = false;
          });
          break;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _internetConnectionStreamSubcription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connection page"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 250),
            Icon(
              isConnectedToInternet ? Icons.wifi : Icons.wifi_off,
              color: isConnectedToInternet ? Colors.green : Colors.redAccent,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
