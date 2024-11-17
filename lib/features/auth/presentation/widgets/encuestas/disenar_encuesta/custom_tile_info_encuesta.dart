import 'package:encuestas_utn/features/auth/presentation/providers/docente/disenar_encuesta_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTileInfoEncuesta extends ConsumerStatefulWidget {
  const CustomTileInfoEncuesta({super.key});

  @override
  createState() => _CustomTileInfoEncuestaState();
}

class _CustomTileInfoEncuestaState
    extends ConsumerState<CustomTileInfoEncuesta> {
  late final TextEditingController _tituloController;
  late final TextEditingController _autorController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _valorPreguntaController;

  @override
  void initState() {
    super.initState();

    // Inicializa los controladores con valores iniciales
    _tituloController = TextEditingController();
    _autorController = TextEditingController();
    _descripcionController = TextEditingController();
    _valorPreguntaController = TextEditingController();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _descripcionController.dispose();
    _valorPreguntaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disenarEncuestaNotifier = ref.read(disenarEncuestaProvider.notifier);
    final disenarEncuestaState = ref.watch(disenarEncuestaProvider);

    // Actualiza los controladores cuando cambia el estado
    _updateController(_tituloController, disenarEncuestaState.encuesta?.titulo);
    _updateController(_autorController, disenarEncuestaState.encuesta?.autor);
    _updateController(
        _descripcionController, disenarEncuestaState.encuesta?.descripcion);
    _updateController(
        _valorPreguntaController, disenarEncuestaState.valorPregunta);

    return ExpansionTile(
      title: const Text('Info Encuesta'),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Titulo',
              controller: _tituloController,
              hintText: 'Nombre del cuestionario',
              onChanged: disenarEncuestaNotifier.setTitulo,
            ),
            _buildTextField(
              label: 'Autor',
              controller: _autorController,
              hintText: 'Nombre del autor',
              onChanged: disenarEncuestaNotifier.setAutor,
            ),
            _buildRadioOptions(disenarEncuestaState, disenarEncuestaNotifier),
            _buildTextField(
              label: 'Descripcion',
              controller: _descripcionController,
              hintText: 'Descripción del test',
              onChanged: disenarEncuestaNotifier.setDescripcion,
            ),
            if (disenarEncuestaState.encuesta?.cuantitativa == true)
              _buildTextField(
                label: 'Valor de la pregunta',
                controller: _valorPreguntaController,
                hintText: '1',
                onChanged: disenarEncuestaNotifier.setValorPregunta,
              ),
          ],
        ),
      ],
    );
  }

  void _updateController(TextEditingController controller, String? value) {
    if (controller.text != (value ?? '')) {
      controller.text = value ?? '';
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
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
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRadioOptions(
      DisenarEncuestaState state, DisenarEncuestaNotifier notifier) {
    final opcionTipoEncuestaSeleccionada =
        state.encuesta?.cuantitativa == true ? 'cuantitativo' : 'cualitativo';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tipo de encuesta'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                title: const Text('Cualitativo',
                    style: TextStyle(color: Colors.black)),
                value: 'cualitativo',
                groupValue: opcionTipoEncuestaSeleccionada,
                onChanged: (value) =>
                    notifier.setTipoEncuesta(value ?? 'cualitativo'),
                activeColor: Colors.red,
              ),
              RadioListTile<String>(
                title: const Text('Cuantitativo',
                    style: TextStyle(color: Colors.black)),
                value: 'cuantitativo',
                groupValue: opcionTipoEncuestaSeleccionada,
                onChanged: (value) =>
                    notifier.setTipoEncuesta(value ?? 'cuantitativo'),
                activeColor: Colors.red,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
