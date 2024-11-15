import 'package:dio/dio.dart';
import 'package:encuestas_utn/utils/configuration/const/const.dart';

final estilosAPI = Dio(BaseOptions(
  baseUrl: Const.apiBaseUrl,
));

Options addToken(String token) {
  return Options(
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json', 
    },
  );
}
