import 'package:url_launcher/url_launcher.dart';
import '../../../core/viewmodel/base_viewmodel.dart';

class EmergencyContactsViewModel extends BaseViewModel {
  List<EmergencyContact> _userContacts = [];

  List<EmergencyContact> get userContacts => List.unmodifiable(_userContacts);

  // Default contacts (empty in your original, but keeping structure)
  static const List<EmergencyContact> defaultContacts = [];

  int get totalContacts => defaultContacts.length + _userContacts.length;

  // Add a new contact
  void addContact(String name, String number) {
    final newContact = EmergencyContact(
      name: name,
      number: number,
      isUserAdded: true,
    );
    _userContacts.add(newContact);
    notifyListeners();
  }

  // Remove a contact
  void removeContact(int userContactIndex) {
    if (userContactIndex >= 0 && userContactIndex < _userContacts.length) {
      _userContacts.removeAt(userContactIndex);
      notifyListeners();
    }
  }

  // Get all contacts (default + user)
  List<EmergencyContact> getAllContacts() {
    return [...defaultContacts, ..._userContacts];
  }

  // Call a number
  Future<bool> callNumber(String number) async {
    final Uri callUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
      return true;
    }
    return false;
  }

  // Validate phone number
  String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a phone number';
    }
    if (value.trim().length != 10) {
      return 'Please enter a valid 10-digit number';
    }
    return null;
  }

  // Validate name
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }
}

// Contact model
class EmergencyContact {
  final String name;
  final String number;
  final bool isUserAdded;

  EmergencyContact({
    required this.name,
    required this.number,
    this.isUserAdded = false,
  });
}
