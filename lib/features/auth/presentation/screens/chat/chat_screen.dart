import 'package:animate_do/animate_do.dart';
import 'package:encuestas_utn/features/auth/domain/entities/mensaje.dart';
import 'package:encuestas_utn/features/auth/presentation/screens/screens.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatelessWidget {
  static String screenName = 'chat_screen';
  final UsuarioChat usuarioChat;
  const ChatScreen({super.key, required this.usuarioChat});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(seconds: 1),
      child: Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsetsDirectional.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(AppAssets.capibara),
            ),
          ),
          title: const Text('IA Estilos'),
          actions: [
            IconButton.outlined(
                onPressed: () {
                  usuarioChat == UsuarioChat.docente
                      ? context.go('/${DocenteMenuDScreen.screenName}')
                      : context.go('/${EstudianteMenuDScreen.screenName}');
                },
                icon: const Icon(Icons.exit_to_app_rounded)),
            AppSpaces.horizontal20,
          ],
        ),
        body: const _ChatView(),
      ),
    );
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView();

  @override
  Widget build(BuildContext context) {
    // final chatProvider = context.watch<ChatProvider>();
    final controller = ScrollController();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: mensajes.length,
                itemBuilder: (context, index) {
                  final message = mensajes[index];
                  return (message.fromWho == FromWho.ia)
                      ? CustomIaMessage(
                          text: message.text,
                          imageUrl: message.imageUrl!,
                        )
                      : CustomPersonMessage(text: message.text);
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            CustomMessageFieldBox(
              onValue: (value) {},
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}

List<Mensaje> mensajes = [
  Mensaje(text: 'Hola', fromWho: FromWho.me),
  Mensaje(
      text: 'Hola',
      fromWho: FromWho.ia,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-Od1FAc4hmXyHOMp85szJyo6udEu0_aL_cQ&s'),
  Mensaje(text: '¿Cuales son los estilos de aprendizaje?', fromWho: FromWho.me),
  Mensaje(
      text: 'No sé',
      fromWho: FromWho.ia,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6CFqKdwe5m3AHcQBfrRWw3Fye-EajVoE0wpjpl1PdpZ7o1AEQ2I-BDe4VbJDxBk-hQZw&usqp=CAU'),
];
