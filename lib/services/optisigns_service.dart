import '../models/user.dart';
import '../models/screen_location.dart';

class OptiSignsService {
  // Mock database of screen locations with slot availability
  static final List<ScreenLocation> _mockScreens = [
    ScreenLocation(
      id: 'screen_001',
      name: 'Downtown Mall - Main Entrance',
      address: '123 Main St, Downtown',
      latitude: 40.7128,
      longitude: -74.0060,
      status: 'online',
      resolution: '1920x1080',
      screenSize: 55.0,
      supportedFormats: ['jpg', 'png', 'mp4'],
      pricePerHour: 25.0,
      ownerId: 'owner_001',
      schedule: {'monday': '9:00-22:00', 'tuesday': '9:00-22:00'},
      viewsPerDay: 5000,
      category: 'retail',
      totalSlots: 50,
      usedSlots: 32,
      activeAdIds: List.generate(32, (i) => 'ad_${i + 1}'),
    ),
    ScreenLocation(
      id: 'screen_002',
      name: 'Central Station - Platform A',
      address: '456 Transit Ave, Central',
      latitude: 40.7589,
      longitude: -73.9851,
      status: 'online',
      resolution: '1920x1080',
      screenSize: 65.0,
      supportedFormats: ['jpg', 'png', 'mp4'],
      pricePerHour: 35.0,
      ownerId: 'owner_002',
      schedule: {'monday': '6:00-24:00', 'tuesday': '6:00-24:00'},
      viewsPerDay: 8000,
      category: 'transport',
      totalSlots: 50,
      usedSlots: 45,
      activeAdIds: List.generate(45, (i) => 'ad_${i + 33}'),
    ),
    ScreenLocation(
      id: 'screen_003',
      name: 'Times Square Billboard',
      address: '789 Broadway, Times Square',
      latitude: 40.7580,
      longitude: -73.9855,
      status: 'online',
      resolution: '4K',
      screenSize: 100.0,
      supportedFormats: ['jpg', 'png', 'mp4', 'gif'],
      pricePerHour: 150.0,
      ownerId: 'owner_003',
      schedule: {'monday': '0:00-24:00', 'tuesday': '0:00-24:00'},
      viewsPerDay: 50000,
      category: 'outdoor',
      totalSlots: 50,
      usedSlots: 48,
      activeAdIds: List.generate(48, (i) => 'ad_${i + 78}'),
    ),
    ScreenLocation(
      id: 'screen_004',
      name: 'Airport Terminal 1',
      address: '321 Airport Blvd, Terminal 1',
      latitude: 40.6892,
      longitude: -74.1745,
      status: 'online',
      resolution: '1920x1080',
      screenSize: 75.0,
      supportedFormats: ['jpg', 'png', 'mp4'],
      pricePerHour: 45.0,
      ownerId: 'owner_004',
      schedule: {'monday': '5:00-24:00', 'tuesday': '5:00-24:00'},
      viewsPerDay: 12000,
      category: 'transport',
      totalSlots: 50,
      usedSlots: 28,
      activeAdIds: List.generate(28, (i) => 'ad_${i + 126}'),
    ),
    ScreenLocation(
      id: 'screen_005',
      name: 'Shopping Center Food Court',
      address: '654 Mall Way, Food Court',
      latitude: 40.7282,
      longitude: -73.7949,
      status: 'online',
      resolution: '1920x1080',
      screenSize: 42.0,
      supportedFormats: ['jpg', 'png', 'mp4'],
      pricePerHour: 20.0,
      ownerId: 'owner_005',
      schedule: {'monday': '10:00-22:00', 'tuesday': '10:00-22:00'},
      viewsPerDay: 3000,
      category: 'retail',
      totalSlots: 50,
      usedSlots: 15,
      activeAdIds: List.generate(15, (i) => 'ad_${i + 154}'),
    ),
    ScreenLocation(
      id: 'screen_006',
      name: 'Business District Plaza',
      address: '987 Corporate Dr, Plaza',
      latitude: 40.7505,
      longitude: -73.9934,
      status: 'online',
      resolution: '1920x1080',
      screenSize: 60.0,
      supportedFormats: ['jpg', 'png', 'mp4'],
      pricePerHour: 30.0,
      ownerId: 'owner_006',
      schedule: {'monday': '7:00-19:00', 'tuesday': '7:00-19:00'},
      viewsPerDay: 7000,
      category: 'business',
      totalSlots: 50,
      usedSlots: 22,
      activeAdIds: List.generate(22, (i) => 'ad_${i + 169}'),
    ),
  ];

