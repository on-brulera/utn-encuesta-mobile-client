import 'package:encuestas_utn/features/auth/domain/entities/encuesta.dart';
import 'package:encuestas_utn/features/auth/domain/entities/estilo.dart';
import 'package:encuestas_utn/features/auth/infraestructure/repositories/docente_repository_impl.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class Opcion {
  final String id;
  final String texto;
  final String? estiloParametroSeleccionado; // Nuevo atributo

  Opcion({
    required this.id,
    required this.texto,
    this.estiloParametroSeleccionado,
  });

  // Método de copia para modificar la opción inmutablemente
  Opcion copyWith({String? texto, String? estiloParametroSeleccionado}) {
    return Opcion(
      id: id,
      texto: texto ?? this.texto,
      estiloParametroSeleccionado:
          estiloParametroSeleccionado ?? this.estiloParametroSeleccionado,
    );
  }
}

class Pregunta {
  final String id;
  final String texto;
  final List<Opcion> opciones;

  Pregunta({
    required this.id,
    required this.texto,
    required this.opciones,
  });

  // Método copyWith para actualizar las opciones o el texto sin modificar los demás atributos
  Pregunta copyWith({String? texto, List<Opcion>? opciones}) {
    return Pregunta(
      id: id,
      texto: texto ?? this.texto,
      opciones: opciones ?? this.opciones,
    );
  }
}

class Regla {
  final String id;
  final String? estiloSeleccionado;
  final String? operacionSeleccionada;
  final String? comparacionSeleccionada;
  final String? cantidadResultado;
  final List<String> parametrosDelEstilo = [];

  Regla({
    required this.id,
    this.estiloSeleccionado,
    this.operacionSeleccionada,
    this.comparacionSeleccionada,
    this.cantidadResultado,    
  });

  void agregarParametro(String parametro){
    parametrosDelEstilo.add(parametro);
  }
}

// Estado que mantiene la información de la encuesta
class DisenarEncuestaState {
  final List<Pregunta> preguntas;
  final String? titulo;
  final String? autor;
  final String tipoEncuesta;
  final String? descripcion;
  final String? valorPregunta;
  final List<Regla> reglas;
  final List<String> estilos;
  final List<String> parametros;

  DisenarEncuestaState({
    this.titulo,
    this.autor,
    this.tipoEncuesta = 'cualitativo',
    this.descripcion,
    this.valorPregunta,
    this.preguntas = const [],
    this.reglas = const [],
    List<String>? estilos,
    List<String>? parametros,
  })  : estilos = estilos ?? [],
        parametros = parametros ?? [];

  DisenarEncuestaState copyWith(
      {List<Regla>? reglas,
      String? titulo,
      String? autor,
      String? tipoEncuesta,
      String? descripcion,
      String? valorPregunta,
      List<String>? estilos,
      List<String>? parametros,
      List<Pregunta>? preguntas}) {
    return DisenarEncuestaState(
      titulo: titulo ?? this.titulo,
      autor: autor ?? this.autor,
      tipoEncuesta: tipoEncuesta ?? this.tipoEncuesta,
      descripcion: descripcion ?? this.descripcion,
      valorPregunta: valorPregunta ?? this.valorPregunta,
      reglas: reglas ?? this.reglas,
      estilos: estilos ?? this.estilos,
      parametros: parametros ?? this.parametros,
      preguntas: preguntas ?? this.preguntas,
    );
  }
}

// Notificador que maneja las acciones del estado de diseño de encuesta
class DisenarEncuestaNotifier extends StateNotifier<DisenarEncuestaState> {
  DisenarEncuestaNotifier(
      {required this.docenteRepository, required this.token})
      : super(DisenarEncuestaState());

  final DocenteRepositoryImpl docenteRepository;
  final String token;

  // Función para actualizar el título de la encuesta
  void setTitulo(String titulo) {
    state = state.copyWith(titulo: titulo);
  }

  // Función para actualizar el autor de la encuesta
  void setAutor(String autor) {
    state = state.copyWith(autor: autor);
  }

  // Función para actualizar el tipo de encuesta
  void setTipoEncuesta(String tipo) {
    state = state.copyWith(tipoEncuesta: tipo);
  }

  // Función para actualizar la descripción de la encuesta
  void setDescripcion(String descripcion) {
    state = state.copyWith(descripcion: descripcion);
  }

  // Función para actualizar el valor de la pregunta
  void setValorPregunta(String valor) {
    state = state.copyWith(valorPregunta: valor);
  }

