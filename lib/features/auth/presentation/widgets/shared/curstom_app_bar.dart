import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CurstomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CurstomAppBar({
    super.key,
    this.height = kToolbarHeight,
    required this.titulo,
  });
  final double height;
  final String titulo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionNotifier = ref.read(sessionProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Scaffold(
          appBar: AppBar(
        title: Text(titulo),
        actions: [
          IconButton(
            onPressed: () async {
              sessionNotifier.logout();
              context.go('/${LoginScreen.screenName}');
            },
            icon: const Icon(
              Icons.exit_to_app,
              size: 30,
            ),
          ),
          const SizedBox(width: 20),
        ],
      )),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
