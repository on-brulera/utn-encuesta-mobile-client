import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/home/custom_menu_opcion_card_full_width.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/configuration/const/menu_opcion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminMenuScreen extends ConsumerWidget {
  static String screenName = 'menuadminscreen';
  const AdminMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Configuración de las callbacks para las opciones
    opcionesMenuAdmin[0].callback =
        () => context.pushNamed(AdminDocenteScreen.screenName);
    opcionesMenuAdmin[1].callback =
        () => context.pushNamed(AdminEstudianteteScreen.screenName);
    opcionesMenuAdmin[2].callback =
        () => context.pushNamed(AdminPerfilScreen.screenName);

    return Scaffold(
      appBar: const CurstomAppBar(titulo: 'Módulos'),
      body: SafeArea(
        child: FadeIn(
          duration: const Duration(seconds: 2),
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: opcionesMenuAdmin.length,
            itemBuilder: (context, index) {
              final opcion = opcionesMenuAdmin[index];
              return CustomMenuOpcionCardFullWidth(opcion: opcion);
            },
          ),
        ),
      ),
    );
  }
}
