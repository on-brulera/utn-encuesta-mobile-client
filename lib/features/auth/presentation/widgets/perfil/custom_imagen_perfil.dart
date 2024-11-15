import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomImagenPerfil extends StatelessWidget {
  const CustomImagenPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(AppAssets.academico)),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
