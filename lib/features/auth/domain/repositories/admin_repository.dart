import 'package:encuestas_utn/features/auth/domain/entities/user.dart';

abstract class AdminRepository {
  Future<List<User>?> obtenerUsuariosByCodigoRol(String rolCodigo);
}
