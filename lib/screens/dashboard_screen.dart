import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/screens_provider.dart';
import '../providers/campaigns_provider.dart';
import 'login_screen.dart';
import 'dashboard_home_screen.dart';
import 'locations_screen.dart';
import 'campaigns_screen.dart';
import 'admin_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final screensProvider = Provider.of<ScreensProvider>(context, listen: false);
    final campaignsProvider = Provider.of<CampaignsProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      screensProvider.loadScreens();
      campaignsProvider.loadCampaigns(authProvider.currentUser!.id);
    }
  }

  List<Widget> _getScreens() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.isAdmin) {
      return [
        const DashboardHomeScreen(),
        const LocationsScreen(),
        const CampaignsScreen(),
        const AdminScreen(),
      ];
    } else {
      return [
        const DashboardHomeScreen(),
        const LocationsScreen(),
        const CampaignsScreen(),
      ];
    }
  }

  List<NavigationItem> _getNavigationItems() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final baseItems = [
      NavigationItem(Icons.dashboard, 'Dashboard'),
      NavigationItem(Icons.location_on, 'Locations'),
      NavigationItem(Icons.campaign, 'Campaigns'),
    ];

    if (authProvider.isAdmin) {
      baseItems.add(NavigationItem(Icons.admin_panel_settings, 'Admin'));
    }

    return baseItems;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isLoggedIn) {
          return const LoginScreen();
        }

        final screens = _getScreens();
        final navItems = _getNavigationItems();

        return Scaffold(
          body: Row(
            children: [
              // Sidebar
              Container(
                width: 280,
                color: const Color(0xFF1E3A8A),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.tv,
                              color: Color(0xFF1E3A8A),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'AdNabbit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // User Info
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authProvider.currentUser?.name ?? 'User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            authProvider.currentUser?.company ?? 'Company',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: authProvider.isAdmin ? Colors.red : Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              authProvider.isAdmin ? 'Administrator' : 'Advertiser',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Navigation
                    Expanded(
                      child: ListView.builder(
                        itemCount: navItems.length,
                        itemBuilder: (context, index) {
                          return _buildNavItem(
                            navItems[index].icon,
                            navItems[index].title,
                            index,
                          );
                        },
                      ),
                    ),

                    // Logout Button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await authProvider.logout();
                            if (mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            }
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: screens[_selectedIndex],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    final isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Colors.white.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String title;

  NavigationItem(this.icon, this.title);
}