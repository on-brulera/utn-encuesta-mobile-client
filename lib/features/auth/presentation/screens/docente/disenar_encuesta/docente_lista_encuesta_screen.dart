import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_encuesta_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocenteListaEncuestaScreen extends ConsumerWidget {
  static const String screenName = 'docente_lista_encuesta_screen';
  const DocenteListaEncuestaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listaEncuestaState = ref.watch(listaEncuestaProvider);
    final listaEncuestaNotifier = ref.read(listaEncuestaProvider.notifier);

    // Cargar encuestas si aún no se han cargado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listaEncuestaState.encuestas.isEmpty &&
          !listaEncuestaState.isLoading) {
        listaEncuestaNotifier.obtenerTodasLasEncuestas();
      }
    });

    return FadeIn(
      duration: const Duration(milliseconds: 1300),
      child: Scaffold(
        appBar: const CurstomAppBar(titulo: 'Encuestas'),
        body: SafeArea(
          child: listaEncuestaState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : listaEncuestaState.error != null
                  ? Center(
                      child: Text(
                        listaEncuestaState.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        // Llamar al método para volver a cargar las encuestas
                        await listaEncuestaNotifier.obtenerTodasLasEncuestas();
                        if (context.mounted) {
                          // Mostrar el SnackBar solo si el contexto aún es válido
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Encuestas actualizadas')),
                          );
                        }
                      },
                      child: ListView.builder(
                        itemCount: listaEncuestaState.encuestas.length,
                        itemBuilder: (context, index) {
                          final encuesta = listaEncuestaState.encuestas[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: CustomEncuestaItemList(encuesta: encuesta),
                          );
                        },
                      ),
                    ),
        ),
      ),
    );
  }
}
