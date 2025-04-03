import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MySnackbar extends GetSnackBar {
  MySnackbar({
    super.key,
    required bool success,
    required String title,
    required String message,
  }) : super(
          backgroundColor: success ? Colors.green : Colors.red,
          title: title,
          message: message,
          duration: const Duration(seconds: 5),
          icon: Icon(success ? Icons.check : Icons.error),
          borderRadius: 15,
        );
}
