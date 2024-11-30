import 'package:encuestas_utn/features/auth/presentation/widgets/home/custom_menu_opcion_card.dart';
import 'package:encuestas_utn/utils/utils.dart';

List<MenuOpcions> opcionesMenuDocente = [
  MenuOpcions(
    titulo: 'Diseñar Encuesta',
    descripcion: '¡Crea encuestas para determinar los estilos de aprendizaje!',
    imagen: AppAssets.encuesta,
    callback: () {},
  ),
  MenuOpcions(
    titulo: 'Curso y Asignación',
    descripcion: '¡Designa encuestas creadas a cursos de estudiantes!',
    imagen: AppAssets.curso,
    callback: () {},
  ),
  // MenuOpcions(
  //   titulo: 'Estadística',
  //   descripcion: '¡Observa los resultados de tus encuestas!',
  //   imagen: AppAssets.grafico,
  //   callback: () {},
  // ),
  MenuOpcions(
    titulo: 'Perfil',
    descripcion: '¡Mira una breve descripción de tu perfil!',
    imagen: AppAssets.perfil,
    callback: () {},
  ),
];

List<MenuOpcions> opcionesMenuEstudiante = [
  MenuOpcions(
    titulo: 'Mirar Encuesta',
    descripcion: '¡Mira que estilo de aprendizaje tienes!',
    imagen: AppAssets.encuesta,
    callback: () {},
  ),
  MenuOpcions(
    titulo: 'Cursos',
    descripcion: '¡Mira todos los cursos y materias que formas partes!',
    imagen: AppAssets.curso,
    callback: () {},
  ),
  // MenuOpcions(
  //   titulo: 'Estadística',
  //   descripcion: '¡Observa los resultados de tus encuestas!',
  //   imagen: AppAssets.grafico,
  //   callback: () {},
  // ),
  MenuOpcions(
    titulo: 'Perfil',
    descripcion: '¡Mira una breve descripción de tu perfil!',
    imagen: AppAssets.perfil,
    callback: () {},
  ),
];
