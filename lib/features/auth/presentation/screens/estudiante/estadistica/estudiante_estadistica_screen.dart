import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';

import 'package:flutter/material.dart';

class EstudianteEstadisticaScreen extends StatelessWidget {
  static String screenName = 'estudiante_estadistica_screen';
  const EstudianteEstadisticaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CurstomAppBar(titulo: 'Estadística'), body: Placeholder());
  }
}