  // Función para agregar un nuevo estilo
  void agregarEstilo(String estilo) {
    final nuevosEstilos = [...state.estilos, estilo];
    state = state.copyWith(estilos: nuevosEstilos);
  }

  // Función para eliminar un estilo
  void eliminarEstilo(String estilo) {
    final nuevosEstilos = state.estilos.where((e) => e != estilo).toList();
    state = state.copyWith(estilos: nuevosEstilos);
  }

  // Función para agregar un nuevo parámetro
  void agregarParametro(String parametro) {
    final nuevosParametros = [...state.parametros, parametro];
    state = state.copyWith(parametros: nuevosParametros);
  }

  // Función para eliminar un parámetro
  void eliminarParametro(String parametro) {
    final nuevosParametros =
        state.parametros.where((p) => p != parametro).toList();
    state = state.copyWith(parametros: nuevosParametros);
  }

  // Función para limpiar toda la información
  void limpiarEncuesta() {
    state = DisenarEncuestaState();
  }

  void modificarEstilo(int index, String nuevoEstilo) {
    final nuevosEstilos = [...state.estilos];
    nuevosEstilos[index] = nuevoEstilo;
    state = state.copyWith(estilos: nuevosEstilos);
  }

  void modificarParametro(int index, String nuevoParametro) {
    final nuevosParametros = [...state.parametros];
    nuevosParametros[index] = nuevoParametro;
    state = state.copyWith(parametros: nuevosParametros);
  }

  //Gestionar Reglas
  void agregarRegla() {
    final nuevaRegla = Regla(id: UniqueKey().toString());
    state = state.copyWith(reglas: [...state.reglas, nuevaRegla]);
  }

  void eliminarRegla(String reglaId) {
    final nuevasReglas = state.reglas.where((r) => r.id != reglaId).toList();
    state = state.copyWith(reglas: nuevasReglas);
  }

  void actualizarReglaEstilo(String reglaId, String? estilo) {
    final nuevasReglas = state.reglas.map((regla) {
      if (regla.id == reglaId) {
        return Regla(id: regla.id, estiloSeleccionado: estilo);
      }
      return regla;
    }).toList();
    state = state.copyWith(reglas: nuevasReglas);
  }

  void actualizarParametroReglaEstilo(String reglaId, String? parametro) {
    final nuevasReglas = state.reglas.map((regla) {
      if (regla.id == reglaId) {
        regla.parametrosDelEstilo.add(parametro!);
      }
      return regla;
    }).toList();
    state = state.copyWith(reglas: nuevasReglas);
  }

  //Para gestión de los signos de parametros
  void actualizarReglaOperacion(String reglaId, String? operacion) {
    final nuevasReglas = state.reglas.map((regla) {
      if (regla.id == reglaId) {
        return Regla(
          id: regla.id,
          estiloSeleccionado: regla.estiloSeleccionado,
          operacionSeleccionada: operacion,
        );
      }
      return regla;
    }).toList();
    state = state.copyWith(reglas: nuevasReglas);
  }

  // Actualiza el operador de comparación en la regla específica
  void actualizarComparacion(String reglaId, String? comparacion) {
    final nuevasReglas = state.reglas.map((regla) {
      if (regla.id == reglaId) {
        return Regla(
          id: regla.id,
          estiloSeleccionado: regla.estiloSeleccionado,
          operacionSeleccionada: regla.operacionSeleccionada,
          comparacionSeleccionada: comparacion,
          cantidadResultado: regla.cantidadResultado,
        );
      }
      return regla;
    }).toList();
    state = state.copyWith(reglas: nuevasReglas);
  }

  // Actualiza la cantidad resultado en la regla específica
  void actualizarCantidadResultado(String reglaId, String cantidad) {
    final nuevasReglas = state.reglas.map((regla) {
      if (regla.id == reglaId) {
        return Regla(
          id: regla.id,
          estiloSeleccionado: regla.estiloSeleccionado,
          operacionSeleccionada: regla.operacionSeleccionada,
          comparacionSeleccionada: regla.comparacionSeleccionada,
          cantidadResultado: cantidad,
        );
      }
      return regla;
    }).toList();
    state = state.copyWith(reglas: nuevasReglas);
  }

  //Para las preguntas y opciones
  void agregarPregunta() {
    final nuevaPregunta =
        Pregunta(id: UniqueKey().toString(), texto: '', opciones: []);
    state = state.copyWith(preguntas: [...state.preguntas, nuevaPregunta]);
  }

