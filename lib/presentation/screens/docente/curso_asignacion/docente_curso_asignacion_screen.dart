import 'package:encuestas_utn/presentation/screens/screens.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DocenteCursoAsignacionScreen extends StatelessWidget {
  static String screenName = 'docente_curso_asignacion_screen';
  const DocenteCursoAsignacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTexts.title('Curso y Asignación'),
        actions: [
          IconButton.outlined(
              onPressed: () => context.go('/${DocenteMenuDScreen.screenName}'),
              icon: const Icon(Icons.exit_to_app_rounded)),
          AppSpaces.horizontal20,
        ],
      ),
    );
  }
}
