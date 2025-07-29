import 'package:flutter/foundation.dart';

class ScreensProvider with ChangeNotifier {
  List<Map<String, dynamic>> _screens = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get screens => _screens;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadScreens() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Mock data for demo
      await Future.delayed(const Duration(seconds: 1));
      _screens = [
        {
          'id': 'screen_001',
          'name': 'Downtown Mall - Main Entrance',
          'address': '123 Main St, Downtown',
          'status': 'online',
          'pricePerHour': 25.0,
          'viewsPerDay': 5000,
          'category': 'retail',
        },
        {
          'id': 'screen_002',
          'name': 'Central Station - Platform A',
          'address': '456 Station Ave, Central',
          'status': 'online',
          'pricePerHour': 35.0,
          'viewsPerDay': 8000,
          'category': 'transport',
        },
        {
          'id': 'screen_003',
          'name': 'Times Square Billboard',
          'address': '789 Broadway, Times Square',
          'status': 'online',
          'pricePerHour': 150.0,
          'viewsPerDay': 50000,
          'category': 'outdoor',
        },
      ];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load screens: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}