  void eliminarPregunta(String preguntaId) {
    final preguntasActualizadas =
        state.preguntas.where((p) => p.id != preguntaId).toList();
    state = state.copyWith(preguntas: preguntasActualizadas);
  }

  void actualizarTextoPregunta(String preguntaId, String texto) {
    final preguntasActualizadas = state.preguntas.map((pregunta) {
      if (pregunta.id == preguntaId) {
        return Pregunta(
            id: pregunta.id, texto: texto, opciones: pregunta.opciones);
      }
      return pregunta;
    }).toList();
    state = state.copyWith(preguntas: preguntasActualizadas);
  }

  void agregarOpcion(String preguntaId) {
    final preguntasActualizadas = state.preguntas.map((pregunta) {
      if (pregunta.id == preguntaId) {
        final nuevaOpcion = Opcion(id: UniqueKey().toString(), texto: '');
        return Pregunta(
            id: pregunta.id,
            texto: pregunta.texto,
            opciones: [...pregunta.opciones, nuevaOpcion]);
      }
      return pregunta;
    }).toList();
    state = state.copyWith(preguntas: preguntasActualizadas);
  }

  void eliminarOpcion(String preguntaId, String opcionId) {
    final preguntasActualizadas = state.preguntas.map((pregunta) {
      if (pregunta.id == preguntaId) {
        final opcionesActualizadas =
            pregunta.opciones.where((opcion) => opcion.id != opcionId).toList();
        return Pregunta(
            id: pregunta.id,
            texto: pregunta.texto,
            opciones: opcionesActualizadas);
      }
      return pregunta;
    }).toList();
    state = state.copyWith(preguntas: preguntasActualizadas);
  }

  void actualizarTextoOpcion(String preguntaId, String opcionId, String texto) {
    final preguntasActualizadas = state.preguntas.map((pregunta) {
      if (pregunta.id == preguntaId) {
        final opcionesActualizadas = pregunta.opciones.map((opcion) {
          if (opcion.id == opcionId) {
            return Opcion(id: opcion.id, texto: texto);
          }
          return opcion;
        }).toList();
        return Pregunta(
            id: pregunta.id,
            texto: pregunta.texto,
            opciones: opcionesActualizadas);
      }
      return pregunta;
    }).toList();
    state = state.copyWith(preguntas: preguntasActualizadas);
  }

  void actualizarOpcionSeleccionada(
      String preguntaId, String opcionId, String? valor) {
    // Actualiza el estilo o parámetro seleccionado en la opción específica
    final nuevasPreguntas = state.preguntas.map((pregunta) {
      if (pregunta.id == preguntaId) {
        final nuevasOpciones = pregunta.opciones.map((opcion) {
          if (opcion.id == opcionId) {
            // Crea una copia de la opción con el valor actualizado
            return opcion.copyWith(estiloParametroSeleccionado: valor);
          }
          return opcion;
        }).toList();

        // Retorna una nueva pregunta con las opciones actualizadas
        return pregunta.copyWith(opciones: nuevasOpciones);
      }
      return pregunta;
    }).toList();

    // Actualiza el estado con la lista de preguntas modificada
    state = state.copyWith(preguntas: nuevasPreguntas);
  }

  //PARA CREAR LA ENCUESTA EN LA BD

  Future<void> crearEncuesta() async {
    // Crea la encuesta a partir del estado actual del provider
    final encuesta = Encuesta(
      id: 0, // id puede ser opcional o nulo si no está creado aún
      titulo: state.titulo ?? '',
      descripcion: state.descripcion ?? '',
      autor: state.autor ?? '',
      cuantitativa: state.tipoEncuesta == 'cuantitativo',
      fechaCreacion: DateTime.now(),
    );

    final nuevaEncuesta =
        await docenteRepository.crearEncuesta(encuesta, token);
    if (nuevaEncuesta != null) {
      // Procesa la respuesta o actualiza el estado si es necesario
      print('Encuesta creada exitosamente: ${nuevaEncuesta.titulo}');
    } else {
      print('Error al crear la encuesta');
    }
    

  }

}

// Provider global para el diseño de la encuesta
final disenarEncuestaProvider =
    StateNotifierProvider<DisenarEncuestaNotifier, DisenarEncuestaState>((ref) {
  final session = ref.watch(sessionProvider);
  return DisenarEncuestaNotifier(
    docenteRepository: DocenteRepositoryImpl(),
    token: session.token,
  );
});
