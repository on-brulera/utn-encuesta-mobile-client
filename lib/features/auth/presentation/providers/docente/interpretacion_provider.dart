import 'package:encuestas_utn/features/auth/domain/repositories/docente_repository.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_utn/features/auth/domain/entities/mensaje.dart';

class InterpretacionNotifier extends StateNotifier<AsyncValue<Mensaje?>> {
  final DocenteRepository docenteRepository;

  InterpretacionNotifier(this.docenteRepository)
      : super(const AsyncValue.data(null));

  Future<void> cargarInterpretacion(String datos, String mensaje) async {
    state = const AsyncValue.loading(); // Estado cargando
    try {
      // final respuesta =
      //     await docenteRepository.analizarResultado(datos, mensaje);
      // state = AsyncValue.data(respuesta); // Guardar la respuesta
      state = AsyncValue.data(Mensaje(
          fromWho: FromWho.ia,
          text: "$mensaje - $datos")); // Guardar la respuesta
    } catch (e) {
      state = AsyncValue.data(Mensaje(
          fromWho: FromWho.ia,
          text:
              'De momento no es posible realizar el análisis de la encuesta, el chat esta inactivo.')); // Manejo de errores
    }
  }
}

final interpretacionProvider =
    StateNotifierProvider<InterpretacionNotifier, AsyncValue<Mensaje?>>(
  (ref) => InterpretacionNotifier(DocenteRepositoryImpl()),
);
