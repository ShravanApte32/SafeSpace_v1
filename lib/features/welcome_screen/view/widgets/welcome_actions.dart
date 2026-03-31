import 'package:flutter/material.dart';

class WelcomeActions extends StatelessWidget {
  final Animation<double> scale;
  final VoidCallback onStart;
  final VoidCallback onUrgent;

  const WelcomeActions({
    super.key,
    required this.scale,
    required this.onStart,
    required this.onUrgent,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 238, 101, 101),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Let's Start Talking"),
                SizedBox(width: 12),
                Icon(Icons.arrow_forward_rounded),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: onUrgent,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emergency_rounded, color: Colors.redAccent),
                SizedBox(width: 12),
                Text(
                  'I need urgent help',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
