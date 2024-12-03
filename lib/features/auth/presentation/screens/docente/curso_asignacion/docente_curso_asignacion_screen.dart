import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/docente/lista_asignacion_detalle_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/curso/custom_editar_notas_curso_box.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocenteCursoAsignacionScreen extends ConsumerWidget {
  static String screenName = 'docente_curso_asignacion_screen';
  const DocenteCursoAsignacionScreen({super.key});

  Future<void> _refreshData(WidgetRef ref) async {
    await ref
        .read(listaAsignacionDetalleProvider.notifier)
        .obtenerTodasLasAsignaciones();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asignacionState = ref.watch(listaAsignacionDetalleProvider);
    return FadeIn(
      duration: const Duration(milliseconds: 1200),
      child: Scaffold(
        appBar: const CurstomAppBar(titulo: 'Curso y Asignación'),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => _refreshData(ref),
            child: asignacionState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : asignacionState.error != null
                    ? Center(child: Text(asignacionState.error!))
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CustomCrearCursoBox(),
                              const CustomAsignarEncuestaCursoBox(),
                              const CustomEditarNotasCursoBox(),
                              AppSpaces.vertical15,
                              SizedBox(
                                width: double.infinity,
                                child: CustomCursoTable(
                                    asignaciones:
                                        asignacionState.asignaciones!),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
