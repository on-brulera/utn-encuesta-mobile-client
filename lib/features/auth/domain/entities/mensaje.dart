class Mensaje {
  final String text;
  final String? imageUrl;
  final FromWho fromWho;

  Mensaje({required this.text, this.imageUrl, required this.fromWho});

  factory Mensaje.fromJson(Map<String, dynamic> json ) => Mensaje(text: json['mensaje'], fromWho: FromWho.ia);
  factory Mensaje.fromJsonRespuesta(Map<String, dynamic> json) =>
      Mensaje(text: json['respuesta'], fromWho: FromWho.ia);
}

enum FromWho { me, ia }
enum UsuarioChat { estudiante, docente}
