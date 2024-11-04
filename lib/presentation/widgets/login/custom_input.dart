import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hint;
  final bool obscure;
  final Icon icon;

  const CustomInput(
      {super.key,
      required this.hint,
      required this.obscure,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          icon: icon,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
