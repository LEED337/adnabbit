import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: const Row(
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  size: 32,
                  color: Color(0xFF1E3A8A),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Administrator Panel',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Manage all OptiSigns screens, campaigns, and system settings',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Admin Stats
                  Row(
                    children: [
                      _buildAdminStatCard('Total Screens', '25', Icons.tv, Colors.blue),
                      const SizedBox(width: 16),
                      _buildAdminStatCard('Online Screens', '23', Icons.online_prediction, Colors.green),
                      const SizedBox(width: 16),
                      _buildAdminStatCard('All Campaigns', '12', Icons.campaign, Colors.orange),
                      const SizedBox(width: 16),
                      _buildAdminStatCard('Total Revenue', '\$15,240', Icons.attach_money, Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Admin Actions
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2,
                      children: [
                        _buildActionCard(
                          'OptiSigns API Config',
                          'Configure API connection settings',
                          Icons.api,
                          Colors.blue,
                        ),
                        _buildActionCard(
                          'Screen Management',
                          'Control all digital screens',
                          Icons.tv,
                          Colors.green,
                        ),
                        _buildActionCard(
                          'User Management',
                          'Manage advertiser accounts',
                          Icons.people,
                          Colors.orange,
                        ),
                        _buildActionCard(
                          'System Monitoring',
                          'View performance metrics',
                          Icons.monitor_heart,
                          Colors.purple,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, String description, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Admin action implementation
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}