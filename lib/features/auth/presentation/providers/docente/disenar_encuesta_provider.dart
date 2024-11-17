import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisenarEncuestaState {
  final Encuesta? encuesta;
  final Map<String, String> modeloSeleccionado;
  final List<Estilo>? estilosEncuesta;
  final String? valorPregunta;
  final List<PreguntaOpciones> preguntas;

  DisenarEncuestaState({
    List<PreguntaOpciones>? preguntas,
    Encuesta? encuesta,
    Map<String, String>? modeloSeleccionado,
    List<Estilo>? estilosEncuesta,
    this.valorPregunta,
  })  : encuesta = encuesta ?? Encuesta(fechaCreacion: DateTime.now()),
        modeloSeleccionado = modeloSeleccionado ?? {},
        estilosEncuesta = estilosEncuesta ?? [],
        preguntas = preguntas ?? [];

  DisenarEncuestaState copyWith({
    List<Estilo>? estilosEncuesta,
    Encuesta? encuesta,
    String? valorPregunta,
    Map<String, String>? modeloSeleccionado,
    List<PreguntaOpciones>? preguntas,
  }) {
    return DisenarEncuestaState(
        encuesta: encuesta ?? this.encuesta,
        valorPregunta: valorPregunta ?? this.valorPregunta,
        estilosEncuesta: estilosEncuesta ?? this.estilosEncuesta,
        preguntas: preguntas ?? this.preguntas);
  }
}

class DisenarEncuestaNotifier extends StateNotifier<DisenarEncuestaState> {
  DisenarEncuestaNotifier(
      {required this.docenteRepository, required this.token})
      : super(DisenarEncuestaState());

  final DocenteRepositoryImpl docenteRepository;
  final String token;

  // PARA LA GESTION DE INFO DE ENCUESTA
  void setTitulo(String titulo) {
    state = state.copyWith(encuesta: state.encuesta?.copyWith(titulo: titulo));
  }

  void setAutor(String autor) {
    state = state.copyWith(encuesta: state.encuesta?.copyWith(autor: autor));
  }

  void setTipoEncuesta(String tipo) {
    final esCuantitativa = tipo == 'cuantitativo';
    state = state.copyWith(
      encuesta: state.encuesta?.copyWith(cuantitativa: esCuantitativa),
    );
  }

  void setDescripcion(String descripcion) {
    state = state.copyWith(
        encuesta: state.encuesta?.copyWith(descripcion: descripcion));
  }

  void setValorPregunta(String valor) {
    state = state.copyWith(valorPregunta: valor);
  }

  // PARA LA GESTION DE ESTILOS
  void agregarEstilo(String estilo) {
    final listaEstilos = [
      ...state.estilosEncuesta!,
      Estilo(encuestaId: 0, nombre: estilo, descripcion: '')
    ];
    state = state.copyWith(estilosEncuesta: listaEstilos);
  }

  void eliminarEstilo(String estiloNombre) {
    // Paso 1: Eliminar el estilo de la lista de estilos
    final listaEstilos = state.estilosEncuesta!
        .where((estilo) => estilo.nombre != estiloNombre)
        .toList();
    // Paso 2: Eliminar las opciones con el estilo eliminado
    final preguntasActualizadas = state.preguntas.map((pregunta) {
      final opcionesFiltradas = pregunta.opciones
          .where((opcion) => opcion.valorCualitativo != estiloNombre)
          .toList();
      return pregunta.copyWith(opciones: opcionesFiltradas);
    }).toList();
    // Actualizar el estado
    state = state.copyWith(
      estilosEncuesta: listaEstilos,
      preguntas: preguntasActualizadas,
    );
  }

  void setModeloSeleccionado(String modelo) {
    final nuevoModelo = {'modelo': modelo};
    state = state.copyWith(modeloSeleccionado: nuevoModelo);
  }

