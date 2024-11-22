import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/features/auth/domain/entities/encuesta.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EstudianteMirarEncuestaScreen extends StatelessWidget {
  static String screenName = 'estudiante_mirar_encuesta_screen';
  const EstudianteMirarEncuestaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Encuesta> encuestas = List.generate(
      10,
      (index) => Encuesta(
        fechaCreacion: DateTime.now(),
        titulo: 'Encuesta de Felder y Silverman',
        autor: 'Autor B',
      ),
    );

    return FadeIn(
      duration: const Duration(milliseconds: 1230),
      child: Scaffold(
        appBar: const CurstomAppBar(titulo: 'Mirar Encuestas'),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200, // Ajusta el máximo ancho de cada card
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8, // Ajusta la proporción ancho/alto
            ),
            itemCount: encuestas.length,
            itemBuilder: (context, index) {
              return CustomMirarEncuestaCard(
                encuesta: encuestas[index],
              );
            },
          ),
        )),
      ),
    );
  }
}
