import 'package:flutter/material.dart';

class SplashText extends StatelessWidget {
  final bool isDarkMode;
  final Animation<double> fade;
  final Animation<Offset> slide;

  const SplashText({
    super.key,
    required this.isDarkMode,
    required this.fade,
    required this.slide,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fade,
      builder: (_, __) {
        return SlideTransition(
          position: slide,
          child: Opacity(
            opacity: fade.value,
            child: Column(
              children: [
                Text(
                  'SafeSpace',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Here for you, always',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDarkMode
                        ? Colors.white60
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}