import 'dart:ui';
import 'package:encuestas_utn/features/auth/presentation/widgets/widgets.dart';
import 'package:encuestas_utn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String screenName = 'loginscreen';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animacaoBlur;
  Animation<double>? _animacaoFade;
  Animation<double>? _animacaoSize;
  String _usuario = 'D5004003030';
  String _contrasena = 'test1234';
  // String _usuario = 'E8986051555';
  // String _contrasena = 'E8986051555';

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animacaoBlur = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.ease,
      ),
    );

    _animacaoFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeInOutQuint,
      ),
    );

    _animacaoSize = Tween<double>(
      begin: 0,
      end: 500,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.decelerate,
      ),
    );

    _controller?.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Detecta la altura del teclado
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final padding = keyboardVisible ? 50.0 : 400.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: padding),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _animacaoBlur!,
                builder: (context, widget) {
                  return Container(
                    height: 400,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppAssets.fondoPerfil),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: _animacaoBlur!.value,
                        sigmaY: _animacaoBlur!.value,
                      ),
                      child: const Stack(),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _animacaoSize!,
                      builder: (context, widget) {
                        return Container(
                          width: _animacaoSize?.value,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 80,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              CustomInput(
                                onChanged: (value) {
                                  setState(() {
                                    _usuario = value;
                                  });
                                },
                                hint: 'usuario',
                                obscure: false,
                                icon: const Icon(Icons.person),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 0.5,
                                      blurRadius: 0.5,
                                    ),
                                  ],
                                ),
                              ),
                              CustomInput(
                                onChanged: (value) {
                                  setState(() {
                                    _contrasena = value;
                                  });
                                },
                                hint: 'contraseña',
                                obscure: true,
                                icon: const Icon(Icons.lock),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomButtonAnimate(
                      controller: _controller!,
                      usuario: _usuario,
                      password: _contrasena,
                    ),
                    const SizedBox(height: 10),
                    FadeTransition(
                      opacity: _animacaoFade!,
                      child: const Text(
                        "Para estudiantes la letra E y su cédula ",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
