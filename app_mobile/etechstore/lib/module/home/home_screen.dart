import 'package:etechstore/services/auth/auth_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthServices authServices = AuthServices();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: IconButton(
          onPressed: () {
            authServices.signOut();
          },
          icon: const Icon(Icons.logout)),
    );
  }
}
