class User {
  final String id;
  final String usuario;
  final String password;
  final String rol;
  final String cedula;
  final int cursoId;

  User(
      {required this.id,
      required this.usuario,
      required this.password,
      required this.rol,
      required this.cedula,
      required this.cursoId});

  get token => null;

  User copyWith({
    String? id,
    String? usuario,
    String? password,
    String? rol,
    String? cedula,
    int? cursoId,
  }) =>
      User(
          id: id ?? this.id,
          usuario: usuario ?? this.usuario,
          password: password ?? this.password,
          rol: rol ?? this.rol,
          cedula: cedula ?? this.cedula,
          cursoId: cursoId ?? this.cursoId);
}
