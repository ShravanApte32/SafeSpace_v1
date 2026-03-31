import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/viewmodel/base_viewmodel.dart';

class SplashViewModel extends BaseViewModel {
  Timer? _navigationTimer;

  // Animation-related state (will be used by View)
  double fadeProgress = 0.0;
  double scaleValue = 0.85;
  Offset textOffset = const Offset(0, 0.3);

  void startAnimation(TickerProvider vsync) {
    // Create animation controller (View will handle the actual AnimationController)
    // But ViewModel decides WHEN to navigate
    const navigationDelay = Duration(milliseconds: 3200);

    _navigationTimer = Timer(navigationDelay, () {
      if (!isDisposed) {
        _navigateToNext();
      }
    });
  }

  Future<void> checkAuthAndNavigate() async {
    setBusy(true);

    try {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;

      _navigationDestination = isLoggedIn ? '/home' : '/welcome';
    } catch (e) {
      setErrorMessage('Error checking auth status');
      _navigationDestination = '/welcome';
    }

    setBusy(false);
    notifyListeners();
  }

  Future<void> _navigateToNext() async {
    setBusy(true);

    try {
      // Check if user is already logged in
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;

      setBusy(false);

      // Trigger navigation (will be handled by View)
      notifyListeners(); // View will listen to this

      // Store navigation destination in ViewModel state
      _navigationDestination = isLoggedIn ? '/home' : '/welcome';
      notifyListeners();
    } catch (e) {
      setErrorMessage('Error checking auth status: $e');
      setBusy(false);
      // Navigate to welcome screen as fallback
      _navigationDestination = '/welcome';
      notifyListeners();
    }
  }

  String? _navigationDestination;
  String? get navigationDestination => _navigationDestination;

  void triggerHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }
}
