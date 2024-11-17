import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/disenar_encuesta_provider.dart';
import 'package:encuestas_utn/utils/app_spaces.dart';
import 'package:encuestas_utn/utils/app_texts.dart';

class CustomTileEstilosModelos extends ConsumerStatefulWidget {
  const CustomTileEstilosModelos({super.key});

  @override
  createState() => _CustomTileEstilosModelosState();
}

class _CustomTileEstilosModelosState
    extends ConsumerState<CustomTileEstilosModelos> {
  final TextEditingController _controllerEstilo = TextEditingController();
  String? _selectedModel;
  String _modelDescription = '';

  @override
  Widget build(BuildContext context) {
    final disenarEncuestaState = ref.watch(disenarEncuestaProvider);
    final disenarEncuestaNotifier = ref.read(disenarEncuestaProvider.notifier);

    return ExpansionTile(
      title: const Text('Modelos y Estilos'),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown para seleccionar el modelo
            SizedBox(
              width: double.infinity,
              child: DropdownButton<String>(
                value: _selectedModel,
                hint: const Text('Selecciona un modelo'),
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _selectedModel = value;
                    _modelDescription = modelos[value] ?? '';
                    disenarEncuestaNotifier.setModeloSeleccionado(value!);
                  });
                },
                items: modelos.keys.map((modelo) {
                  return DropdownMenuItem(
                    value: modelo,
                    child: Text(modelo),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),
            AppTexts.softText(_modelDescription),
            const SizedBox(height: 25),

            // Editable section para estilos
            _buildEditableSection(
              'Estilos de Aprendizaje',
              'Nombre del estilo',
              _controllerEstilo,
              disenarEncuestaState.estilosEncuesta ?? [],
              (nombre) => disenarEncuestaNotifier.agregarEstilo(nombre),
              (nombre) => disenarEncuestaNotifier.eliminarEstilo(nombre),
              Colors.redAccent,
            ),
          ],
        ),
      ],
    );
  }

  final Map<String, String> modelos = {
    'Modelo 1': 'Felder y Silverman',
    'Modelo 2': 'Gardner',
    'Modelo 3': 'Bandler & Grinder',
  };

  Widget _buildEditableSection(
    String label,
    String hint,
    TextEditingController controller,
    List<Estilo> estilos,
    Function(String) onAdd,
    Function(String) onDelete,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTexts.subTitle(label),
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
          children: estilos.map((estilo) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(text: estilo.nombre),
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
                    onPressed: () => onDelete(estilo.nombre),
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
