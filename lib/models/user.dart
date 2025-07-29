enum UserRole { admin, advertiser }

class User {
  final String id;
  final String email;
  final String name;
  final String company;
  final UserRole role;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.company,
    required this.role,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isAdvertiser => role == UserRole.advertiser;
}