import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DocenteEstadisticaScreen extends StatelessWidget {
  static String screenName = 'docente_estadistica_screen';
  const DocenteEstadisticaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTexts.title('Estadística'),
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
