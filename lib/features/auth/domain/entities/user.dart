class User {
  final String id;
  final String usuario;
  final String password;
  final String rol;
  final String cedula;
  final int cursoId;

  User({
    required this.id,
    required this.usuario,
    required this.password,
    required this.rol,
    required this.cedula,
    required this.cursoId
  });

  get token => null;
}
