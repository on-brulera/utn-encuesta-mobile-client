import 'package:encuestas_utn/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class HomeDocenteScreen extends StatelessWidget {
  static const String screenName = 'homedocentescreen';
  const HomeDocenteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estilos de Aprendizaje'),
        leading: IconButton.outlined(
            onPressed: () => context.go('/${LoginScreen.screenName}'),
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
      ),
    );
  }
}
