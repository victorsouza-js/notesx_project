import 'package:flutter/material.dart';
import 'dart:math' as math;

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _iconController;
  late AnimationController _particleController;
  late AnimationController _buttonController;
  late AnimationController _rippleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _buttonOpacityAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<Color?> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    // Controller principal para animações gerais
    _mainController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );

    // Controller para o ícone
    _iconController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    // Controller para partículas
    _particleController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    // Controller para o botão
    _buttonController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Controller para efeito ripple
    _rippleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    // Animações principais
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Interval(0.3, 0.8, curve: Curves.elasticOut),
    ));

    // Animações do ícone
    _iconScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Interval(0.0, 0.7, curve: Curves.elasticOut),
    ));

    _iconRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));

    // Animações do botão
    _buttonScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.elasticOut,
    ));

    _buttonOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    // Animação de partículas
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);

    // Animação ripple
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    // Animação do background gradient
    _backgroundAnimation = ColorTween(
      begin: Color(0xFF1A1A2E),
      end: Color(0xFF16213E),
    ).animate(_mainController);

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 500));
    _mainController.forward();
    _iconController.forward();
    
    await Future.delayed(Duration(milliseconds: 2000));
    _buttonController.forward();
  }

  void _onButtonPressed() async {
    _rippleController.forward();
    
    // Haptic feedback
    // HapticFeedback.lightImpact();
    
    await Future.delayed(Duration(milliseconds: 300));
    
    if (mounted) {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _iconController.dispose();
    _particleController.dispose();
    _buttonController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _backgroundAnimation.value ?? Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                  Color(0xFF0F3460),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Partículas flutuantes
                ...List.generate(20, (index) => _buildFloatingParticle(index)),
                
                // Conteúdo principal
                Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Container com efeito glassmorphism para o ícone
                          Container(
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: AnimatedBuilder(
                              animation: _iconController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _iconScaleAnimation.value,
                                  child: Transform.rotate(
                                    angle: _iconRotationAnimation.value * 0.1,
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 21, 21, 21),
                                            Color.fromARGB(255, 255, 255, 255),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(255, 236, 237, 238).withOpacity(0.4),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.notes,
                                        size: 60,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 40),

                          Text('NotesX',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          

                          SizedBox(height: 15),

                          // Subtítulo com fade in
                          TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 2000),
                            tween: Tween(begin: 0.0, end: 1.0),
                            curve: Interval(0.5, 1.0, curve: Curves.easeOut),
                            builder: (context, opacity, child) {
                              return Opacity(
                                opacity: opacity,
                                child: Text(
                                  'Sua plataforma de anotações',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 1,
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 60),

                          // Botão moderno com animações
                          AnimatedBuilder(
                            animation: Listenable.merge([
                              _buttonScaleAnimation,
                              _buttonOpacityAnimation,
                              _rippleAnimation,
                            ]),
                            builder: (context, child) {
                              return Opacity(
                                opacity: _buttonOpacityAnimation.value,
                                child: Transform.scale(
                                  scale: _buttonScaleAnimation.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(255, 17, 17, 17).withOpacity(0.4),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                          offset: Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        // Efeito ripple
                                        if (_rippleAnimation.value > 0)
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                color: Colors.white.withOpacity(
                                                  0.3 * (1 - _rippleAnimation.value),
                                                ),
                                              ),
                                            ),
                                          ),
                                        
                                        // Botão
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: _onButtonPressed,
                                            borderRadius: BorderRadius.circular(30),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 50,
                                                vertical: 18,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Começar',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w600,
                                                      color:  Color.fromARGB(255, 2, 2, 2),
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Icon(
                                                    Icons.arrow_forward_rounded,
                                                    color: Color.fromARGB(255, 20, 19, 19),
                                                    size: 24,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 4 + 2;
    final startX = random.nextDouble();
    final startY = random.nextDouble();
    final duration = random.nextInt(3000) + 2000;

    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        final progress = (_particleAnimation.value + (index * 0.1)) % 1.0;
        return Positioned(
          left: MediaQuery.of(context).size.width * startX,
          top: MediaQuery.of(context).size.height * 
              ((startY + progress * 0.5) % 1.0),
          child: Opacity(
            opacity: (math.sin(progress * math.pi) * 0.5).clamp(0.0, 0.6),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.8),
                    Colors.white.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}