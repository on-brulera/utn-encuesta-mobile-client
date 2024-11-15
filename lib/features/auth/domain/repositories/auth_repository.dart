
import 'package:encuestas_utn/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String usuario, String password);
}