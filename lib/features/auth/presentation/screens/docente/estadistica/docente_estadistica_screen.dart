import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DocenteEstadisticaScreen extends StatelessWidget {
  static String screenName = 'docente_estadistica_screen';
  const DocenteEstadisticaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CurstomAppBar(titulo: 'Estadística')
    );
  }
}
