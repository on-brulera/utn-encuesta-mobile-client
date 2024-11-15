import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';

class Notificacion {
  final String texto;
  final VoidCallback callback;

  const Notificacion({
    required this.texto,
    required this.callback,
  });
}

class CustomNotificationCard extends StatelessWidget {
  final Notificacion notificacion;
  const CustomNotificationCard({super.key, required this.notificacion});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: notificacion.callback,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),
            // Texto de notificación
            Expanded(
              child: AppTexts.textNotification(notificacion.texto)
            ),
            const SizedBox(width: 10),
            // Divisor vertical estilizado
            const SizedBox(
              height: 40,
              child: VerticalDivider(
                color: Color.fromARGB(255, 255, 213, 210),
                thickness: 1.2,
              ),
            ),
            const SizedBox(width: 10),
            // Icono de flecha en círculo blanco
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 254, 87, 75),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
