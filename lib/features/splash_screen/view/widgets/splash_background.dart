import 'package:flutter/material.dart';

class SplashBackground extends StatelessWidget {
  final bool isDarkMode;
  final AnimationController controller;
  final Animation<double> fade;
  final Widget child;

  const SplashBackground({
    super.key,
    required this.isDarkMode,
    required this.controller,
    required this.fade,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? const [
                  Color(0xFF1E1E1E),
                  Color(0xFF2A2A2A),
                  Color(0xFF3A1F1F),
                ]
              : const [
                  Color(0xFFFFE0E0),
                  Color(0xFFFCE4EC),
                  Color(0xFFF8BBD0),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Stack(
            children: [
              Positioned(
                top: 100,
                right: -30,
                child: Opacity(
                  opacity: fade.value * 0.2,
                  child: _circle(180, Colors.pinkAccent, Colors.redAccent),
                ),
              ),
              Positioned(
                bottom: 120,
                left: -60,
                child: Opacity(
                  opacity: fade.value * 0.15,
                  child: _circle(200, Colors.redAccent, Colors.pink),
                ),
              ),
              child,
            ],
          );
        },
      ),
    );
  }

  Widget _circle(double size, Color c1, Color c2) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            c1.withValues(alpha: 0.3),
            c2.withValues(alpha: 0.3),
          ],
        ),
      ),
    );
  }
}