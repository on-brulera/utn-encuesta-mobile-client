import 'package:encuestas_utn/features/auth/presentation/providers/docente/disenar_encuesta_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/encuestas/disenar_encuesta/custom_regla_calculo_section.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/encuestas/disenar_encuesta/custom_tile_estilos_parametros.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/encuestas/disenar_encuesta/custom_tile_info_encuesta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DocenteDisenarEncuestaScreen extends ConsumerWidget {
  static String screenName = 'docente_disenar_encuesta_screen';

  const DocenteDisenarEncuestaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disenarEncuestaNotifier = ref.read(disenarEncuestaProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Diseñar Encuestas'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton.outlined(
            onPressed: () => context.go('/${DocenteMenuDScreen.screenName}'),
            icon: const Icon(Icons.exit_to_app_rounded),
            color: Colors.black,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTileInfoEncuesta(),
                SizedBox(height: 10),
                CustomTileEstilosParametros(),
                SizedBox(height: 10),
                CustomReglaCalculoSection(),
                SizedBox(height: 10),
                CustomTilesPreguntas(),
                SizedBox(height: 75),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          disenarEncuestaNotifier.crearEncuesta();
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('Crear Encuesta'),
      ),
    );
  }
}

class CustomTilesPreguntas extends ConsumerWidget {
  const CustomTilesPreguntas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preguntas = ref.watch(disenarEncuestaProvider).preguntas;

    return ExpansionTile(
      title: const Text('Preguntas'),
      children: [
        ...preguntas.map((pregunta) {
          return PreguntaWidget(pregunta: pregunta);
        }),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () =>
                ref.read(disenarEncuestaProvider.notifier).agregarPregunta(),
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

class PreguntaWidget extends ConsumerWidget {
  final Pregunta pregunta;

  const PreguntaWidget({super.key, required this.pregunta});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disenarEncuestaNotifier = ref.read(disenarEncuestaProvider.notifier);
    final opciones = pregunta.opciones;

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
              const Text('Pregunta', style: TextStyle(fontSize: 16)),
              const Spacer(),
              IconButton(
                onPressed: () =>
                    disenarEncuestaNotifier.eliminarPregunta(pregunta.id),
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: pregunta.texto,
            decoration: const InputDecoration(
              hintText: 'Escribe la pregunta',
              filled: true,
              fillColor: Color(0xFFF0F0F0),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) => disenarEncuestaNotifier
                .actualizarTextoPregunta(pregunta.id, value),
          ),
          const SizedBox(height: 16),
          const Text('Opciones', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          ...opciones.map((opcion) {
            return OpcionWidget(preguntaId: pregunta.id, opcion: opcion);
          }),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  disenarEncuestaNotifier.agregarOpcion(pregunta.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Agregar Opción',
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
  final String preguntaId;
  final Opcion opcion;

  const OpcionWidget({
    super.key,
    required this.preguntaId,
    required this.opcion,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disenarEncuestaNotifier = ref.read(disenarEncuestaProvider.notifier);
    final estilos = ref.watch(disenarEncuestaProvider).estilos;
    final parametros = ref.watch(disenarEncuestaProvider).parametros;
    final opciones = [
      ...estilos,
      ...parametros
    ]; // Combina estilos y parámetros

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TextFormField(
          initialValue: opcion.texto,
          decoration: const InputDecoration(
            hintText: 'Escribe la opción',
            filled: true,
            fillColor: Color(0xFFF0F0F0),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) => disenarEncuestaNotifier.actualizarTextoOpcion(
            preguntaId,
            opcion.id,
            value,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF0F0F0),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                hint: const Text('Selecciona estilo o parámetro'),
                items: opciones.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          item,
                          overflow: TextOverflow.ellipsis,
                        )),
                  );
                }).toList(),
                onChanged: (value) {
                  // Lógica para manejar el valor seleccionado si es necesario
                  disenarEncuestaNotifier.actualizarOpcionSeleccionada(
                    preguntaId,
                    opcion.id,
                    value,
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () =>
                  disenarEncuestaNotifier.eliminarOpcion(preguntaId, opcion.id),
              icon: const Icon(Icons.delete, color: Colors.lightBlueAccent),
            ),
          ],
        ),
      ],
    );
  }
}
