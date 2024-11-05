import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/presentation/screens/screens.dart';
import 'package:encuestas_utn/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DocentePerfilScreen extends StatefulWidget {
  static String screenName = 'docente_perfil_screen';
  const DocentePerfilScreen({super.key});

  @override
  State<DocentePerfilScreen> createState() => _DocentePerfilScreenState();
}

class _DocentePerfilScreenState extends State<DocentePerfilScreen> {
  bool isEditing = false;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 1250),
      child: Scaffold(
        appBar: AppBar(
          title: AppTexts.title('Perfil'),
          actions: [
            IconButton.outlined(
              onPressed: () => context.go('/${DocenteMenuDScreen.screenName}'),
              icon: const Icon(Icons.exit_to_app_rounded),
            ),
            AppSpaces.horizontal20,
          ],
        ),
        body: Column(
          children: [
            const Expanded(flex: 2, child: CustomImagenPerfil()),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Column(
                  children: [
                    AppSpaces.vertical20,
                    AppTexts.title('Docente'),
                    AppSpaces.vertical15,
                    AppTexts.textNotification(
                        'Diseña Encuestas y Analiza Resultados'),
                    AppSpaces.vertical15,
                    AppTexts.perfilText('D1002004003'),
                    AppSpaces.vertical15,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isEditing
                            ? SizedBox(
                                width: 200, // Limita el ancho a 200
                                child: TextField(
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nueva contraseña',
                                  ),
                                  obscureText: true,
                                ),
                              )
                            : AppTexts.perfilText('*******************'),
                      ],
                    ),
                    AppSpaces.vertical15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 5),
                        FloatingActionButton.extended(
                          onPressed: () {
                            setState(() {
                              isEditing = !isEditing;
                            });
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
            )
          ],
        ),
      ),
    );
  }
}
