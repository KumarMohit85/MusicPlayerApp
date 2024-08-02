import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const AuthGradientButton(
      {super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              colors: [Pallete.gradient1, Pallete.gradient2],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight)),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(395, 55),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent),
        child: Text(
          text,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
