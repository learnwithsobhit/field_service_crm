import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'activity_history_screen.dart';
import '../settings/settings_screen.dart';
import '../settings/notification_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Current user data - this would normally come from state management
  final Map<String, dynamic> _currentUser = {
    'id': 'USR001',
    'name': 'Sam Rodriguez',
    'email': 'sam.rodriguez@fieldcrm.com',
    'phone': '+1 (555) 123-4567',
    'role': 'Operations Manager',
    'department': 'Field Operations',
    'avatar': 'SR',
    'joinDate': '2022-03-15',
    'location': 'Downtown Office',
    'timezone': 'PST (UTC-8)',
    'employeeId': 'EMP-001',
    'supervisor': 'Lisa Chen',
    'team': 'Operations Team Alpha',
    'certifications': [
      'HVAC Certified',
      'Safety Management',
      'Team Leadership',
      'Project Management'
    ],
    'skills': [
      'Team Management',
      'Customer Relations',
      'Quality Control',
      'Route Optimization',
      'Safety Protocols'
    ],
    'stats': {
      'jobsManaged': 156,
      'teamSize': 8,
      'customerSatisfaction': 4.8,
      'efficiency': 94,
    },
    'recentActivity': [
      {'action': 'Assigned job to Maya Chen', 'time': '2 hours ago'},
      {'action': 'Approved inventory request', 'time': '4 hours ago'},
      {'action': 'Updated team schedule', 'time': '6 hours ago'},
      {'action': 'Completed safety inspection', 'time': '1 day ago'},
    ],
    'preferences': {
      'notifications': true,
      'emailDigest': true,
      'pushNotifications': true,
      'darkMode': false,
      'language': 'English',
      'autoAssign': true,
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(),
                _buildStatsSection(),
                _buildQuickActions(),
                _buildActivitySection(),
                _buildSettingsSection(),
                _buildDangerZone(),
                const SizedBox(height: 100), // Bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF14B8A6),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          _currentUser['name'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40), // Space for status bar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Text(
                    _currentUser['avatar'],
                    style: const TextStyle(
                      color: Color(0xFF14B8A6),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _currentUser['role'],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: _editProfile,
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: _openSettings,
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.badge, 'Employee ID', _currentUser['employeeId']),
          _buildInfoRow(Icons.business, 'Department', _currentUser['department']),
          _buildInfoRow(Icons.location_on, 'Location', _currentUser['location']),
          _buildInfoRow(Icons.supervisor_account, 'Supervisor', _currentUser['supervisor']),
          _buildInfoRow(Icons.group, 'Team', _currentUser['team']),
          _buildInfoRow(Icons.calendar_today, 'Join Date', _currentUser['joinDate']),
          _buildInfoRow(Icons.access_time, 'Timezone', _currentUser['timezone']),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF14B8A6)),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Stats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Jobs Managed',
                  '${_currentUser['stats']['jobsManaged']}',
                  Icons.work,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Team Size',
                  '${_currentUser['stats']['teamSize']}',
                  Icons.group,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Satisfaction',
                  '${_currentUser['stats']['customerSatisfaction']}/5.0',
                  Icons.star,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Efficiency',
                  '${_currentUser['stats']['efficiency']}%',
                  Icons.trending_up,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
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
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'View Schedule',
                  Icons.calendar_today,
                  Colors.blue,
                  () => _viewSchedule(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  'Team Chat',
                  Icons.chat,
                  Colors.green,
                  () => _openTeamChat(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  'Reports',
                  Icons.assessment,
                  Colors.orange,
                  () => _viewReports(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivitySection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _viewAllActivity,
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _currentUser['recentActivity'].length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final activity = _currentUser['recentActivity'][index];
                return ListTile(
                  leading: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFF14B8A6),
                    child: Icon(Icons.history, color: Colors.white, size: 16),
                  ),
                  title: Text(
                    activity['action'],
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    activity['time'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings & Preferences',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _buildSettingsTile(
                  'Notifications',
                  'Manage notification preferences',
                  Icons.notifications,
                  () => _manageNotifications(),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  'Privacy',
                  'Privacy and security settings',
                  Icons.privacy_tip,
                  () => _managePrivacy(),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  'Account',
                  'Account information and preferences',
                  Icons.account_circle,
                  () => _manageAccount(),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  'Help & Support',
                  'Get help and contact support',
                  Icons.help,
                  () => _getHelp(),
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  'About',
                  'App version and legal information',
                  Icons.info,
                  () => _showAbout(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF14B8A6)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDangerZone() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _buildDangerTile(
                  'Change Password',
                  'Update your account password',
                  Icons.lock,
                  Colors.orange,
                  () => _changePassword(),
                ),
                const Divider(height: 1),
                _buildDangerTile(
                  'Sign Out',
                  'Sign out of your account',
                  Icons.logout,
                  Colors.red,
                  () => _signOut(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerTile(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
      onTap: onTap,
    );
  }

  // Action methods
  void _editProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _viewSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening schedule view...')),
    );
  }

  void _openTeamChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening team chat...')),
    );
  }

  void _viewReports() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening reports...')),
    );
  }

  void _viewAllActivity() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ActivityHistoryScreen(),
      ),
    );
  }

  void _manageNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NotificationSettingsScreen(),
      ),
    );
  }

  void _managePrivacy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening privacy settings...')),
    );
  }

  void _manageAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening account settings...')),
    );
  }

  void _getHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening help center...')),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Field Service CRM',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF14B8A6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.construction,
          color: Colors.white,
          size: 30,
        ),
      ),
      children: [
        const Text('A comprehensive field service management solution.'),
      ],
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Text('Password change functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to welcome screen
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

// Placeholder screens for navigation

 