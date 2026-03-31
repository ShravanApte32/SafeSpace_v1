import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../viewmodels/base_viewmodel.dart';
import '../../core/widgets/app_loader.dart';

class WelcomeViewModel extends BaseViewModel {
  static const String routeOnboarding = '/onboarding';
  static const String routeUrgentHelp = '/urgent-help';

  String? _navigationDestination;
  String? get navigationDestination => _navigationDestination;

  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  void navigateToOnboarding() {
    _showLoaderDialog();

    Future.delayed(const Duration(seconds: 2), () {
      _hideLoaderDialog();
      _navigationDestination = routeOnboarding;
      notifyListeners();
    });
  }

  void navigateToUrgentHelp() {
    _navigationDestination = routeUrgentHelp;
    notifyListeners();
  }

  void _showLoaderDialog() {
    showDialog(
      context: _context!,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => const AppLoader(),
    );
  }

  void _hideLoaderDialog() {
    Navigator.of(_context!).pop();
  }

  Future<bool> handleExitDialog(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => _buildExitDialog(context),
    );
    return shouldExit ?? false;
  }

  void resetNavigation() {
    _navigationDestination = null;
    notifyListeners();
  }

  Widget _buildExitDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFE4EC),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/exit.json',
              height: 80,
              width: 80,
              repeat: true,
              animate: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Exit SafeSpace?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEF9A9A),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your safe space will be here whenever you need it.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFFEF9A9A),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Stay',
                    style: TextStyle(
                      color: Color(0xFFEF9A9A),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF9A9A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Exit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
