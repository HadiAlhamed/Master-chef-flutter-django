// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final bool? isObsecure;
  final Widget? suffixWidget;
  const AuthInput({
    super.key,
    required this.title,
    this.controller,
    this.isObsecure,
    this.suffixWidget,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: "Lobster",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          validator: (val) {
            if (val == null || val == '') {
              return "Cannot Be Empty";
            }
            return null;
          },
          obscureText: isObsecure ?? false,
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            suffixIcon: suffixWidget,
          ),
        ),
      ],
    );
  }
}
