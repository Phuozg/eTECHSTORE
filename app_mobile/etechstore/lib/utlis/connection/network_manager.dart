import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:etechstore/utlis/helpers/popups/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkManager extends GetxController {
  NetworkManager get instance => Get.find();

  RxBool isConnectedToInternet = false.obs;
  StreamSubscription<InternetStatus>? _internetConnectionStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    _internetConnectionStreamSubscription = InternetConnection().onStatusChange.listen((status) {
      switch (status) {
        case InternetStatus.connected:
          isConnectedToInternet.value = true;
          break;
        case InternetStatus.disconnected:
          isConnectedToInternet.value = false;
          break;
      }
    });
  }

  @override
  void onClose() {
    _internetConnectionStreamSubscription?.cancel();
    super.onClose();
  }
}
