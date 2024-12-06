import 'package:encuestas_utn/features/auth/presentation/providers/estudiante/estudiante_asignaciones_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomButtonAnimate extends ConsumerStatefulWidget {
  final AnimationController controller;
  final String usuario;
  final String password;

  const CustomButtonAnimate({
    super.key,
    required this.controller,
    required this.usuario,
    required this.password,
  });

  @override
  createState() => _CustomButtonAnimateState();
}

class _CustomButtonAnimateState extends ConsumerState<CustomButtonAnimate> {
  late final Animation<double> largura;
  late final Animation<double> altura;
  late final Animation<double> radius;
  late final Animation<double> opacidade;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    largura = Tween<double>(begin: 0, end: 500).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.0, 0.5),
      ),
    );

    altura = Tween<double>(begin: 0, end: 50).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.5, 0.7),
      ),
    );

    radius = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.6, 1.0),
      ),
    );

    opacidade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.6, 0.8),
      ),
    );
  }

  Future<void> _handleTap(BuildContext context, WidgetRef ref) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final sessionNotifier = ref.read(sessionProvider.notifier);

      // Llamamos al método login del provider
      await sessionNotifier.login(widget.usuario, widget.password);

      // Verificamos el estado de la sesión después del login
      final sessionState = ref.read(sessionProvider);

      if (sessionState.token.isNotEmpty) {
        if (sessionState.user?.rol == 'EST') {
          final estudianteAsignacionNotifier =
              ref.read(estudianteAsignacionProvider.notifier);

          final estudianteAsignacionState =
              ref.read(estudianteAsignacionProvider);

          if (!estudianteAsignacionState.isLoaded &&
              !estudianteAsignacionState.isLoading) {
            await estudianteAsignacionNotifier.obtenerAsignacionesEncuestas();
          }

          final asignacionesCargadas =
              ref.read(estudianteAsignacionProvider).isLoaded;

          if (asignacionesCargadas) {
            if (context.mounted) {
              context.go('/${EstudianteMenuDScreen.screenName}');
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error al cargar los datos.')),
              );
            }
          }
        } else if (sessionState.user?.rol == 'ADM') {
          if (context.mounted) {
            context.go('/${AdminMenuScreen.screenName}');
          }
        } else if (sessionState.user?.rol == 'DOC') {
          if (context.mounted) {
            context.go('/${DocenteMenuDScreen.screenName}');
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rol de usuario inválido')),
            );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login fallido')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocurrió un error: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return InkWell(
          onTap: _isLoading ? null : () => _handleTap(context, ref),
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
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : FadeTransition(
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
      },
    );
  }
}
