import 'package:encuestas_utn/features/auth/domain/entities/encuesta.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/estudiante/mirar_encuesta/estudiante_encuesta_detalles_responder_screen.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomResponderEncuestaCard extends StatelessWidget {
  final Encuesta encuesta;
  const CustomResponderEncuestaCard({
    super.key,
    required this.encuesta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          Expanded(
              child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTexts.textNotification(encuesta.titulo),
                AppSpaces.vertical5,
                AppTexts.commentNotification(encuesta.autor),
                AppSpaces.vertical5,
                // AppTexts.numberNotification(encuesta.descripcion),
                AppSpaces.vertical5,
                AppTexts.fechaEncuesta(encuesta.fechaLimite),
              ],
            ),
          )),
          const SizedBox(width: 10),
          // Divisor vertical estilizado
          const SizedBox(
            height: 70,
            child: VerticalDivider(
              color: Color.fromARGB(255, 255, 213, 210),
              thickness: 1.2,
            ),
          ),
          const SizedBox(width: 10),
          //BOTONES
          IntrinsicHeight(
            child: Column(
              children: [
                CustomButtonEncuestaLista(
                  title: 'responder',
                  callback: () => context.pushNamed(
                      EstudianteEncuestaDetallesResponderScreen.screenName,
                      pathParameters: {
                        'idEncuesta': encuesta.id.toString(),
                        'idAsignacion': encuesta.idAsignacion.toString()
                      }),
                ),
                AppSpaces.vertical5,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
