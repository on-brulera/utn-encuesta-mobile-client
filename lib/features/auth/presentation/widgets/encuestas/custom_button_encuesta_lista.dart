import 'package:flutter/material.dart';

class CustomButtonEncuestaLista extends StatefulWidget {
  final String title;
  final VoidCallback callback;

  const CustomButtonEncuestaLista({
    super.key,
    required this.title,
    required this.callback,
  });

  @override
  createState() => _CustomButtonEncuestaListaState();
}

class _CustomButtonEncuestaListaState extends State<CustomButtonEncuestaLista> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.callback();
        setState(() {
          isPressed = true;
        });
        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            isPressed = false;
          });
        });
      },
      splashColor: Colors.redAccent.withOpacity(0.9), // Efecto de onda
      borderRadius: BorderRadius.circular(
          5), // Mantener consistencia con el diseño original
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(7)),

          color: isPressed ? Colors.red : Colors.white, // Fondo dinámico
        ),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: isPressed
                ? Colors.white
                : const Color.fromARGB(255, 254, 87, 75), // Texto dinámico
          ),
        ),
      ),
    );
  }
}
