import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _buttonController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Controller para fade in geral
    _fadeController = AnimationController(
      duration:  Duration(milliseconds: 1500),
      vsync: this,
    );

    // Controller para slide dos elementos
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Controller para animação do botão
    _buttonController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    // Animação de fade
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Animação de slide (de baixo para cima)
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    // Animação de escala do botão
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    // Iniciar animações com delay
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed( Duration(milliseconds: 200));
    _slideController.forward();
  }

  void _onButtonPressed() async {
    // Animação do botão ao ser pressionado
    await _buttonController.forward();
    await _buttonController.reverse();

    // Navegar para a próxima tela
    if (mounted) {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone com animação de rotação sutil
                TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 2000),
                  tween: Tween(begin: 0.0, end: 0.8),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + (value * 0.5), // Cresce de 0.8 para 1.0
                      child: Icon(
                        Icons.notes,
                        size: 100,
                        color: Colors.black.withOpacity(0.8 + (value * 0.2)),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20),

                // Título com animação de typing effect
                TweenAnimationBuilder<int>(
                  duration:  Duration(milliseconds: 2200),
                  tween: IntTween(
                    begin: 0,
                    end: 7,
                  ), // "NotesX" tem 6 caracteres
                  builder: (context, value, child) {
                    String displayText = "NotesX".substring(
                      0,
                      value.clamp(0, 6),
                    );
                    return Text(
                      displayText,
                      style:  TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),

                SizedBox(height: 15),

                // Subtítulo
                Text(
                  'Sua plataforma de anotações',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),

                SizedBox(height: 40),

                // Botão com animação
                AnimatedBuilder(
                  animation: _buttonScaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _buttonScaleAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _onButtonPressed,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            textStyle: TextStyle(fontSize: 18),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 0, // Remove sombra padrão
                          ),
                          child: Text('Começar'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
