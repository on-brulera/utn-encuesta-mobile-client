import 'package:encuestas_utn/features/auth/presentation/providers/docente/disenar_encuesta_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/encuestas/disenar_encuesta/custom_regla_calculo_section.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/encuestas/disenar_encuesta/custom_tile_estilos_modelos.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/encuestas/disenar_encuesta/custom_tile_info_encuesta.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/encuestas/disenar_encuesta/custom_tiles_preguntas.dart';
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
                CustomTileEstilosModelos(),
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
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(
              context); // Captura el messenger antes del async gap
          final encuestaCreada = await disenarEncuestaNotifier.crearEncuesta();

          if (encuestaCreada) {
            messenger.showSnackBar(
              const SnackBar(
                content: Text('Encuesta Guardada'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            messenger.showSnackBar(
              const SnackBar(
                content: Text(
                    'Error al guardar la encuesta, llene todos los campos'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('Guardar Encuesta'),
      ),
    );
  }
}
