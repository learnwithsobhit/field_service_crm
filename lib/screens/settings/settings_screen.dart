import 'package:flutter/material.dart';
import '../profile/edit_profile_screen.dart';
import 'notification_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // User Preferences
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _locationTracking = true;
  bool _autoBackup = true;
  bool _darkMode = false;
  bool _offlineMode = false;

  // Business Settings
  String _defaultCurrency = 'USD';
  String _timeZone = 'America/New_York';
  String _taxRate = '8.25';
  String _businessName = 'Field Service Pro';
  String _businessAddress = '123 Business St, New York, NY';
  String _businessPhone = '+1 (555) 123-4567';
  String _businessEmail = 'contact@fieldservicepro.com';

  // App Settings
  String _mapProvider = 'Google Maps';
  String _language = 'English';
  String _dateFormat = 'MM/DD/YYYY';
  String _timeFormat = '12 Hour';
  double _mapZoomLevel = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelp,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Profile Section
          _buildUserProfileSection(),
          const SizedBox(height: 24),

          // Notifications Section
          _buildNotificationsSection(),
          const SizedBox(height: 24),

          // Location & Privacy Section
          _buildLocationPrivacySection(),
          const SizedBox(height: 24),

          // Business Settings Section
          _buildBusinessSettingsSection(),
          const SizedBox(height: 24),

          // App Preferences Section
          _buildAppPreferencesSection(),
          const SizedBox(height: 24),

          // Data & Storage Section
          _buildDataStorageSection(),
          const SizedBox(height: 24),

          // Security Section
          _buildSecuritySection(),
          const SizedBox(height: 24),

          // Support & About Section
          _buildSupportAboutSection(),
          const SizedBox(height: 24),

          // Danger Zone
          _buildDangerZoneSection(),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Color(0xFF14B8A6)),
                const SizedBox(width: 8),
                const Text(
                  'User Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF14B8A6),
                  child: const Text(
                    'SR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sam Rodriguez',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'Field Service Manager',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'sam.rodriguez@company.com',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _editProfile,
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications, color: Color(0xFF14B8A6)),
                const SizedBox(width: 8),
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              'Push Notifications',
              'Receive notifications on your device',
              _pushNotifications,
              (value) => setState(() => _pushNotifications = value),
            ),
            _buildSwitchTile(
              'Email Notifications',
              'Receive notifications via email',
              _emailNotifications,
              (value) => setState(() => _emailNotifications = value),
            ),
            _buildSwitchTile(
              'SMS Notifications',
              'Receive critical alerts via SMS',
              _smsNotifications,
              (value) => setState(() => _smsNotifications = value),
            ),
            ListTile(
              title: const Text('Notification Settings'),
              subtitle: const Text('Customize notification types and schedules'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _openNotificationSettings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationPrivacySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF14B8A6)),
                const SizedBox(width: 8),
                const Text(
                  'Location & Privacy',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              'Location Tracking',
              'Allow app to track your location for job routing',
              _locationTracking,
              (value) => setState(() => _locationTracking = value),
            ),
            ListTile(
              title: const Text('Location History'),
              subtitle: const Text('View and manage your location data'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _openLocationHistory,
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              subtitle: const Text('Learn how we handle your data'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _openPrivacyPolicy,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.business, color: Color(0xFF14B8A6)),
                const SizedBox(width: 8),
                const Text(
                  'Business Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsTile(
              'Business Name',
              _businessName,
              () => _editBusinessSetting('Business Name', _businessName, (value) => _businessName = value),
            ),
            _buildSettingsTile(
              'Business Address',
              _businessAddress,
              () => _editBusinessSetting('Business Address', _businessAddress, (value) => _businessAddress = value),
            ),
            _buildSettingsTile(
              'Business Phone',
              _businessPhone,
              () => _editBusinessSetting('Business Phone', _businessPhone, (value) => _businessPhone = value),
            ),
            _buildSettingsTile(
              'Business Email',
              _businessEmail,
              () => _editBusinessSetting('Business Email', _businessEmail, (value) => _businessEmail = value),
            ),
            _buildSettingsTile(
              'Default Currency',
              _defaultCurrency,
              () => _selectCurrency(),
            ),
            _buildSettingsTile(
              'Tax Rate (%)',
              _taxRate,
              () => _editBusinessSetting('Tax Rate', _taxRate, (value) => _taxRate = value),
            ),
            _buildSettingsTile(
              'Time Zone',
              _timeZone,
              () => _selectTimeZone(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppPreferencesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, color: Color(0xFF14B8A6)),
                const SizedBox(width: 8),
                const Text(
                  'App Preferences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              'Dark Mode',
              'Use dark theme throughout the app',
              _darkMode,
              (value) => setState(() => _darkMode = value),
            ),
            _buildSwitchTile(
              'Offline Mode',
              'Cache data for offline access',
              _offlineMode,
              (value) => setState(() => _offlineMode = value),
            ),
            _buildSettingsTile(
              'Language',
              _language,
              () => _selectLanguage(),
            ),
            _buildSettingsTile(
              'Date Format',
              _dateFormat,
              () => _selectDateFormat(),
            ),
            _buildSettingsTile(
              'Time Format',
              _timeFormat,
              () => _selectTimeFormat(),
            ),
            _buildSettingsTile(
              'Map Provider',
              _mapProvider,
              () => _selectMapProvider(),
            ),
            ListTile(
              title: const Text('Default Map Zoom'),
              subtitle: Text('Level: ${_mapZoomLevel.toInt()}'),
              trailing: SizedBox(
                width: 150,
                child: Slider(
                  value: _mapZoomLevel,
                  min: 10,
                  max: 20,
                  divisions: 10,
                  activeColor: const Color(0xFF14B8A6),
                  onChanged: (value) => setState(() => _mapZoomLevel = value),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataStorageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storage, color: Color(0xFF14B8A6)),
                const SizedBox(width: 8),
                const Text(
                  'Data & Storage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              'Auto Backup',
              'Automatically backup data to cloud',
              _autoBackup,
              (value) => setState(() => _autoBackup = value),
            ),
            ListTile(
              title: const Text('Storage Usage'),
              subtitle: const Text('App is using 142 MB of storage'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _viewStorageUsage,
            ),
            ListTile(
              title: const Text('Clear Cache'),
              subtitle: const Text('Free up space by clearing temporary files'),
              trailing: const Icon(Icons.clear_all),
              onTap: _clearCache,
            ),
            ListTile(
              title: const Text('Export Data'),
              subtitle: const Text('Export your data for backup or migration'),
              trailing: const Icon(Icons.download),
              onTap: _exportData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.security, color: Color(0xFF14B8A6)),
                const SizedBox(width: 8),
                const Text(
                  'Security',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Change Password'),
              subtitle: const Text('Update your account password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _changePassword,
            ),
            ListTile(
              title: const Text('Two-Factor Authentication'),
              subtitle: const Text('Add an extra layer of security'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _setup2FA,
            ),
            ListTile(
              title: const Text('Active Sessions'),
              subtitle: const Text('Manage your logged-in devices'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _viewActiveSessions,
            ),
            ListTile(
              title: const Text('App Lock'),
              subtitle: const Text('Require authentication to open app'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _configureAppLock,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.help, color: Color(0xFF14B8A6)),
                const SizedBox(width: 8),
                const Text(
                  'Support & About',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Help Center'),
              subtitle: const Text('Get help and find answers'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _openHelpCenter,
            ),
            ListTile(
              title: const Text('Contact Support'),
              subtitle: const Text('Get in touch with our support team'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _contactSupport,
            ),
            ListTile(
              title: const Text('Send Feedback'),
              subtitle: const Text('Help us improve the app'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _sendFeedback,
            ),
            ListTile(
              title: const Text('Rate the App'),
              subtitle: const Text('Leave a review on the app store'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _rateApp,
            ),
            ListTile(
              title: const Text('About'),
              subtitle: const Text('Version 1.0.0 • Built with Flutter'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showAbout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerZoneSection() {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.red[700]),
                const SizedBox(width: 8),
                Text(
                  'Danger Zone',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                'Reset All Settings',
                style: TextStyle(color: Colors.red[700]),
              ),
              subtitle: const Text('Reset app to default settings'),
              trailing: Icon(Icons.refresh, color: Colors.red[700]),
              onTap: _resetSettings,
            ),
            ListTile(
              title: Text(
                'Clear All Data',
                style: TextStyle(color: Colors.red[700]),
              ),
              subtitle: const Text('Permanently delete all app data'),
              trailing: Icon(Icons.delete_forever, color: Colors.red[700]),
              onTap: _clearAllData,
            ),
            ListTile(
              title: Text(
                'Delete Account',
                style: TextStyle(color: Colors.red[700]),
              ),
              subtitle: const Text('Permanently delete your account'),
              trailing: Icon(Icons.person_remove, color: Colors.red[700]),
              onTap: _deleteAccount,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF14B8A6),
      ),
    );
  }

  Widget _buildSettingsTile(String title, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Action handlers
  void _editProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );
  }

  void _openNotificationSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NotificationSettingsScreen(),
      ),
    );
  }

  void _openLocationHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location history screen coming soon')),
    );
  }

  void _openPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy policy screen coming soon')),
    );
  }

  void _editBusinessSetting(String title, String currentValue, Function(String) onUpdate) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: currentValue);
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  onUpdate(controller.text);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title updated')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _selectCurrency() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Currency'),
        children: ['USD', 'EUR', 'GBP', 'CAD', 'AUD'].map((currency) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                _defaultCurrency = currency;
              });
              Navigator.pop(context);
            },
            child: Text(currency),
          );
        }).toList(),
      ),
    );
  }

  void _selectTimeZone() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Time Zone'),
        children: [
          'America/New_York',
          'America/Chicago',
          'America/Denver',
          'America/Los_Angeles',
          'Europe/London',
          'Europe/Paris',
        ].map((tz) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                _timeZone = tz;
              });
              Navigator.pop(context);
            },
            child: Text(tz.replaceAll('_', ' ')),
          );
        }).toList(),
      ),
    );
  }

  void _selectLanguage() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Language'),
        children: ['English', 'Spanish', 'French', 'German', 'Italian'].map((lang) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                _language = lang;
              });
              Navigator.pop(context);
            },
            child: Text(lang),
          );
        }).toList(),
      ),
    );
  }

  void _selectDateFormat() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Date Format'),
        children: ['MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'].map((format) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                _dateFormat = format;
              });
              Navigator.pop(context);
            },
            child: Text(format),
          );
        }).toList(),
      ),
    );
  }

  void _selectTimeFormat() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Time Format'),
        children: ['12 Hour', '24 Hour'].map((format) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                _timeFormat = format;
              });
              Navigator.pop(context);
            },
            child: Text(format),
          );
        }).toList(),
      ),
    );
  }

  void _selectMapProvider() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Map Provider'),
        children: ['Google Maps', 'Apple Maps', 'OpenStreetMap'].map((provider) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                _mapProvider = provider;
              });
              Navigator.pop(context);
            },
            child: Text(provider),
          );
        }).toList(),
      ),
    );
  }

  void _viewStorageUsage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Storage usage details coming soon')),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear temporary files and free up space. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data export started...')),
    );
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change password screen coming soon')),
    );
  }

  void _setup2FA() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('2FA setup screen coming soon')),
    );
  }

  void _viewActiveSessions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Active sessions screen coming soon')),
    );
  }

  void _configureAppLock() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('App lock configuration coming soon')),
    );
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help center coming soon')),
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Support contact screen coming soon')),
    );
  }

  void _sendFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback form coming soon')),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Redirecting to app store...')),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Field Service CRM',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 Field Service Pro. All rights reserved.',
      children: [
        const SizedBox(height: 16),
        const Text('A comprehensive field service management solution built with Flutter.'),
      ],
    );
  }

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help documentation coming soon')),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('This will reset all settings to their default values. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _clearAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('This will permanently delete all your data including jobs, clients, and settings. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This will permanently delete your account and all associated data. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion process started')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Account', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Placeholder screens 