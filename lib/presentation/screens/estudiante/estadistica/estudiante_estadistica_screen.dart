import 'package:encuestas_utn/presentation/screens/screens.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EstudianteEstadisticaScreen extends StatelessWidget {
  static String screenName = 'estudiante_estadistica_screen';
  const EstudianteEstadisticaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTexts.title('Estadística'),
        actions: [
          IconButton.outlined(
              onPressed: () => context.go('/${EstudianteMenuDScreen.screenName}'),
              icon: const Icon(Icons.exit_to_app_rounded)),
          AppSpaces.horizontal20,
        ],
      ),
    );
  }
}
