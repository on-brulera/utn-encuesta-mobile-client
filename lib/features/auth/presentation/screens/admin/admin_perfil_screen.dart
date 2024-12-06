import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/session_provider.dart';

import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminPerfilScreen extends ConsumerStatefulWidget {
  static String screenName = 'admin_perfil_screen';
  const AdminPerfilScreen({super.key});

  @override
  ConsumerState<AdminPerfilScreen> createState() =>
      _AdminPerfilScreenState();
}

class _AdminPerfilScreenState
    extends ConsumerState<AdminPerfilScreen> {
  bool isEditing = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? errorText;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _savePassword(BuildContext context) async {
    final session = ref.read(sessionProvider);
    final user = session.user;
    final token = session.token;

    if (user == null || token.isEmpty) {
      return;
    }

    final newPassword = _passwordController.text;
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await _showConfirmationDialog(context);
    if (confirmed ?? false) {
      final updatedUser = user.copyWith(password: newPassword);

      final response = await ref
          .read(sessionProvider.notifier)
          .authRepository
          .cambiarPassword(updatedUser, token);

      if (response != null) {
        messenger.showSnackBar(
            const SnackBar(content: Text('Contraseña actualizada con éxito')));
        setState(() {
          isEditing = false;
          _passwordController.clear();
          _confirmPasswordController.clear();
        });
      } else {
        messenger.showSnackBar(const SnackBar(
            content: Text('Por favor complete todos los campos')));
      }
    }
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar cambio de contraseña'),
        content: const Text('¿Está seguro de que desea cambiar su contraseña?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final session = ref.watch(sessionProvider);
    return FadeIn(
      duration: const Duration(milliseconds: 1250),
      child: Scaffold(
        appBar: const CurstomAppBar(titulo: 'Perfil'),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                  child: CustomImagenPerfil(),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Column(
                    children: [
                      AppSpaces.vertical20,
                      AppTexts.title('Admin'),
                      AppSpaces.vertical15,
                      AppTexts.textNotification(
                          'Gestiona las cuentas de docentes y estudiantes'),
                      AppSpaces.vertical15,
                      AppTexts.perfilText(
                        session.user?.usuario ?? 'Usuario no disponible',
                      ),
                      AppSpaces.vertical15,
                      Center(
                        child: isEditing
                            ? Column(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: _passwordController,
                                      decoration: const InputDecoration(
                                        labelText: 'Nueva contraseña',
                                      ),
                                      obscureText: true,
                                    ),
                                  ),
                                  AppSpaces.vertical10,
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: _confirmPasswordController,
                                      decoration: const InputDecoration(
                                        labelText: 'Confirmar contraseña',
                                      ),
                                      obscureText: true,
                                    ),
                                  ),
                                  if (errorText != null)
                                    Text(
                                      errorText!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                ],
                              )
                            : AppTexts.perfilText('*******************'),
                      ),
                      AppSpaces.vertical15,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton.extended(
                            onPressed: () {
                              if (isEditing) {
                                final newPassword = _passwordController.text;
                                final confirmPassword =
                                    _confirmPasswordController.text;

                                if (newPassword.length < 8) {
                                  setState(() {
                                    errorText =
                                        'La contraseña debe tener al menos 8 caracteres';
                                  });
                                  return;
                                }

                                if (newPassword != confirmPassword) {
                                  setState(() {
                                    errorText = 'Las contraseñas no coinciden';
                                  });
                                  return;
                                }

                                setState(() {
                                  errorText = null;
                                });
                                _savePassword(context);
                              } else {
                                setState(() {
                                  isEditing = true;
                                });
                              }
                            },
                            elevation: 0,
                            backgroundColor: Colors.redAccent,
                            label: Text(isEditing ? "Guardar" : "Editar"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
