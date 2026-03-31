import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashLogo extends StatelessWidget {
  final Animation<double> scale;
  final Animation<double> fade;

  const SplashLogo({
    super.key,
    required this.scale,
    required this.fade,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fade,
      builder: (_, __) {
        return ScaleTransition(
          scale: scale,
          child: Hero(
            tag: 'app_logo',
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withValues(
                      alpha: 0.3 * fade.value,
                    ),
                    blurRadius: 25,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Lottie.asset(
                'assets/animations/lil_heart.json',
                height: 120,
              ),
            ),
          ),
        );
      },
    );
  }
}