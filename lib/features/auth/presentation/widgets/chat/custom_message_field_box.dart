import 'package:flutter/material.dart';

class CustomMessageFieldBox extends StatelessWidget {
  final Function(String) onValue;

  const CustomMessageFieldBox({super.key, required this.onValue});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Escribe tu mensaje...',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            final text = controller.text;
            if (text.isNotEmpty) {
              onValue(text);
              controller.clear();
            }
          },
        ),
      ],
    );
  }
}

