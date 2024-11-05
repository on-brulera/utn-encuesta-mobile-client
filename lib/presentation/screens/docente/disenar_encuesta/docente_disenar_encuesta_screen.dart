import 'package:encuestas_utn/presentation/screens/screens.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DocenteDisenarEncuestaScreen extends StatelessWidget {
  static String screenName = 'docente_disenar_encuesta_screen';
  const DocenteDisenarEncuestaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTexts.title('Diseñar Encuestas'),
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
