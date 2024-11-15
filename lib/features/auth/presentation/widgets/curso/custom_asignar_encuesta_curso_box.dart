import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomAsignarEncuestaCursoBox extends StatelessWidget {
  const CustomAsignarEncuestaCursoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: AppTexts.subTitle("Asignación encuesta a un curso"),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carrera
              AppTexts.softText('Curso'),
              AppSpaces.vertical5,
              DropdownButtonFormField<String>(
                focusColor: Colors.white,
                dropdownColor: Colors.white,
                style: const TextStyle(
                  color: Colors.black,
                ),
                items: const [
                  DropdownMenuItem(
                      value: "Telecomunicaciones 3 - 2024-2025",
                      child: Text("Telecomunicaciones 3 - 2024-2025")),
                  DropdownMenuItem(
                      value: "Sofware 1 - 2025-2026",
                      child: Text("Sofware 1 - 2025-2026")),
                ],
                onChanged: (value) {},
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              AppSpaces.vertical15,

              // Asignaturas
              AppTexts.softText('Asignatura'),
              AppSpaces.vertical5,
              DropdownButtonFormField<String>(
                focusColor: Colors.white,
                dropdownColor: Colors.white,
                style: const TextStyle(
                  color: Colors.black,
                ),
                items: const [
                  DropdownMenuItem(
                      value: "Realidad Nacional",
                      child: Text("Realidad Nacional")),
                  DropdownMenuItem(value: "Ética", child: Text("Ética")),
                  DropdownMenuItem(
                      value: "Ecuaciones Diferenciales",
                      child: Text("Ecuaciones Diferenciales")),
                ],
                onChanged: (value) {},
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              AppSpaces.vertical15,

              // Fecha de encuesta
              AppTexts.softText('Fechal límite de responder encuesta'),
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
                ],
              ),
              AppSpaces.vertical15,
              // Subir Listado de Estudiantes
              AppTexts.softText('Listado de estudiantes'),
              AppSpaces.vertical10,
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.white, // Fondo blanco
                  foregroundColor: const Color.fromARGB(
                      255, 165, 165, 165), // Texto en rojo oscuro
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 205, 187, 187),
                      width: 1), // Borde en rojo oscuro
                ),
                child: AppTexts.subTitle('subir listado de estudiantes'),
              ),
              AppSpaces.vertical5,
              // Parciales
              AppTexts.softText('Notas del Parcial'),
              AppSpaces.vertical5,
              DropdownButtonFormField<String>(
                focusColor: Colors.white,
                dropdownColor: Colors.white,
                style: const TextStyle(
                  color: Colors.black,
                ),
                items: const [
                  DropdownMenuItem(
                      value: "Parcial 1", child: Text("Parcial 1")),
                  DropdownMenuItem(
                      value: "Parcial 2", child: Text("Parcial 2")),
                ],
                onChanged: (value) {},
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              AppSpaces.vertical15,
              // Action Guardar Asignación
              AppTexts.softText('Guardar Asignación'),
              AppSpaces.vertical10,
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity,
                      50), // Ocupa todo el ancho y fija la altura
                  backgroundColor: const Color.fromARGB(255, 230, 38, 38),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Radio de 20 para el borde
                  ),
                ),
                child: AppTexts.subTitle('Guardar Asignación'),
              ),
              AppSpaces.vertical5,
            ],
          ),
        ),
      ],
    );
  }
}
