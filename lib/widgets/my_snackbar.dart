import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MySnackbar extends StatelessWidget {
  final String title;
  final String message;
  final bool success;
  const MySnackbar(
      {super.key,
      required this.title,
      required this.message,
      required this.success});

  @override
  Widget build(BuildContext context) {
    return GetSnackBar(
      backgroundColor: success ? Colors.green : Colors.red,
      title: title,
      message: message,
      duration: const Duration(seconds: 5),
      icon: Icon(success ? Icons.check : Icons.error),
    );
  }
}
