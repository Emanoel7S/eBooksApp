import 'package:flutter/material.dart';

class SnackBarHelper {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(String message,Color color) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
