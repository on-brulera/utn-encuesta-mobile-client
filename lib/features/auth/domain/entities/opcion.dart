class Opcion {
  final int id;
  final int preguntaId;
  final int estiloId;
  final String texto;
  final String valorCualitativo;
  final double valorCuantitativo;  
  final String nombreEstilo;

  Opcion(
      {this.id = 0,
      required this.preguntaId,
      required this.estiloId,
      required this.texto,
      required this.valorCualitativo,
      this.valorCuantitativo = 0,      
      this.nombreEstilo = 'Sin estilo'});

  Opcion copyWith({
    int? id,
    int? preguntaId,
    int? estiloId,
    String? texto,
    String? valorCualitativo,
    double? valorCuantitativo,
    String? nombreEstilo,
  }) =>
      Opcion(
          id: id ?? this.id,
          preguntaId: preguntaId ?? this.preguntaId,
          estiloId: estiloId ?? this.estiloId,
          texto: texto ?? this.texto,
          valorCuantitativo: valorCuantitativo ?? this.valorCuantitativo,
          valorCualitativo: valorCualitativo ?? this.valorCualitativo,          
          nombreEstilo: nombreEstilo??this.nombreEstilo);
}
