import 'package:flutter/foundation.dart';

class CampaignsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _campaigns = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get campaigns => _campaigns;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCampaigns(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Mock data for demo
      await Future.delayed(const Duration(seconds: 1));
      _campaigns = [
        {
          'id': 'campaign_001',
          'name': 'Summer Sale Campaign',
          'status': 'active',
          'budget': 1000.0,
          'spent': 250.0,
          'views': 15000,
        },
      ];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load campaigns: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}