import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/presentation/screens/screens.dart';
import 'package:encuestas_utn/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EstudianteEncuestasResponder extends StatelessWidget {
  static String screenName = 'estudiante_encuesta_responder_screen';
  const EstudianteEncuestasResponder({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 1300),
      child: Scaffold(
        appBar: AppBar(
          title: AppTexts.title('Encuestas por responder'),
          actions: [
            IconButton.outlined(
                onPressed: () =>
                    context.go('/${EstudianteMenuDScreen.screenName}'),
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
                child: CustomResponderEncuestaCard(encuesta: encuesta),
              );
            })
          ],
        )),
      ),
    );
  }
}
