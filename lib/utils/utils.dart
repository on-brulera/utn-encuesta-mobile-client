import 'package:flutter/services.dart';

export 'package:encuestas_utn/utils/app_texts.dart';
export 'package:encuestas_utn/utils/app_assets.dart';
export 'package:encuestas_utn/utils/app_spaces.dart';
import 'package:intl/intl.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText =
        newValue.text.replaceAll('-', ''); // Elimina los guiones existentes
    final buffer = StringBuffer();

    for (int i = 0; i < newText.length; i++) {
      if (i == 2 || i == 4) {
        // Añade el guion en las posiciones correctas
        buffer.write('-');
      }
      buffer.write(newText[i]);
    }

    final formattedText = buffer.toString();

    // Limita la longitud al formato "dd-mm-yyyy"
    if (formattedText.length > 10) {
      return oldValue;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

DateTime convertirAISO8601(String fecha) {
  // Importar el paquete intl si necesitas formatear de forma personalizada
  // Asegúrate de tener intl en tu pubspec.yaml:
  // dependencies:
  //   intl: ^0.18.0

  try {
    // Parsear la fecha desde el formato "dd-MM-yyyy"
    DateFormat formatoEntrada = DateFormat("dd-MM-yyyy");
    DateTime fechaConvertida = formatoEntrada.parse(fecha);

    // Crear una nueva fecha con hora 23:59
    DateTime fechaFinal = DateTime(
      fechaConvertida.year,
      fechaConvertida.month,
      fechaConvertida.day,
      23,
      59,
    );

    // Convertir la fecha al formato ISO 8601
    return fechaFinal;
  } catch (e) {
    throw FormatException("Formato de fecha inválido: $fecha");
  }
}

