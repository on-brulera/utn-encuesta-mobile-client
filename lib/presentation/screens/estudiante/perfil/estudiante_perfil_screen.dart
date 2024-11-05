import 'package:encuestas_utn/presentation/screens/screens.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EstudiantePerfilScreen extends StatelessWidget {
  static String screenName = 'estudiante_perfil_screen';
  const EstudiantePerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTexts.title('Perfil'),
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