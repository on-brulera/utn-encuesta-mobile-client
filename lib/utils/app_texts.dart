import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppTexts {
  static title(String text) => Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
  static subTitle(String text) => Text(
        text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
      );
  static softText(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black54),
      );

  static textNotification(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      );
  static commentNotification(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.black45,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      );
  static numberNotification(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.black45,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      );

  static perfilText(String text) => Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      );

  static courseText(String text) => Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black54,
          fontSize: 15,
        ),
      );

  static diagrama(String titulo) =>
      Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold));

  static Widget fechaEncuesta(String fechaISO) {
    final DateTime now = DateTime.now();

    // Parsear fecha en formato ISO 8601
    final DateTime fechaEncuesta = DateTime.parse(fechaISO);

    // Determinar si la fecha ya pasó
    final bool isPastDate = fechaEncuesta.isBefore(now);

    // Formatear fecha y hora en el formato deseado
    final String formattedDate = DateFormat('dd-MM-yyyy').format(fechaEncuesta);
    final String formattedTime = DateFormat('HH:mm').format(fechaEncuesta);

    // Construir el texto
    final String displayText = isPastDate
        ? 'Cerró el $formattedDate a las $formattedTime'
        : 'Cierra el $formattedDate a las $formattedTime';

    return Text(
      displayText,
      style: TextStyle(
        fontSize: 10,
        color: isPastDate
            ? const Color.fromARGB(255, 144, 38, 31) // Color rojo
            : const Color.fromARGB(255, 6, 123, 22), // Color verde
      ),
    );
  }

  static fechaCurso(String fecha) {
    {
      return Text(
        fecha,
        style: const TextStyle(
          fontSize: 10,
          color: Color.fromARGB(255, 6, 123, 22),
        ),
      );
    }
  }
}
