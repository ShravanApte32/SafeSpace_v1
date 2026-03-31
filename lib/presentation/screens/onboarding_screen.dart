import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../viewmodels/onboarding_viewmodel.dart';
// import './login_screen.dart';
// import '../../core/widgets/app_loader.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  late OnboardingViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = OnboardingViewModel();
    _pageController = PageController();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();

    // Start auto-swipe timer
    _viewModel.startAutoSwipe(_pageController);

    // Listen for navigation
    _viewModel.addListener(_handleNavigation);
  }

  void _handleNavigation() {
    final destination = _viewModel.navigationDestination;
    if (destination != null && mounted) {
      _viewModel.resetNavigation();

      // if (destination == OnboardingViewModel.routeLogin) {
      //   _navigateWithLoader(const LoginScreen());
      // }
    }
  }

  // void _navigateWithLoader(Widget nextPage) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => const AppLoader(),
  //   );

  //   Future.delayed(const Duration(seconds: 2), () {
  //     if (mounted) {
  //       Navigator.pop(context);
  //       Navigator.push(context, MaterialPageRoute(builder: (_) => nextPage));
  //     }
  //   });
  // }

  @override
  void dispose() {
    _viewModel.removeListener(_handleNavigation);
    _viewModel.dispose();
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4EC),
      body: SafeArea(
        child: Column(
          children: [
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _viewModel.totalPages,
                onPageChanged: (index) {
                  _viewModel.setCurrentPage(index);
                  _animController.reset();
                  _animController.forward();
                },
                itemBuilder: (context, index) {
                  final slide = OnboardingViewModel.slides[index];
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),

                            // Animated Lottie Container
                            Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.pinkAccent.withOpacity(0.15),
                                    Colors.transparent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pinkAccent.withOpacity(0.1),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Lottie.asset(
                                slide.lottieAsset,
                                height: 250,
                                fit: BoxFit.contain,
                                animate: true,
                                repeat: true,
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Title
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Text(
                                slide.title,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                  letterSpacing: -0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Description
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.2),
                                end: Offset.zero,
                              ).animate(_animController),
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Text(
                                  slide.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Page Indicators
            SizedBox(
              height: 60,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _viewModel.totalPages,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _viewModel.currentPage == index ? 28 : 8,
                      decoration: BoxDecoration(
                        color: _viewModel.currentPage == index
                            ? Colors.redAccent
                            : Colors.redAccent.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _viewModel.currentPage == index
                            ? [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Buttons Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip Button (only show on non-last pages)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: !_viewModel.isLastPage
                        ? TextButton(
                            key: const ValueKey('skip'),
                            onPressed: _viewModel.navigateToLogin,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
                            ),
                          )
                        : const SizedBox(width: 80, key: ValueKey('space')),
                  ),

                  // Get Started / Next Button
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(_viewModel.currentPage),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: _viewModel.navigateToLogin,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _viewModel.isLastPage
                              ? const Text(
                                  'Get Started',
                                  key: ValueKey('get_started'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : const Row(
                                  key: ValueKey('next'),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Next',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded, size: 18),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
