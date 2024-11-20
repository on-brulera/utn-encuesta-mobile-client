import 'package:encuestas_utn/utils/configuration/connection/conn.dart';
import 'package:encuestas_utn/features/auth/domain/entities/user.dart';
import 'package:encuestas_utn/features/auth/domain/repositories/auth_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User?> login(String usuario, String password) async {
    try {
      final response = await estilosAPI.post('/auth/login', data: {
        'usu_usuario': usuario,
        'usu_password': password,
      });
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> cambiarPassword(User user, String token) async {
    try {
      final response = await estilosAPI.put('/usuario/${user.id}',
          options: addToken(token), data: UserModel.toModel(user).toJson());
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
