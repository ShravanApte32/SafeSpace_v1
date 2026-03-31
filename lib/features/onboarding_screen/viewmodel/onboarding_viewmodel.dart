import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/viewmodel/base_viewmodel.dart';

class OnboardingViewModel extends BaseViewModel {
  // Onboarding data (pure data)
  static const List<OnboardingSlide> slides = [
    OnboardingSlide(
      lottieAsset: 'assets/animations/ai_friend.json',
      title: 'Welcome to Your Space',
      description: 'A safe and calming place designed just for you, where every conversation matters.',
    ),
    OnboardingSlide(
      lottieAsset: 'assets/animations/smart_conversations.json',
      title: 'Talk. Share. Feel Better.',
      description: "Open up about your thoughts and feelings anytime — we're here to listen and guide.",
    ),
    OnboardingSlide(
      lottieAsset: 'assets/animations/stay_connected.json',
      title: 'Your Journey to Wellness',
      description: "Small steps lead to big changes. Let's begin your path toward a happier, healthier you.",
    ),
  ];
  
  int _currentPage = 0;
  Timer? _autoSwipeTimer;
  bool _isNavigating = false;
  
  int get currentPage => _currentPage;
  int get totalPages => slides.length;
  bool get isLastPage => _currentPage == slides.length - 1;
  bool get isFirstPage => _currentPage == 0;
  bool get isNavigating => _isNavigating;
  
  // Navigation destination
  static const String routeLogin = '/login';
  String? _navigationDestination;
  String? get navigationDestination => _navigationDestination;
  
  void setCurrentPage(int page) {
    if (page != _currentPage && page >= 0 && page < slides.length) {
      _currentPage = page;
      notifyListeners();
    }
  }
  
  void nextPage() {
    if (!isLastPage) {
      _currentPage++;
      notifyListeners();
    }
  }
  
  void startAutoSwipe(PageController pageController) {
    _autoSwipeTimer = Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      if (pageController.hasClients && !_isNavigating) {
        final nextPage = (_currentPage + 1) % slides.length;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }
  
  void stopAutoSwipe() {
    _autoSwipeTimer?.cancel();
    _autoSwipeTimer = null;
  }
  
  void navigateToLogin() {
    if (_isNavigating) return;
    
    _isNavigating = true;
    _navigationDestination = routeLogin;
    notifyListeners();
  }
  
  void resetNavigation() {
    _navigationDestination = null;
    _isNavigating = false;
    notifyListeners();
  }
  
  @override
  void dispose() {
    stopAutoSwipe();
    super.dispose();
  }
}

// Onboarding Slide Model
class OnboardingSlide {
  final String lottieAsset;
  final String title;
  final String description;
  
  const OnboardingSlide({
    required this.lottieAsset,
    required this.title,
    required this.description,
  });
}