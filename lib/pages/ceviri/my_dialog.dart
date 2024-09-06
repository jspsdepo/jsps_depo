import 'package:flutter/material.dart';

class MyDialog {
  // info
  static void info(BuildContext context, String msg) {
    if (msg.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.blue.withOpacity(.7),
        ),
      );
    }
  }

  // success
  static void success(BuildContext context, String msg) {
    if (msg.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.green.withOpacity(.7),
        ),
      );
    }
  }

  // error
  static void error(BuildContext context, String msg) {
    if (msg.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.redAccent.withOpacity(.7),
        ),
      );
    }
  }
}
