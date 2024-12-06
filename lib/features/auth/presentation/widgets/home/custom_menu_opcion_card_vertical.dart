import 'package:encuestas_utn/features/auth/presentation/widgets/home/custom_menu_opcion_card.dart';
import 'package:flutter/material.dart';

class CustomMenuOpcionCardVertical extends StatelessWidget {
  final MenuOpcions opcion;
  const CustomMenuOpcionCardVertical({super.key, required this.opcion});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: opcion.callback,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        height: 280,
        width: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [
              Colors.redAccent, // Color inicial
              Colors.red.shade700, // Color más oscuro
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              children: [
                Text(
                  opcion.titulo,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(opcion.descripcion,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 234, 223, 223),
                          fontSize: 15)),
                )
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Image.asset(
                opcion.imagen,
                width: 70,
                height: 70,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
