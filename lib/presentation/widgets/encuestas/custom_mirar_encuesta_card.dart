import 'package:encuestas_utn/domain/entities/encuesta.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomMirarEncuestaCard extends StatelessWidget {
  final Encuesta encuesta;
  const CustomMirarEncuestaCard({super.key, required this.encuesta});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        child: AppTexts.textNotification(encuesta.curso),
                      ),
                      const Icon(
                        size: 35,
                        Icons.insert_chart_rounded,
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                  AppSpaces.vertical5,
                  Flexible(
                    child: Text(
                      encuesta.titulo,
                      overflow: TextOverflow
                          .ellipsis, // Trunca el texto si es muy largo
                      maxLines: 3, // Limita el texto a 2 líneas
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  AppSpaces.vertical5,
                  AppTexts.commentNotification(encuesta.parcial),
                  AppSpaces.vertical5,
                  AppTexts.fechaEncuesta(encuesta.fecha),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}