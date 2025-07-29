enum UserRole { admin, advertiser }

class User {
  final String id;
  final String email;
  final String name;
  final String company;
  final UserRole role;
  final Subscription? subscription;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.company,
    required this.role,
    this.subscription,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isAdvertiser => role == UserRole.advertiser;
  bool get hasActiveSubscription => subscription?.isActive ?? false;
}

class Subscription {
  final String id;
  final SubscriptionTier tier;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final int screenLimit;
  final double monthlyPrice;

  Subscription({
    required this.id,
    required this.tier,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.screenLimit,
    required this.monthlyPrice,
  });
}

enum SubscriptionTier {
  basic,    // $100/month - 5 screens
  standard, // $150/month - 10 screens
  premium,  // $300/month - 30 screens
}

extension SubscriptionTierExtension on SubscriptionTier {
  String get name {
    switch (this) {
      case SubscriptionTier.basic:
        return 'Basic';
      case SubscriptionTier.standard:
        return 'Standard';
      case SubscriptionTier.premium:
        return 'Premium';
    }
  }

  double get price {
    switch (this) {
      case SubscriptionTier.basic:
        return 100.0;
      case SubscriptionTier.standard:
        return 150.0;
      case SubscriptionTier.premium:
        return 300.0;
    }
  }

  int get screenLimit {
    switch (this) {
      case SubscriptionTier.basic:
        return 5;
      case SubscriptionTier.standard:
        return 10;
      case SubscriptionTier.premium:
        return 30;
    }
  }
}