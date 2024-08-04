import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObscure;
  final bool isReadOnly;
  final VoidCallback? onTap;
  const CustomField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isObscure = false,
      this.isReadOnly = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isReadOnly,
      onTap: onTap,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      obscureText: isObscure,
      validator: (val) {
        if (val!.trim().isEmpty)
          return "$hintText is missing";
        else
          return null;
      },
    );
  }
}
