import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final Color color;
  const MyButton(
      {super.key,
      required this.onPressed,
      required this.title,
      required this.color});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(color),
          overlayColor: WidgetStateProperty.all(Colors.red),
          elevation: WidgetStateProperty.all(20),
          shadowColor: WidgetStateProperty.all(color),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: "Lobster",
          ),
        ),
      ),
    );
  }
}
