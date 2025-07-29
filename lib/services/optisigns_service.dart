import '../models/user.dart';

class OptiSignsService {
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
        return User(
          id: 'user_001',
          email: email,
          name: 'Advertiser User',
          company: 'Demo Company',
          role: UserRole.advertiser,
        );
      }
    }
    
    return null;
  }
}