class User {
  final String id;
  final String usuario;
  final String password;
  final String rol;

  User({
    required this.id,
    required this.usuario,
    required this.password,
    required this.rol,
  });

  get token => null;
}
