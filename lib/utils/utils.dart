import 'package:flutter/services.dart';

export 'package:encuestas_utn/utils/app_texts.dart';
export 'package:encuestas_utn/utils/app_assets.dart';
export 'package:encuestas_utn/utils/app_spaces.dart';


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
