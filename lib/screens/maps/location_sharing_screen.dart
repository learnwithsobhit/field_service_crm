import 'package:flutter/material.dart';

class LocationSharingScreen extends StatefulWidget {
  const LocationSharingScreen({super.key});

  @override
  State<LocationSharingScreen> createState() => _LocationSharingScreenState();
}

class _LocationSharingScreenState extends State<LocationSharingScreen> {
  bool _isLocationSharingEnabled = true;
  bool _shareWithTeam = true;
  bool _shareWithDispatcher = true;
  bool _shareWithManager = false;
  bool _emergencySharingEnabled = true;
  bool _shareLocationHistory = false;
  
  String _sharingDuration = '8_hours';
  String _sharingAccuracy = 'high';
  String _visibilityLevel = 'work_hours';
  
  final List<String> _durations = [
    '1_hour',
    '4_hours', 
    '8_hours',
    '24_hours',
    'until_stopped',
  ];
  
  final List<String> _accuracyLevels = [
    'low',
    'medium', 
    'high',
  ];
  
  final List<String> _visibilityOptions = [
    'always',
    'work_hours',
    'active_jobs',
    'emergency_only',
  ];

  final List<Map<String, dynamic>> _activeShares = [
    {
      'id': 'share_001',
      'recipient': 'HVAC Maintenance Team',
      'type': 'team',
      'startTime': DateTime.now().subtract(const Duration(hours: 2)),
      'duration': '8 hours',
      'status': 'active',
    },
    {
      'id': 'share_002',
      'recipient': 'Maria Garcia (Dispatcher)',
      'type': 'individual',
      'startTime': DateTime.now().subtract(const Duration(minutes: 30)),
      'duration': '4 hours',
      'status': 'active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Sharing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelp,
            tooltip: 'Help',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Sharing Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isLocationSharingEnabled ? Icons.location_on : Icons.location_off,
                          color: _isLocationSharingEnabled ? Colors.green : Colors.grey,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Location Sharing',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _isLocationSharingEnabled
                                  ? 'Your location is being shared'
                                  : 'Location sharing is disabled',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isLocationSharingEnabled,
                          onChanged: (value) {
                            setState(() {
                              _isLocationSharingEnabled = value;
                            });
                            _showLocationSharingDialog(value);
                          },
                          activeColor: const Color(0xFF14B8A6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_isLocationSharingEnabled) ...[
              // Sharing Settings
              _buildSectionHeader('Sharing Settings'),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    _buildSettingTile(
                      'Share with Team',
                      'Allow team members to see your location',
                      _shareWithTeam,
                      (value) => setState(() => _shareWithTeam = value),
                      Icons.group,
                    ),
                    _buildSettingTile(
                      'Share with Dispatcher',
                      'Allow dispatcher to track your location',
                      _shareWithDispatcher,
                      (value) => setState(() => _shareWithDispatcher = value),
                      Icons.admin_panel_settings,
                    ),
                    _buildSettingTile(
                      'Share with Manager',
                      'Allow manager to view your location',
                      _shareWithManager,
                      (value) => setState(() => _shareWithManager = value),
                      Icons.supervisor_account,
                    ),
                    _buildSettingTile(
                      'Emergency Sharing',
                      'Automatically share location during emergencies',
                      _emergencySharingEnabled,
                      (value) => setState(() => _emergencySharingEnabled = value),
                      Icons.emergency,
                      isImportant: true,
                    ),
                    _buildSettingTile(
                      'Share Location History',
                      'Include recent location history in shares',
                      _shareLocationHistory,
                      (value) => setState(() => _shareLocationHistory = value),
                      Icons.history,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Duration & Accuracy Settings
              _buildSectionHeader('Sharing Duration & Accuracy'),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.schedule),
                      title: const Text('Default Duration'),
                      subtitle: Text(_getDurationLabel(_sharingDuration)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showDurationPicker(),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.gps_fixed),
                      title: const Text('Location Accuracy'),
                      subtitle: Text(_getAccuracyLabel(_sharingAccuracy)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showAccuracyPicker(),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.visibility),
                      title: const Text('Visibility'),
                      subtitle: Text(_getVisibilityLabel(_visibilityLevel)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showVisibilityPicker(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Active Shares
              if (_activeShares.isNotEmpty) ...[
                _buildSectionHeader('Active Shares (${_activeShares.length})'),
                const SizedBox(height: 8),
                ...(_activeShares.map((share) => _buildActiveShareCard(share)).toList()),
                const SizedBox(height: 24),
              ],

              // Quick Share Actions
              _buildSectionHeader('Quick Actions'),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.share_location, color: Colors.blue),
                      ),
                      title: const Text('Share Current Location'),
                      subtitle: const Text('Send your current location to someone'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _shareCurrentLocation(),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.emergency_share, color: Colors.orange),
                      ),
                      title: const Text('Emergency Share'),
                      subtitle: const Text('Immediately share location with emergency contacts'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _emergencyShare(),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.group_add, color: Colors.green),
                      ),
                      title: const Text('Share with Team'),
                      subtitle: const Text('Start sharing with your entire team'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _shareWithTeamAction(),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF14B8A6),
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon, {
    bool isImportant = false,
  }) {
    return Column(
      children: [
        SwitchListTile(
          secondary: Icon(
            icon,
            color: isImportant ? Colors.red : const Color(0xFF14B8A6),
          ),
          title: Row(
            children: [
              Expanded(child: Text(title)),
              if (isImportant)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Important',
                    style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          subtitle: Text(subtitle),
          value: value,
          onChanged: onChanged,
          activeColor: isImportant ? Colors.red : const Color(0xFF14B8A6),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildActiveShareCard(Map<String, dynamic> share) {
    final startTime = share['startTime'] as DateTime;
    final timeAgo = _getTimeAgo(startTime);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            share['type'] == 'team' ? Icons.group : Icons.person,
            color: Colors.green,
          ),
        ),
        title: Text(share['recipient']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration: ${share['duration']}'),
            Text('Started: $timeAgo', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleShareAction(action, share),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'stop', child: Text('Stop Sharing')),
            const PopupMenuItem(value: 'extend', child: Text('Extend Duration')),
            const PopupMenuItem(value: 'details', child: Text('View Details')),
          ],
        ),
      ),
    );
  }

  String _getDurationLabel(String duration) {
    switch (duration) {
      case '1_hour': return '1 Hour';
      case '4_hours': return '4 Hours';
      case '8_hours': return '8 Hours';
      case '24_hours': return '24 Hours';
      case 'until_stopped': return 'Until Manually Stopped';
      default: return duration;
    }
  }

  String _getAccuracyLabel(String accuracy) {
    switch (accuracy) {
      case 'low': return 'Low (City Level)';
      case 'medium': return 'Medium (Street Level)';
      case 'high': return 'High (Precise Location)';
      default: return accuracy;
    }
  }

  String _getVisibilityLabel(String visibility) {
    switch (visibility) {
      case 'always': return 'Always Visible';
      case 'work_hours': return 'During Work Hours Only';
      case 'active_jobs': return 'When On Active Jobs';
      case 'emergency_only': return 'Emergency Situations Only';
      default: return visibility;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  void _showLocationSharingDialog(bool enabled) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(enabled ? 'Enable Location Sharing' : 'Disable Location Sharing'),
        content: Text(
          enabled
            ? 'This will allow authorized team members to see your current location for work coordination and safety purposes.'
            : 'This will stop sharing your location with all authorized team members. Emergency sharing may still be active.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isLocationSharingEnabled = !enabled;
              });
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(enabled ? 'Location sharing enabled' : 'Location sharing disabled'),
                  backgroundColor: enabled ? Colors.green : Colors.grey,
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showDurationPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Default Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _durations.map((duration) {
            return RadioListTile<String>(
              title: Text(_getDurationLabel(duration)),
              value: duration,
              groupValue: _sharingDuration,
              onChanged: (value) {
                setState(() {
                  _sharingDuration = value!;
                });
                Navigator.pop(context);
              },
              activeColor: const Color(0xFF14B8A6),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAccuracyPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Location Accuracy'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _accuracyLevels.map((accuracy) {
            return RadioListTile<String>(
              title: Text(_getAccuracyLabel(accuracy)),
              value: accuracy,
              groupValue: _sharingAccuracy,
              onChanged: (value) {
                setState(() {
                  _sharingAccuracy = value!;
                });
                Navigator.pop(context);
              },
              activeColor: const Color(0xFF14B8A6),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showVisibilityPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Visibility Level'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _visibilityOptions.map((visibility) {
            return RadioListTile<String>(
              title: Text(_getVisibilityLabel(visibility)),
              value: visibility,
              groupValue: _visibilityLevel,
              onChanged: (value) {
                setState(() {
                  _visibilityLevel = value!;
                });
                Navigator.pop(context);
              },
              activeColor: const Color(0xFF14B8A6),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _shareCurrentLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share current location feature coming soon')),
    );
  }

  void _emergencyShare() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Location Share'),
        content: const Text('This will immediately share your location with all emergency contacts and dispatch. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emergency location shared with all contacts'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Share Emergency Location'),
          ),
        ],
      ),
    );
  }

  void _shareWithTeamAction() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing location with team...')),
    );
  }

  void _handleShareAction(String action, Map<String, dynamic> share) {
    switch (action) {
      case 'stop':
        _stopSharing(share);
        break;
      case 'extend':
        _extendSharing(share);
        break;
      case 'details':
        _showShareDetails(share);
        break;
    }
  }

  void _stopSharing(Map<String, dynamic> share) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Sharing'),
        content: Text('Stop sharing your location with ${share['recipient']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _activeShares.removeWhere((s) => s['id'] == share['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Stopped sharing with ${share['recipient']}')),
              );
            },
            child: const Text('Stop Sharing'),
          ),
        ],
      ),
    );
  }

  void _extendSharing(Map<String, dynamic> share) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Extended sharing with ${share['recipient']}')),
    );
  }

  void _showShareDetails(Map<String, dynamic> share) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sharing with ${share['recipient']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${share['type']}'),
            Text('Duration: ${share['duration']}'),
            Text('Started: ${share['startTime']}'),
            Text('Status: ${share['status']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Sharing Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Location sharing allows authorized team members to see your current location for work coordination and safety purposes.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('Key Features:'),
              SizedBox(height: 8),
              Text('• Share with specific team members or groups'),
              Text('• Set automatic duration limits'),
              Text('• Control accuracy level'),
              Text('• Emergency sharing capabilities'),
              Text('• Work hours visibility controls'),
              SizedBox(height: 16),
              Text('Your privacy is protected through granular controls and visibility settings.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
} 