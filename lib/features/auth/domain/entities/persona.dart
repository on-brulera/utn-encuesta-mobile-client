class Persona {
  final String cedula;
  final String nombres;

  Persona({required this.cedula, required this.nombres});

  Persona copyWith({String? cedula, String? nombres}) =>
      Persona(cedula: cedula ?? this.cedula, nombres: nombres ?? this.nombres);
}
