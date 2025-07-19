import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardWidgetsScreen extends StatefulWidget {
  const DashboardWidgetsScreen({super.key});

  @override
  State<DashboardWidgetsScreen> createState() => _DashboardWidgetsScreenState();
}

class _DashboardWidgetsScreenState extends State<DashboardWidgetsScreen> {
  String _selectedRole = 'technician';
  bool _showWeather = true;
  bool _showQuickActions = true;
  bool _showRecentJobs = true;
  bool _showTeamStatus = true;
  bool _showInventoryAlerts = true;
  bool _showRevenueChart = true;

  final List<String> _roles = [
    'technician',
    'supervisor',
    'manager',
    'dispatcher',
    'administrator'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Widgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveWidgetSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Role Selection
            _buildRoleSelection(),
            const SizedBox(height: 24),
            
            // Widget Toggles
            _buildWidgetToggles(),
            const SizedBox(height: 24),
            
            // Preview
            _buildWidgetPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Your Role',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Role',
              ),
              items: _roles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetToggles() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Widget Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildToggleTile('Weather Widget', _showWeather, (value) {
              setState(() => _showWeather = value);
            }),
            _buildToggleTile('Quick Actions', _showQuickActions, (value) {
              setState(() => _showQuickActions = value);
            }),
            _buildToggleTile('Recent Jobs', _showRecentJobs, (value) {
              setState(() => _showRecentJobs = value);
            }),
            _buildToggleTile('Team Status', _showTeamStatus, (value) {
              setState(() => _showTeamStatus = value);
            }),
            _buildToggleTile('Inventory Alerts', _showInventoryAlerts, (value) {
              setState(() => _showInventoryAlerts = value);
            }),
            _buildToggleTile('Revenue Chart', _showRevenueChart, (value) {
              setState(() => _showRevenueChart = value);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text('Show $title on dashboard'),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildWidgetPreview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_showWeather) _buildWeatherWidget(),
            if (_showQuickActions) _buildQuickActionsWidget(),
            if (_showRecentJobs) _buildRecentJobsWidget(),
            if (_showTeamStatus) _buildTeamStatusWidget(),
            if (_showInventoryAlerts) _buildInventoryAlertsWidget(),
            if (_showRevenueChart) _buildRevenueChartWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.wb_sunny, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sunny',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '72°F • Perfect for field work',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            '72°',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.add_task,
                  label: 'New Job',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.camera_alt,
                  label: 'Photo',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.location_on,
                  label: 'Location',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentJobsWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Jobs',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildJobItem('AC Repair - Downtown', 'In Progress', Colors.orange),
          _buildJobItem('Plumbing - Westside', 'Completed', Colors.green),
          _buildJobItem('Electrical - Eastside', 'Scheduled', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildJobItem(String title, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildTeamStatusWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Team Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTeamMember('John', 'Online', Colors.green),
              const SizedBox(width: 8),
              _buildTeamMember('Sarah', 'Busy', Colors.orange),
              const SizedBox(width: 8),
              _buildTeamMember('Mike', 'Offline', Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, String status, Color statusColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: statusColor,
              radius: 16,
              child: Text(
                name[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            Text(
              status,
              style: TextStyle(
                fontSize: 10,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryAlertsWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Low Stock Alert',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const Text(
                  '3 items need restocking',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('View'),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChartWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week\'s Revenue',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${NumberFormat('#,###').format(15420)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Text(
                      '+12% from last week',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveWidgetSettings() {
    // Save widget settings to local storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Widget settings saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
} 