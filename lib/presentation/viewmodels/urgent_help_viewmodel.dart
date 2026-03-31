import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../viewmodels/base_viewmodel.dart';

class UrgentHelpViewModel extends BaseViewModel {
  // Navigation destinations
  static const String routeEmergencyContacts = '/emergency-contacts';

  String? _navigationDestination;
  String? get navigationDestination => _navigationDestination;

  // Help options data (pure data, no UI)
  final List<HelpOption> helpOptions = [
    HelpOption(
      icon: Icons.phone_in_talk_rounded,
      title: 'National Helpline',
      subtitle: 'Speak with trained counselors now',
      color: const Color(0xFFFF5252),
      gradientStart: const Color(0xFFFF5252),
      gradientEnd: const Color(0xFFFF8A80),
      action: HelpAction.call,
      number: '917020666430',
    ),
    HelpOption(
      icon: Icons.chat_rounded,
      title: 'WhatsApp Support',
      subtitle: '24/7 anonymous chat support',
      color: const Color(0xFF4CAF50),
      gradientStart: const Color(0xFF4CAF50),
      gradientEnd: const Color(0xFF81C784),
      action: HelpAction.whatsapp,
      number: '917020666430',
    ),
    HelpOption(
      icon: Icons.contact_emergency_rounded,
      title: 'Emergency Contacts',
      subtitle: 'Your trusted support network',
      color: const Color(0xFF7986CB),
      gradientStart: const Color(0xFF7986CB),
      gradientEnd: const Color(0xFF9FA8DA),
      action: HelpAction.contacts,
    ),
  ];

  // Handle different actions
  Future<void> handleAction(HelpOption option) async {
    setBusy(true);

    switch (option.action) {
      case HelpAction.call:
        await _callNumber(option.number!);
        break;
      case HelpAction.whatsapp:
        await _openWhatsApp(
          option.number!,
          'Hi, I need urgent emotional support.',
        );
        break;
      case HelpAction.contacts:
        _navigationDestination = routeEmergencyContacts;
        break;
    }

    setBusy(false);
  }

  Future<void> _callNumber(String number) async {
    final Uri callUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      setErrorMessage('Unable to make call');
    }
  }

  Future<void> _openWhatsApp(String phone, String message) async {
    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = 'whatsapp://send?phone=$phone&text=$encodedMessage';

    try {
      if (await canLaunchUrlString(whatsappUrl)) {
        await launchUrlString(
          whatsappUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        final fallbackUrl = 'https://wa.me/$phone?text=$encodedMessage';
        if (await canLaunchUrlString(fallbackUrl)) {
          await launchUrlString(
            fallbackUrl,
            mode: LaunchMode.externalApplication,
          );
        } else {
          setErrorMessage('Unable to open WhatsApp');
        }
      }
    } catch (e) {
      setErrorMessage('Error: $e');
    }
  }

  // Reset navigation state
  void resetNavigation() {
    _navigationDestination = null;
    notifyListeners();
  }

  // Go back
  void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}

// Enum for help actions
enum HelpAction { call, whatsapp, contacts }

// Data model for help options
class HelpOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color gradientStart;
  final Color gradientEnd;
  final HelpAction action;
  final String? number;

  HelpOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.gradientStart,
    required this.gradientEnd,
    required this.action,
    this.number,
  });

  List<Color> get gradientColors => [gradientStart, gradientEnd];
}
