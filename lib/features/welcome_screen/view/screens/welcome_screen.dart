import 'package:flutter/material.dart';
import 'package:safespace_v1/features/welcome_screen/view/widgets/welcome_actions.dart';
import 'package:safespace_v1/features/welcome_screen/view/widgets/welcome_background.dart';
import 'package:safespace_v1/features/welcome_screen/view/widgets/welcome_footer.dart';
import 'package:safespace_v1/features/welcome_screen/view/widgets/welcome_logo.dart';
import 'package:safespace_v1/features/welcome_screen/view/widgets/welcome_text.dart';
import '../../viewmodel/welcome_viewmodel.dart';
import '../../../onboarding_screen/view/screens/onboarding_screen.dart';
import '../../../urgent_help_screen/view/screens/urgent_help_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScaleAnimation;

  late WelcomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = WelcomeViewModel();
    _viewModel.setContext(context); // IMPORTANT: Set context

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _offsetAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
    );

    _buttonScaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward();
    });

    _viewModel.addListener(_handleNavigation);
  }

  void _handleNavigation() {
    final destination = _viewModel.navigationDestination;
    if (destination != null && mounted) {
      _viewModel.resetNavigation();

      if (destination == WelcomeViewModel.routeOnboarding) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const OnboardingScreen(),
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
      } else if (destination == WelcomeViewModel.routeUrgentHelp) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const UrgentHelpScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0.0, 0.5),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                child: child,
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _viewModel.handleExitDialog(context),
      child: Scaffold(
        body: WelcomeBackground(
          child: Center(
            child: SingleChildScrollView(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        WelcomeLogo(offsetAnimation: _offsetAnimation),
                        const SizedBox(height: 32),

                        const WelcomeText(),
                        const SizedBox(height: 48),

                        WelcomeActions(
                          scale: _buttonScaleAnimation,
                          onStart: _viewModel.navigateToOnboarding,
                          onUrgent: _viewModel.navigateToUrgentHelp,
                        ),

                        const SizedBox(height: 40),
                        const WelcomeFooter(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
