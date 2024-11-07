import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomCrearCursoBox extends StatelessWidget {
  const CustomCrearCursoBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: AppTexts.subTitle("Añadir curso"),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carrera
              AppTexts.softText('Carrera'),
              AppSpaces.vertical5,
              DropdownButtonFormField<String>(
                focusColor: Colors.white,
                dropdownColor: Colors.white,
                style: const TextStyle(
                  color: Colors.black,
                ),
                items: const [
                  DropdownMenuItem(
                      value: "Ingeniería en Telecomunicaciones",
                      child: Text("Ingeniería en Telecomunicaciones")),
                  DropdownMenuItem(
                      value: "Ingeniería en Sistemas",
                      child: Text("Ingeniería en Sistemas")),
                ],
                onChanged: (value) {},
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              AppSpaces.vertical15,

              // Semestre
              AppTexts.softText('Semestre'),
              AppSpaces.vertical5,
              DropdownButtonFormField<String>(
                focusColor: Colors.white,
                dropdownColor: Colors.white,
                style: const TextStyle(
                  color: Colors.black,
                ),
                items: const [
                  DropdownMenuItem(
                      value: "Semestre 1", child: Text("Semestre 1")),
                  DropdownMenuItem(
                      value: "Semestre 2", child: Text("Semestre 2")),
                ],
                onChanged: (value) {},
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              AppSpaces.vertical15,

              // Periodo Académico
              AppTexts.softText('Periodo Académico'),
              AppSpaces.vertical5,

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "mm/dd/yyyy",
                        suffixIcon: Icon(Icons.calendar_today),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  AppSpaces.horizontal10,
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "mm/dd/yyyy",
                        suffixIcon: Icon(Icons.calendar_today),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
