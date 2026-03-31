import 'package:flutter/material.dart';

class SplashLoader extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> fade;
  final bool isDarkMode;

  const SplashLoader({
    super.key,
    required this.controller,
    required this.fade,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Opacity(
          opacity: fade.value,
          child: SizedBox(
            width: 120,
            child: LinearProgressIndicator(
              value: controller.value,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDarkMode
                    ? Colors.pinkAccent
                    : const Color.fromARGB(255, 238, 101, 101),
              ),
              backgroundColor: Colors.transparent,
              minHeight: 2,
            ),
          ),
        );
      },
    );
  }
}