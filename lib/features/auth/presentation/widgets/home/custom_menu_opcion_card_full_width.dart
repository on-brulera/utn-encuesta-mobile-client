import 'package:encuestas_utn/features/auth/presentation/widgets/home/custom_menu_opcion_card.dart';
import 'package:flutter/material.dart';

class CustomMenuOpcionCardFullWidth extends StatelessWidget {
  final MenuOpcions opcion;

  const CustomMenuOpcionCardFullWidth({super.key, required this.opcion});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: opcion.callback,
      child: Container(
        width: double.infinity, // Ocupa todo el ancho disponible
        margin: const EdgeInsets.symmetric(
            vertical: 10), // Separación entre tarjetas
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent, // Color inicial
              Colors.blue.shade700, // Color más oscuro
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Texto en el lado izquierdo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opcion.titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    opcion.descripcion,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 25,
            ),
            // Imagen en el lado derecho
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  15), // Opcional, si quieres bordes redondeados
              child: Image.asset(
                opcion.imagen,
                width: 80, // Ajusta el tamaño según tus necesidades
                height: 80,
                fit: BoxFit.cover, // Ajusta la imagen al espacio
              ),
            ),
          ],
        ),
      ),
    );
  }
}
