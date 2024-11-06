class Mensaje {
  final String text;
  final String? imageUrl;
  final FromWho fromWho;

  Mensaje({required this.text, this.imageUrl, required this.fromWho});
}

enum FromWho { me, ia }
enum UsuarioChat { estudiante, docente}
