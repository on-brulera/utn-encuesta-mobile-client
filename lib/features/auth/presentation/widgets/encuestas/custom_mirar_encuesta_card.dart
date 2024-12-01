import 'package:encuestas_utn/features/auth/domain/entities/encuesta.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomMirarEncuestaCard extends StatelessWidget {
  final Encuesta encuesta;
  const CustomMirarEncuestaCard({super.key, required this.encuesta});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(EstudianteEncuestaDetallesScreen.screenName,
            pathParameters: {
              'idEncuesta': encuesta.id.toString(),
              'idAsignacion': encuesta.idAsignacion.toString()
            });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpaces.horizontal15,
            Expanded(
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: AppTexts.textNotification('Encuesta'),
                        ),
                        const Icon(
                          size: 35,
                          Icons.insert_chart_rounded,
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                    AppSpaces.vertical10,
                    Flexible(
                      child: Text(
                        encuesta.titulo,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow
                            .ellipsis, // Trunca el texto si es muy largo
                        maxLines: 3, // Limita el texto a 2 líneas
                      ),
                    ),
                    AppSpaces.vertical20,
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: encuesta.respondido
                              ? const Color.fromARGB(255, 210, 244, 211)
                              : const Color.fromARGB(255, 253, 213, 217),
                          borderRadius:
                              BorderRadius.circular(20), // Bordes redondeados
                        ),
                        child: Text(
                          encuesta.respondido ? "Respondido" : "No Respondido",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Trunca el texto si es muy largo
                          maxLines: 3, // Limita el texto a 3 líneas
                        ),
                      ),
                    ),
                    AppSpaces.vertical10,
                    AppTexts.fechaEncuesta(encuesta.fechaLimite),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
