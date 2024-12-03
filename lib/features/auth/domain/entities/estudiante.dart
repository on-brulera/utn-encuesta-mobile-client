class Estudiante {
  final int usuarioId;
  final String nombre;
  final String cedula;
  final double nota1;
  final int nota1Id;
  final double nota2;
  final int nota2Id;
  final double promedio;

  Estudiante({
    this.usuarioId = 0,
    required this.nombre,
    required this.cedula,
    required this.nota1,
    this.nota1Id = 0,
    required this.nota2,
    this.nota2Id = 0,
    required this.promedio,
  });
}
