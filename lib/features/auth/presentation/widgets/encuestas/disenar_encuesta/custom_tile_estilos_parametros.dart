import 'package:encuestas_utn/features/auth/presentation/providers/docente/disenar_encuesta_provider.dart';
import 'package:encuestas_utn/utils/app_spaces.dart';
import 'package:encuestas_utn/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTileEstilosParametros extends ConsumerStatefulWidget {
  const CustomTileEstilosParametros({super.key});

  @override
  createState() => _CustomTileEstilosParametrosState();
}

class _CustomTileEstilosParametrosState
    extends ConsumerState<CustomTileEstilosParametros> {
  final TextEditingController _controllerEstilo = TextEditingController();
  final TextEditingController _controllerParametro = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final disenarEncuestaState = ref.watch(disenarEncuestaProvider);
    final disenarEncuestaNotifier = ref.read(disenarEncuestaProvider.notifier);

    return ExpansionTile(
      title: const Text('Estilos y Parámetros'),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEditableSection(
              'Estilos de Aprendizaje',
              'Nombre del estilo',
              _controllerEstilo,
              disenarEncuestaState.estilos,
              disenarEncuestaNotifier.agregarEstilo,
              disenarEncuestaNotifier.eliminarEstilo,
              Colors.redAccent,
            ),
            const SizedBox(height: 16),
            _buildEditableSection(
              'Parámetros',
              'Nombre del parámetro',
              _controllerParametro,
              disenarEncuestaState.parametros,
              disenarEncuestaNotifier.agregarParametro,
              disenarEncuestaNotifier.eliminarParametro,
              Colors.redAccent,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditableSection(
    String label,
    String hint,
    TextEditingController controller,
    List<String> items,
    Function(String) onAdd,
    Function(String) onDelete,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTexts.softText(label),
        AppSpaces.vertical15,
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  filled: true,
                  fillColor: const Color(0xFFF0F0F0),
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onAdd(controller.text);
                  controller.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Agregar'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(text: item),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF0F0F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => onDelete(item),
                    icon: Icon(Icons.delete, color: color),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
