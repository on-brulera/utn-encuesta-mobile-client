import 'package:encuestas_utn/features/auth/domain/entities/mensaje.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/shared/mensaje_provider.dart';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static String screenName = 'chat_screen';
  final UsuarioChat usuarioChat;

  const ChatScreen({super.key, required this.usuarioChat});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mensajes = ref.watch(mensajeProvider); // Observar mensajes
    final mensajeNotifier = ref.read(mensajeProvider.notifier);

    // Escuchar cambios en los mensajes y desplazarse al final
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Scaffold(
      appBar: const CurstomAppBar(titulo: 'IA Estilos',),
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
          children: [
            Expanded(
              child: NotificationListener<SizeChangedLayoutNotification>(
                onNotification: (notification) {
                  _scrollToBottom();
                  return true;
                },
                child: SizeChangedLayoutNotifier(
                  child: ListView.builder(
                    controller:
                        _scrollController, // Asignar el ScrollController
                    itemCount: mensajes.length,
                    itemBuilder: (context, index) {
                      final message = mensajes[index];
                      if (message.fromWho == FromWho.ia) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: CustomIaMessage(
                            text: message.text,
                            imageUrl: message.imageUrl ?? '',
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: CustomPersonMessage(text: message.text),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            CustomMessageFieldBox(
              onValue: (value) {
                mensajeNotifier.enviarMensaje(value, widget.usuarioChat);
                _scrollToBottom(); // Desplazar al final después de enviar
              },
            ),
          ],
        ),
      ),
    );
  }
}
