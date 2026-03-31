import 'package:flutter/material.dart';
import 'package:safespace_v1/features/welcome_screen/view/screens/welcome_screen.dart';
import '../../viewmodel/splash_viewmodel.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_logo.dart';
import '../widgets/splash_text.dart';
import '../widgets/splash_loader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _textSlideAnimation;

  late SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    // Initialize ViewModel
    _viewModel = SplashViewModel();

    // Setup animations
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _fadeController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
          ),
        );

    _fadeController.forward();

    // Trigger haptic feedback
    _viewModel.triggerHapticFeedback();

    // Start the navigation timer logic
    Future.delayed(const Duration(milliseconds: 3200), () {
      _viewModel.checkAuthAndNavigate();
    });

    // Listen for navigation
    _viewModel.addListener(_handleNavigation);
  }

  void _handleNavigation() {
    final destination = _viewModel.navigationDestination;
    if (destination != null && mounted) {
      if (destination == '/welcome') {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const WelcomeScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: child,
                ),
              );
            },
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_handleNavigation);
    _viewModel.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return Scaffold(
    body: SplashBackground(
      isDarkMode: isDarkMode,
      controller: _fadeController,
      fade: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SplashLogo(
              scale: _scaleAnimation,
              fade: _fadeAnimation,
            ),

            const SizedBox(height: 25),

            SplashText(
              isDarkMode: isDarkMode,
              fade: _fadeAnimation,
              slide: _textSlideAnimation,
            ),

            const SizedBox(height: 50),

            SplashLoader(
              controller: _fadeController,
              fade: _fadeAnimation,
              isDarkMode: isDarkMode,
            ),

            if (_viewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
}
