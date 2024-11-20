class CredencialesApi {
  final int id;
  final String nombreServicio;
  final String apiKey;
  final DateTime fechaCreacion = DateTime.now();

  CredencialesApi({
    this.id = 0,
    required this.nombreServicio,
    required this.apiKey,
  });

  CredencialesApi copyWith({
    int? id,
    String? nombreServicio,
    String? apiKey,
    DateTime? fechaCreacion,
  }) =>
      CredencialesApi(
        id: id ?? this.id,
        nombreServicio: nombreServicio ?? this.nombreServicio,
        apiKey: apiKey ?? this.apiKey,
      );
}
