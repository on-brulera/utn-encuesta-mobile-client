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

  static fechaEncuesta(String fecha) {
    {
      final DateTime today = DateTime.now();
      final DateTime fechaEncuesta = DateFormat('dd-MM-yyyy').parse(fecha);
      final bool isPastDate = fechaEncuesta.isBefore(today);
      return Text(
        isPastDate ? 'Cerró el $fecha' : 'Cierra el $fecha',
        style: TextStyle(
          fontSize: 10,
          color: isPastDate
              ? const Color.fromARGB(255, 144, 38, 31)
              : const Color.fromARGB(255, 6, 123, 22), // Cambia el color aquí
        ),
      );
    }
  }
}
