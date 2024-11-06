import 'package:flutter/material.dart';

class CustomMessageFieldBox extends StatelessWidget {
  final ValueChanged<String> onValue;
  const CustomMessageFieldBox({super.key, required this.onValue});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    final textController = TextEditingController();

    final outlineInputBorder = UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(40));

    final inputDecoration = InputDecoration(
        hintText: 'Termina la oración con un "?"',
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        filled: true,
        suffixIcon: IconButton(
            onPressed: () {
              final textValue = textController.value.text;
              textController.clear();
              onValue(textValue);
            },
            icon: const Icon(Icons.send_outlined)));

    return TextFormField(
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      decoration: inputDecoration,
      controller: textController,
      focusNode: focusNode,
      onFieldSubmitted: (value) {
        onValue(value);
        textController.clear();
        focusNode.requestFocus();
      },
    );
  }
}