  Future<User?> authenticateUser(String email, String password) async {
    // Mock authentication for demo
    await Future.delayed(const Duration(seconds: 1));
    
    if (password == 'demo123') {
      if (email == 'admin@adnabbit.com') {
        return User(
          id: 'admin_001',
          email: email,
          name: 'Admin User',
          company: 'AdNabbit Corp',
          role: UserRole.admin,
        );
      } else if (email == 'user@adnabbit.com') {
        // Create a user with an active subscription
        final subscription = Subscription(
          id: 'sub_001',
          tier: SubscriptionTier.standard,
          startDate: DateTime.now().subtract(const Duration(days: 15)),
          endDate: DateTime.now().add(const Duration(days: 15)),
          isActive: true,
          screenLimit: SubscriptionTier.standard.screenLimit,
          monthlyPrice: SubscriptionTier.standard.price,
        );
        
        return User(
          id: 'user_001',
          email: email,
          name: 'Advertiser User',
          company: 'Demo Company',
          role: UserRole.advertiser,
          subscription: subscription,
        );
      }
    }
    
    return null;
  }

  Future<List<ScreenLocation>> getAvailableScreens({String? category}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    List<ScreenLocation> screens = List.from(_mockScreens);
    
    // Filter by category if provided
    if (category != null && category.isNotEmpty) {
      screens = screens.where((screen) => screen.category == category).toList();
    }
    
    // Only return online screens
    screens = screens.where((screen) => screen.status == 'online').toList();
    
    return screens;
  }

  Future<bool> canUserAccessScreen(User user, ScreenLocation screen) async {
    // Admin can access all screens
    if (user.isAdmin) return true;
    
    // Advertisers need active subscription
    if (!user.hasActiveSubscription) return false;
    
    // Check if screen has available slots
    return screen.hasAvailableSlots;
  }

  Future<bool> reserveScreenSlot(User user, String screenId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Check user subscription
    if (!user.hasActiveSubscription && !user.isAdmin) {
      throw Exception('Active subscription required to reserve screen slots');
    }
    
    // Find screen
    final screenIndex = _mockScreens.indexWhere((s) => s.id == screenId);
    if (screenIndex == -1) {
      throw Exception('Screen not found');
    }
    
    final screen = _mockScreens[screenIndex];
    
    // Check availability
    if (!screen.hasAvailableSlots) {
      throw Exception('No available slots on this screen');
    }
    
    // Mock reservation (in real app, this would update the database)
    // For demo purposes, we'll just return success
    return true;
  }

  Future<Map<String, dynamic>> getScreenStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final totalScreens = _mockScreens.length;
    final onlineScreens = _mockScreens.where((s) => s.status == 'online').length;
    final totalSlots = _mockScreens.fold<int>(0, (sum, screen) => sum + screen.totalSlots);
    final usedSlots = _mockScreens.fold<int>(0, (sum, screen) => sum + screen.usedSlots);
    final availableSlots = totalSlots - usedSlots;
    
    return {
      'totalScreens': totalScreens,
      'onlineScreens': onlineScreens,
      'totalSlots': totalSlots,
      'usedSlots': usedSlots,
      'availableSlots': availableSlots,
      'occupancyRate': totalSlots > 0 ? (usedSlots / totalSlots * 100).round() : 0,
    };
  }

  List<SubscriptionTier> getAvailableSubscriptionTiers() {
    return SubscriptionTier.values;
  }

  Future<Subscription> createSubscription(User user, SubscriptionTier tier) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return Subscription(
      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      tier: tier,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      isActive: true,
      screenLimit: tier.screenLimit,
      monthlyPrice: tier.price,
    );
  }
}