  //PARA LA GESTION DE PREGUNTAS Y OPCIONES
  void agregarPregunta(String enunciado) {
    final nuevaPregunta = Pregunta(
        encuestaId: 0,
        orden:
            state.preguntas.length + 1, // Incrementa automáticamente el orden.
        enunciado: enunciado,
        min: 1,
        max: 1,
        valorTotal: 0);
    state = state.copyWith(preguntas: [
      ...state.preguntas,
      PreguntaOpciones(pregunta: nuevaPregunta, opciones: [])
    ]);
  }

  void eliminarPregunta(int ordenPregunta) {
    final preguntasActualizadas = state.preguntas
        .where((preguntaOrden) => preguntaOrden.pregunta.orden != ordenPregunta)
        .toList();
    for (int i = 0; i < preguntasActualizadas.length; i++) {
      Pregunta pregunta =
          preguntasActualizadas[i].pregunta.copyWith(orden: i + 1);

      preguntasActualizadas[i] =
          preguntasActualizadas[i].copyWith(pregunta: pregunta);
    }
    state = state.copyWith(preguntas: preguntasActualizadas);
  }

  void actualizarPregunta({
    required int ordenPregunta,
    String? enunciado,
    double? valorTotal,
    String? tipoPregunta,
  }) {
    final preguntasActualizadas =
        state.preguntas.map((PreguntaOpciones pregunta) {
      if (pregunta.pregunta.orden == ordenPregunta) {
        // Creamos una nueva instancia de PreguntaOpciones actualizando la pregunta
        return pregunta.copyWith(
          pregunta: pregunta.pregunta.copyWith(
            enunciado: enunciado,
            valorTotal: valorTotal,
            tipoPregunta: tipoPregunta,
          ),
        );
      }
      return pregunta;
    }).toList();

    state = state.copyWith(preguntas: preguntasActualizadas);
  }

  void agregarOpcion({
    required int ordenPregunta,
    required Opcion nuevaOpcion,
  }) {
    final preguntasActualizadas =
        state.preguntas.map((PreguntaOpciones pregunta) {
      if (pregunta.pregunta.orden == ordenPregunta) {
        // Añadimos la nueva opción a la lista existente
        final opcionesActualizadas = [...pregunta.opciones, nuevaOpcion];
        return pregunta.copyWith(opciones: opcionesActualizadas);
      }
      return pregunta;
    }).toList();

    state = state.copyWith(preguntas: preguntasActualizadas);
  }

  void eliminarOpcion({
    required int ordenPregunta,
    required int idOpcion,
  }) {
    final preguntasActualizadas =
        state.preguntas.map((PreguntaOpciones pregunta) {
      if (pregunta.pregunta.orden == ordenPregunta) {
        // Filtramos las opciones para eliminar la opción con el id especificado
        final opcionesActualizadas =
            pregunta.opciones.where((opcion) => opcion.id != idOpcion).toList();
        return pregunta.copyWith(opciones: opcionesActualizadas);
      }
      return pregunta;
    }).toList();

    state = state.copyWith(preguntas: preguntasActualizadas);
  }

  void editarOpcion(
      {required int ordenPregunta,
      required int idOpcion,
      String? texto,
      String? valorCualitativo,
      double? valorCuantitativo,
      String? nombreEstilo}) {
    final preguntasActualizadas =
        state.preguntas.map((PreguntaOpciones pregunta) {
      if (pregunta.pregunta.orden == ordenPregunta) {
        // Actualizamos la opción específica
        final opcionesActualizadas = pregunta.opciones.map((Opcion opcion) {
          if (opcion.id == idOpcion) {
            return opcion.copyWith(
                texto: texto,
                valorCualitativo: valorCualitativo,
                valorCuantitativo: valorCuantitativo,
                nombreEstilo: nombreEstilo);
          }
          return opcion;
        }).toList();
        return pregunta.copyWith(opciones: opcionesActualizadas);
      }
      return pregunta;
    }).toList();

    state = state.copyWith(preguntas: preguntasActualizadas);
  }

