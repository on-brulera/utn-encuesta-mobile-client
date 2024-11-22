import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/features/auth/domain/entities/encuesta.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EstudianteEncuestasResponder extends StatelessWidget {
  static String screenName = 'estudiante_encuesta_responder_screen';
  const EstudianteEncuestasResponder({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Encuesta> encuestas = [];
    return FadeIn(
      duration: const Duration(milliseconds: 1300),
      child: Scaffold(
        appBar: const CurstomAppBar(titulo: 'Encuestas'),
        body: SafeArea(
            child: ListView(
          children: [
            ...encuestas.map((encuesta) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: CustomResponderEncuestaCard(encuesta: encuesta),
              );
            })
          ],
        )),
      ),
    );
  }
}
