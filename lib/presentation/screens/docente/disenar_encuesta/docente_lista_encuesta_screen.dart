import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/domain/entities/encuesta.dart';
import 'package:encuestas_utn/presentation/screens/screens.dart';
import 'package:encuestas_utn/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DocenteListaEncuestaScreen extends StatelessWidget {
  static const String screenName = 'docente_lista_encuesta_screen';
  const DocenteListaEncuestaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 1300),
      child: Scaffold(
          appBar: AppBar(
            title: AppTexts.title('Encuestas'),
            actions: [
              IconButton.outlined(
                  onPressed: () =>
                      context.go('/${DocenteMenuDScreen.screenName}'),
                  icon: const Icon(Icons.exit_to_app_rounded)),
              AppSpaces.horizontal20,
            ],
          ),
          body: SafeArea(
              child: ListView(
            children: [
              ...encuestas.map((encuesta) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: CustomEncuestaItemList(encuesta: encuesta),
                );
              })
            ],
          ))),
    );
  }
}

final List<Encuesta> encuestas = [
  Encuesta(
      titulo: 'Encuesta de inteligencias multiples',
      autor: 'Felder & Silverman',
      numPreguntas: 12),
  Encuesta(
      titulo: 'Inteligencia VAK',
      autor: 'Felder & Silverman',
      numPreguntas: 12),
  Encuesta(
      titulo: 'Inteligencia Múltidimensional ',
      autor: 'Felder & Silverman',
      numPreguntas: 12),
  Encuesta(
      titulo: 'Inteligencia Múltidimensional ',
      autor: 'Felder & Silverman',
      numPreguntas: 12),
  Encuesta(
      titulo: 'Inteligencia Múltidimensional ',
      autor: 'Felder & Silverman',
      numPreguntas: 12),
  Encuesta(
      titulo: 'Inteligencia Múltidimensional ',
      autor: 'Felder & Silverman',
      numPreguntas: 12),
  Encuesta(
      titulo: 'Inteligencia Múltidimensional ',
      autor: 'Felder & Silverman',
      numPreguntas: 12),
  Encuesta(
      titulo: 'Inteligencia Múltidimensional ',
      autor: 'Felder & Silverman',
      numPreguntas: 12),
];