  //PARA CREAR LA ENCUESTA EN LA BD
  Future<bool> crearEncuesta() async {
    try {
      // Para la encuesta
      final test =
          await docenteRepository.crearEncuesta(state.encuesta!, token);
      if (test == null) {
        throw Exception('No se pudo crear la encuesta: el resultado es null.');
      }
      state = state.copyWith(encuesta: test);

      // Para los estilos
      final estilosActualizados = <Estilo>[];
      for (final Estilo estilo in state.estilosEncuesta ?? []) {
        Estilo estWithId = estilo.copyWith(encuestaId: test.id);
        Estilo? estCreado =
            await docenteRepository.crearEstilo(estWithId, token);
        if (estCreado == null) {
          throw Exception('No se pudo crear el estilo: ${estilo.nombre}');
        }
        estilosActualizados.add(estCreado);
      }
      state = state.copyWith(estilosEncuesta: estilosActualizados);

      // Para las preguntas
      final preguntasOpcionesActualizados = <PreguntaOpciones>[];
      for (final PreguntaOpciones preguntaOpcion in state.preguntas) {
        Pregunta pregunta = preguntaOpcion.pregunta;
        Pregunta? preguntaAPI = await docenteRepository.crearPregunta(
            pregunta.copyWith(encuestaId: test.id), token);

        // Para las opciones
        final List<Opcion> opcionesActualizadas = [];
        for (final Opcion opcion in preguntaOpcion.opciones) {
          Estilo idEstilo = estilosActualizados.where((estAct) {
            return estAct.nombre == opcion.nombreEstilo;
          }).first;
          Opcion? opcionAPI = await docenteRepository.crearOpcion(
              opcion.copyWith(
                preguntaId: preguntaAPI!.id,
                estiloId: idEstilo.id,
              ),
              token);
          opcionesActualizadas
              .add(opcionAPI!.copyWith(nombreEstilo: opcion.nombreEstilo));
        }
        preguntasOpcionesActualizados.add(PreguntaOpciones(
            pregunta: preguntaAPI!, opciones: opcionesActualizadas));
      }
      state = state.copyWith(preguntas: preguntasOpcionesActualizados);
      limpiarEncuesta();
      return true; // Si todo salió bien
    } catch (e) {
      return false; // Si ocurrió un error
    }
  }

  void cargarDatosEncuesta(int idEncuesta) async {
    final EncuestaDetalles? encuestaActualizar =
        await docenteRepository.obtenerEncuestaDellates(token, idEncuesta);

    List<PreguntaOpciones> preguntasActualizadas = [];
    for (PreguntaOpciones pregunta in encuestaActualizar!.preguntas) {
      List<Opcion> opcionesActualizadas = [];
      for (Opcion opcion in pregunta.opciones) {
        for (Estilo estilo in encuestaActualizar.estilos) {
          if (estilo.id == opcion.estiloId) {
            opcionesActualizadas
                .add(opcion.copyWith(nombreEstilo: estilo.nombre));
          }
        }
      }
      preguntasActualizadas
          .add(pregunta.copyWith(opciones: opcionesActualizadas));
    }

    state = state.copyWith(
      encuesta: encuestaActualizar.encuesta,
      estilosEncuesta: encuestaActualizar.estilos,
      preguntas: preguntasActualizadas,
    );
  }

  // PARA REINICIAR EL ESTADO
  void limpiarEncuesta() {
    state = DisenarEncuestaState();
  }
}

final disenarEncuestaProvider =
    StateNotifierProvider<DisenarEncuestaNotifier, DisenarEncuestaState>((ref) {
  final session = ref.watch(sessionProvider);
  return DisenarEncuestaNotifier(
    docenteRepository: DocenteRepositoryImpl(),
    token: session.token,
  );
});
