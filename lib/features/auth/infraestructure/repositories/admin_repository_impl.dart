import 'package:encuestas_utn/features/auth/domain/entities/user.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/admin_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/models/user_model.dart';
import 'package:encuestas_utn/utils/configuration/connection/conn.dart';

class AdminRepositoryImpl implements AdminRepository {
  @override
  Future<List<User>?> obtenerUsuariosByCodigoRol(String rolCodigo) async {
    try {
      final response = await estilosAPI.get(
        '/usuario/rol/codigo/$rolCodigo',
      );

      if (response.statusCode == 200) {
        final List<dynamic> respuestasJson = response.data['data'];
        final List<User> respuestas = respuestasJson
            .map((resultado) => UserModel.fromJson(resultado))
            .toList();
        return respuestas;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
