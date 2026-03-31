import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeLogo extends StatelessWidget {
  final Animation<double> offsetAnimation;

  const WelcomeLogo({super.key, required this.offsetAnimation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, offsetAnimation.value),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Hero(
          tag: 'app_logo',
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withValues(alpha: 0.2),
                  blurRadius: 25,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Lottie.asset(
              'assets/animations/lil_heart.json',
              height: 130,
              repeat: true,
            ),
          ),
        ),
      ),
    );
  }
}