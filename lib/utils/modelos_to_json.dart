import 'package:encuestas_utn/features/auth/domain/entities/entities.dart';

//PARA EL MODELO 1

Map<String, dynamic> generarReglasJsonModelo1({
  required List<PreguntaOpciones> preguntasConOpciones,
}) {
  // Construimos las reglas para cada pregunta
  final reglas = preguntasConOpciones.expand((preguntaOpciones) {
    // Recorremos las opciones de cada pregunta
    return preguntaOpciones.opciones.map((opcion) {
      return {
        "estilo": opcion.nombreEstilo,
        "pregunta": preguntaOpciones.pregunta.orden,
        "opciones": [opcion.valorCualitativo],
      };
    });
  }).toList();

  return {
    "Modelo": "Modelo1",
    "reglas_json": reglas,
  };
}

List<Map<String, dynamic>> generarRespuestasModelo1Jso1n({
  required List<PreguntaOpciones> preguntasConOpciones,
}) {
  // Construimos la lista de respuestas
  final respuestas = preguntasConOpciones.expand((preguntaOpciones) {
    return preguntaOpciones.opciones.map((opcion) {
      return {
        "pregunta": preguntaOpciones.pregunta.orden,
        "opcion": {
          "valor_cualitativo": opcion.valorCualitativo,
          "valor_cuantitativo": opcion.valorCuantitativo,
        },
      };
    });
  }).toList();

  return respuestas;
}

//PARA EL MODELO 2
Map<String, dynamic> generarReglasDinamicasJsonModelo2({
  required List<PreguntaOpciones> preguntasConOpciones,
}) {
  // Mapeamos los estilos a las preguntas asociadas dinámicamente
  final Map<String, List<int>> estilosMap = {};

  // Recorremos cada PreguntaOpciones
  for (var preguntaOpciones in preguntasConOpciones) {
    // Recorremos las opciones de cada pregunta
    for (var opcion in preguntaOpciones.opciones) {
      // Agregamos el estilo al mapa si no existe
      if (!estilosMap.containsKey(opcion.nombreEstilo)) {
        estilosMap[opcion.nombreEstilo] = [];
      }
      // Agregamos el número de la pregunta al estilo correspondiente
      if (!estilosMap[opcion.nombreEstilo]!
          .contains(preguntaOpciones.pregunta.orden)) {
        estilosMap[opcion.nombreEstilo]!.add(preguntaOpciones.pregunta.orden);
      }
    }
  }
  // Convertimos el mapa en la estructura JSON deseada
  final reglas = estilosMap.entries.map((entrada) {
    return {
      "estilo": entrada.key,
      "preguntas": entrada.value,
    };
  }).toList();

  return {
    "Modelo": "Modelo2",
    "reglas_json": reglas,
  };
}

List<Map<String, dynamic>> generarRespuestasModelo2Json({
  required List<PreguntaOpciones> preguntasConOpciones,
}) {
  // Construimos la lista de respuestas
  final respuestas = preguntasConOpciones.expand((preguntaOpciones) {
    return preguntaOpciones.opciones.map((opcion) {
      return {
        "pregunta": preguntaOpciones.pregunta.orden,
        "respuesta": opcion.texto, // puede ser "Verdadero" o "Falso"
      };
    });
  }).toList();

  return respuestas;
}

//PARA EL MODELO 3

Map<String, dynamic> generarReglasDinamicasJsonModelo3({
  required List<PreguntaOpciones> preguntasConOpciones,
}) {
  // Mapeamos los estilos a las preguntas asociadas dinámicamente
  final Map<String, List<int>> estilosMap = {};

  // Recorremos cada PreguntaOpciones
  for (var preguntaOpciones in preguntasConOpciones) {
    // Recorremos las opciones de cada pregunta
    for (var opcion in preguntaOpciones.opciones) {
      // Agregamos el estilo al mapa si no existe
      if (!estilosMap.containsKey(opcion.nombreEstilo)) {
        estilosMap[opcion.nombreEstilo] = [];
      }
      // Agregamos el número de la pregunta al estilo correspondiente
      if (!estilosMap[opcion.nombreEstilo]!
          .contains(preguntaOpciones.pregunta.orden)) {
        estilosMap[opcion.nombreEstilo]!.add(preguntaOpciones.pregunta.orden);
      }
    }
  }

  // Convertimos el mapa en la estructura JSON deseada
  final reglas = estilosMap.entries.map((entrada) {
    return {
      "estilo": entrada.key,
      "preguntas": entrada.value,
    };
  }).toList();

  return {
    "Modelo": "Modelo3",
    "reglas_json": reglas,
  };
}

List<Map<String, dynamic>> generarRespuestasModelo3Json({
  required List<PreguntaOpciones> preguntasConOpciones,
}) {
  // Construimos la lista de respuestas
  final respuestas = preguntasConOpciones.expand((preguntaOpciones) {
    return preguntaOpciones.opciones.map((opcion) {
      return {
        "pregunta": preguntaOpciones.pregunta.orden,
        "respuesta": opcion.valorCualitativo, // el cual va ser "A" o "B"
      };
    });
  }).toList();

  return respuestas;
}
