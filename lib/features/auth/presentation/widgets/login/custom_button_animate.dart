import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomButtonAnimate extends ConsumerWidget {
  final AnimationController controller;
  final Animation<double> largura;
  final Animation<double> altura;
  final Animation<double> radius;
  final Animation<double> opacidade;
  final String usuario;
  final String password;

  CustomButtonAnimate({
    super.key,
    required this.controller,
    required this.usuario,
    required this.password,
  })  : largura = Tween<double>(
          begin: 0,
          end: 500,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.5),
          ),
        ),
        altura = Tween<double>(
          begin: 0,
          end: 50,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.5, 0.7),
          ),
        ),
        radius = Tween<double>(
          begin: 0,
          end: 20,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.6, 1.0),
          ),
        ),
        opacidade = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.6, 0.8),
          ),
        );

  Widget _buildAnimation(BuildContext context, WidgetRef ref, Widget? widget) {
    return InkWell(
      onTap: () async {
        final sessionNotifier = ref.read(sessionProvider.notifier);

        // Llamamos al método login del provider
        await sessionNotifier.login(usuario, password);

        // Verificamos el estado de la sesión después del login
        final sessionState = ref.read(sessionProvider);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (sessionState.token.isNotEmpty) {
            // Redirige según el rol del usuario en sessionState
            if (sessionState.user?.rol == 'EST') {
              context.go('/${EstudianteMenuDScreen.screenName}');
            } else if (sessionState.user?.rol == 'DOC') {
              context.go('/${DocenteMenuDScreen.screenName}');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rol de usuario inválido')),
              );
            }
          } else {
            // Mostrar error si el login falla
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login fallido')),
            );
          }
        });
      },
      child: Container(
        width: largura.value,
        height: altura.value,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius.value),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(223, 20, 54, 1),
              Color.fromRGBO(239, 93, 117, 1),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: opacidade,
            child: const Text(
              "Entrar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, widget) => _buildAnimation(context, ref, widget),
    );
  }
}
