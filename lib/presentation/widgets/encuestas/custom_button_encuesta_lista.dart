import 'package:flutter/material.dart';

class CustomButtonEncuestaLista extends StatelessWidget {
  final String title;
  final VoidCallback callback;

  const CustomButtonEncuestaLista({
    super.key,
    required this.title,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          border: Border.symmetric(),
          color: Colors.white,
          shape: BoxShape.rectangle,
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Color.fromARGB(255, 254, 87, 75),
          ),
        ));
  }
}
