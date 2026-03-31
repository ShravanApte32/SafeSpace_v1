import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  bool _isBusy = false;
  String? _errorMessage;
  bool _isDisposed = false;

  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;
  bool get isDisposed => _isDisposed;

  void setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
