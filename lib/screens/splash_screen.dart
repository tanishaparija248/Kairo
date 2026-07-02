import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double animationValue =
        (_controller.value * 3 - index).clamp(0.0, 1.0);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Color.lerp(
              const Color(0xFFEDE9FE),
              const Color(0xFFA78BFA),
              animationValue,
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Logo
              Image.asset(
                'assets/images/kairo_logo.png',
                height: 100,
              ),

              const SizedBox(height: 28),

              /// App Name
              const Text(
                'KAIRO',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10,
                  color: Color(0xFF1E1B4B),
                ),
              ),

              const SizedBox(height: 20),

              /// Tagline
              const Text(
                'PREPARE. PRACTICE.\nPROGRESS.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                  height: 1.6,
                  color: Color(0xFFA78BFA),
                ),
              ),

              const SizedBox(height: 28),

              /// Gold Divider
              Row(
                children: const [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Color(0xFFE9D5A1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '✦',
                      style: TextStyle(
                        color: Color(0xFFE9D5A1),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Color(0xFFE9D5A1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// Description
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.7,
                    color: Color(0xFF374151),
                  ),
                  children: [
                    TextSpan(
                      text:
                      'Your AI-powered career companion\n'
                          'to analyze, prepare and ',
                    ),
                    TextSpan(
                      text: 'ace.',
                      style: TextStyle(
                        color: Color(0xFFA78BFA),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// Animated 3 Dots Loader
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildDot(0),
                  buildDot(1),
                  buildDot(2),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                'Preparing your journey...',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}