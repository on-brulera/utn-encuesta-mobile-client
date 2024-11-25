import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/disenar_encuesta_provider.dart';
import 'package:encuestas_utn/utils/app_spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTilesPreguntas extends ConsumerWidget {
  const CustomTilesPreguntas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preguntas = ref.watch(disenarEncuestaProvider).preguntas;

    return ExpansionTile(
      title: const Text('Preguntas'),
      children: [
        ...preguntas.map((preguntaOpciones) {
          return PreguntaWidget(
            key: ValueKey(preguntaOpciones.pregunta.orden),
            preguntaOpciones: preguntaOpciones,
          );
        }),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => ref
                .watch(disenarEncuestaProvider.notifier)
                .agregarPregunta(''), // Añadir una pregunta inicial
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Añadir Pregunta',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class PreguntaWidget extends ConsumerStatefulWidget {
  final PreguntaOpciones preguntaOpciones;

  const PreguntaWidget({super.key, required this.preguntaOpciones});

  @override
  ConsumerState<PreguntaWidget> createState() => _PreguntaWidgetState();
}

class _PreguntaWidgetState extends ConsumerState<PreguntaWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.preguntaOpciones.pregunta.enunciado);
  }

  @override
  void didUpdateWidget(covariant PreguntaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.preguntaOpciones.pregunta.enunciado !=
        widget.preguntaOpciones.pregunta.enunciado) {
      _controller.text = widget.preguntaOpciones.pregunta.enunciado;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disenarEncuestaNotifier = ref.watch(disenarEncuestaProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Pregunta ${widget.preguntaOpciones.pregunta.orden}',
                style: const TextStyle(fontSize: 16, color: Colors.black38),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => disenarEncuestaNotifier.eliminarPregunta(
                  widget.preguntaOpciones.pregunta.orden,
                ),
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Escribe la pregunta',
              filled: true,
              fillColor: Color(0xFFF0F0F0),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) => disenarEncuestaNotifier.actualizarPregunta(
              ordenPregunta: widget.preguntaOpciones.pregunta.orden,
              enunciado: value,
            ),
          ),
          const SizedBox(height: 8),
          ...widget.preguntaOpciones.opciones.asMap().entries.map((entry) {
            final index = entry.key;
            final opcion = entry.value;
            return OpcionWidget(
              key: ValueKey(opcion.id),
              preguntaOpciones: widget.preguntaOpciones,
              opcion: opcion,
              label: String.fromCharCode(
                  65 + index), // Generar letras A, B, C, ...
            );
          }),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final modeloSeleccionado =
                    ref.read(disenarEncuestaProvider).modeloSeleccionado;

                if (modeloSeleccionado == 'Modelo 2') {
                  // Crear automáticamente opciones "Verdadero" y "Falso"
                  disenarEncuestaNotifier.agregarOpcionesModelo2(
                    ordenPregunta: widget.preguntaOpciones.pregunta.orden,
                  );
                } else {
                  // Comportamiento estándar de agregar una opción vacía
                  final nuevaOpcion = Opcion(
                    id: DateTime.now().millisecondsSinceEpoch, // ID único
                    preguntaId: widget.preguntaOpciones.pregunta.id,
                    estiloId: 0,
                    texto: '',
                    valorCualitativo: '',
                    valorCuantitativo: 0.0,
                  );
                  disenarEncuestaNotifier.agregarOpcion(
                    ordenPregunta: widget.preguntaOpciones.pregunta.orden,
                    nuevaOpcion: nuevaOpcion,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Añadir Opción',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OpcionWidget extends ConsumerWidget {
  final PreguntaOpciones preguntaOpciones;
  final Opcion opcion;
  final String label; // Nuevo campo para la etiqueta

  const OpcionWidget({
    super.key,
    required this.preguntaOpciones,
    required this.opcion,
    required this.label, // Recibe la etiqueta
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disenarEncuestaNotifier = ref.watch(disenarEncuestaProvider.notifier);
    final estilosEncuesta =
        ref.watch(disenarEncuestaProvider).estilosEncuesta ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Opción $label', // Mostrar la etiqueta (A, B, C, ...)
              style: const TextStyle(fontSize: 16, color: Colors.black38)),
          AppSpaces.vertical10,
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: opcion.texto,
                  decoration: const InputDecoration(
                    hintText: 'Escribe la opción',
                    filled: true,
                    fillColor: Color(0xFFF0F0F0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => disenarEncuestaNotifier.editarOpcion(
                    ordenPregunta: preguntaOpciones.pregunta.orden,
                    idOpcion: opcion.id,
                    texto: value,
                    valorCualitativo: label
                  ),
                ),
              ),
              IconButton(
                onPressed: () => disenarEncuestaNotifier.eliminarOpcion(
                  ordenPregunta: preguntaOpciones.pregunta.orden,
                  idOpcion: opcion.id,
                ),
                icon: const Icon(Icons.delete, color: Colors.lightBlueAccent),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Selecciona un estilo:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          DropdownButton<String>(
            value: opcion.nombreEstilo.isNotEmpty
                ? opcion.nombreEstilo
                : null,
            isExpanded: true,
            hint: const Text('Sin estilo'),
            items: [
              const DropdownMenuItem<String>(
                value: 'Sin estilo',
                child: Text('Sin estilo'),
              ),
              ...estilosEncuesta.map((estilo) {
                return DropdownMenuItem<String>(
                  value: estilo.nombre,
                  child: Text(estilo.nombre),
                );
              }),
            ],
            onChanged: (String? nuevoValor) {
              disenarEncuestaNotifier.editarOpcion(
                ordenPregunta: preguntaOpciones.pregunta.orden,
                idOpcion: opcion.id,                
                valorCualitativo: label,
                nombreEstilo: nuevoValor == 'Sin estilo' ? 'Sin estilo' : nuevoValor
              );
            },
          ),
        ],
      ),
    );
  }
}
