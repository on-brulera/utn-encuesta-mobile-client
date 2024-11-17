import 'package:encuestas_utn/features/auth/domain/entities/encuesta.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/disenar_encuesta_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_encuesta_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/docente/disenar_encuesta/docente_disenar_encuesta_screen.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/docente/disenar_encuesta/docente_encuesta_detalles_screen.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CustomEncuestaItemList extends ConsumerWidget {
  final Encuesta encuesta;

  const CustomEncuestaItemList({
    super.key,
    required this.encuesta,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      child: _buildItemContainer(context, ref),
    );
  }

  void _navigateToDetails(BuildContext context) {
    context.pushNamed(
      DocenteEncuestaDetallesScreen.screenName,
      pathParameters: {'idEncuesta': encuesta.id.toString()},
    );
  }

  void _navigateToDisenarEncuesta(
      BuildContext context, WidgetRef ref, int encuestaId) async {
    // Invoca la función cargarDatosEncuesta antes de navegar
    ref.read(disenarEncuestaProvider.notifier).cargarDatosEncuesta(encuestaId);

    // Realiza la navegación
    context.go('/${DocenteDisenarEncuestaScreen.screenName}');
  }

  Widget _buildItemContainer(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: _buildBoxDecoration(),
      child: Row(
        children: [
          const SizedBox(width: 15),
          Expanded(child: _buildEncuestaInfo()),
          const SizedBox(width: 10),
          const SizedBox(
            height: 100, // Definir una altura explícita para el divisor
            child: VerticalDivider(
              color: Color.fromARGB(255, 244, 103, 103),
              thickness: 0.7, // Grosor razonable
            ),
          ),
          const SizedBox(width: 1),
          _buildButtons(context, ref),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  Widget _buildEncuestaInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTexts.textNotification(encuesta.titulo),
        AppSpaces.vertical5,
        AppTexts.softText(encuesta.autor),
        AppSpaces.vertical5,
        AppTexts.numberNotification(encuesta.descripcion),
        AppSpaces.vertical5,
        AppTexts.numberNotification(
          'Creada el ${DateFormat('dd-MM-yyyy').format(encuesta.fechaCreacion.toLocal())}',
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CustomButtonEncuestaLista(
          title: 'editar',
          callback: () => _navigateToDisenarEncuesta(context, ref, encuesta.id),
        ),
        AppSpaces.vertical5,
        CustomButtonEncuestaLista(
          title: 'asignar',
          callback: () {
            // Lógica futura
          },
        ),
        AppSpaces.vertical5,
        CustomButtonEncuestaLista(
          title: 'eliminar',
          callback: () => _confirmDelete(context, ref),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await _showDeleteDialog(context);

    if (confirm ?? false) {
      // Verificar si el contexto sigue montado antes de continuar
      if (context.mounted) {
        await _deleteEncuesta(context, ref);
      }
    }
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Encuesta'),
        content:
            const Text('¿Estás seguro de que deseas eliminar esta encuesta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteEncuesta(BuildContext context, WidgetRef ref) async {
    final listaEncuestaNotifier = ref.read(listaEncuestaProvider.notifier);

    final bool? success =
        await listaEncuestaNotifier.borrarEncuestaDetallesConId(encuesta.id);

    if (success == true) {
      await listaEncuestaNotifier.obtenerTodasLasEncuestas();

      // Verificar si el contexto sigue montado antes de usarlo
      if (context.mounted) {
        _showSnackBar(
          context,
          'Encuesta eliminada exitosamente',
          Colors.green,
        );
      }
    } else {
      // Verificar si el contexto sigue montado antes de usarlo
      if (context.mounted) {
        _showSnackBar(
          context,
          'Error al eliminar la encuesta',
          Colors.red,
        );
      }
    }
  }

  void _showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
        ),
      );
    }
  }
}
