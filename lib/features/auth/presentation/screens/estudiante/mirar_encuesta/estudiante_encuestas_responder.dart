import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/features/auth/domain/entities/encuesta.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/estudiante/estudiante_asignaciones_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EstudianteEncuestasResponder extends ConsumerWidget {
  static String screenName = 'estudiante_encuesta_responder_screen';
  const EstudianteEncuestasResponder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //PARA CARGAS LOS FILTROS DE ENCUESTAS
    final List<Encuesta> encuestas =
        ref.read(estudianteAsignacionProvider).encuestasPorResponder!;

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
            }),            
          ],
        )),
      ),
    );
  }
}
