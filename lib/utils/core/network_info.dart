import 'dart:developer';
import 'dart:io';

import '../../app.dart';

class NetworkInfo implements Exception {
  final String message;

  NetworkInfo(this.message);

  static Future checkUserConnection() async {
    try {
      final result =
          await InternetAddress.lookup(App().apiBaseURL!.split("/")[2]);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        log("Connected to internet access");
      }
    } on SocketException catch (_) {
      log("Disconnected from internet access");
      return NetworkInfo("Connection Closed");
    }
  }
}
