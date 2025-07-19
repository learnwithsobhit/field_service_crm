import 'package:flutter/material.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  String _selectedFilter = 'all';
  bool _showUnreadOnly = false;

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif_001',
      'title': 'EMERGENCY: Equipment Failure',
      'message': 'HVAC system at Downtown Office Building has completely failed. Customer requesting immediate response.',
      'type': 'emergency',
      'category': 'job',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'isRead': false,
      'jobId': 'JOB003',
      'clientName': 'Downtown Office Building',
      'priority': 'critical',
      'actions': ['Call Client', 'Accept Job', 'Send Technician'],
    },
    {
      'id': 'notif_002',
      'title': 'Low Stock Alert',
      'message': 'HVAC filters are running low (5 remaining). Consider restocking before next maintenance cycle.',
      'type': 'warning',
      'category': 'inventory',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': false,
      'itemSku': 'FM-STD-20',
      'currentStock': 5,
      'actions': ['Restock Now', 'View Item'],
    },
    {
      'id': 'notif_003',
      'title': 'Job Completed Successfully',
      'message': 'Quarterly pest control service at Green Valley Restaurant has been completed. Client satisfaction: 5/5 stars.',
      'type': 'success',
      'category': 'job',
      'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
      'isRead': true,
      'jobId': 'JOB001',
      'clientName': 'Green Valley Restaurant',
      'technicianName': 'Mike Johnson',
      'actions': ['View Report', 'Generate Invoice'],
    },
    {
      'id': 'notif_004',
      'title': 'Payment Received',
      'message': 'Payment of \$450.00 received from Tech Solutions Inc. for Invoice #INV-001.',
      'type': 'success',
      'category': 'payment',
      'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      'isRead': true,
      'amount': 450.00,
      'invoiceId': 'INV-001',
      'clientName': 'Tech Solutions Inc.',
      'actions': ['View Invoice', 'Send Receipt'],
    },
    {
      'id': 'notif_005',
      'title': 'Schedule Change Request',
      'message': 'Residential home owner has requested to reschedule tomorrow\'s appointment to next week.',
      'type': 'info',
      'category': 'schedule',
      'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
      'isRead': false,
      'jobId': 'JOB005',
      'clientName': 'Sarah Williams',
      'originalDate': '2024-01-17 10:00 AM',
      'requestedDate': '2024-01-24 10:00 AM',
      'actions': ['Approve Change', 'Contact Client', 'View Calendar'],
    },
    {
      'id': 'notif_006',
      'title': 'New Team Message',
      'message': 'Alex Chen: "Don\'t forget about the safety training session tomorrow at 9 AM in the main office."',
      'type': 'info',
      'category': 'team',
      'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
      'isRead': true,
      'senderName': 'Alex Chen',
      'senderRole': 'Team Lead',
      'actions': ['Reply', 'View Chat'],
    },
    {
      'id': 'notif_007',
      'title': 'System Maintenance',
      'message': 'Scheduled system maintenance will occur tonight from 2:00 AM to 4:00 AM. App may be temporarily unavailable.',
      'type': 'info',
      'category': 'system',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'maintenanceStart': '2024-01-16 02:00 AM',
      'maintenanceEnd': '2024-01-16 04:00 AM',
      'actions': ['Learn More'],
    },
    {
      'id': 'notif_008',
      'title': 'Route Optimization Available',
      'message': 'Your route for tomorrow can be optimized to save 45 minutes and 12 miles. Would you like to apply the suggested changes?',
      'type': 'info',
      'category': 'route',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      'isRead': false,
      'timeSaved': '45 minutes',
      'milesSaved': '12 miles',
      'actions': ['Apply Route', 'View Details', 'Dismiss'],
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    List<Map<String, dynamic>> filtered = _notifications;

    // Filter by category
    if (_selectedFilter != 'all') {
      filtered = filtered.where((notif) => notif['category'] == _selectedFilter).toList();
    }

    // Filter by read status
    if (_showUnreadOnly) {
      filtered = filtered.where((notif) => !notif['isRead']).toList();
    }

    // Sort by timestamp (newest first) and priority
    filtered.sort((a, b) {
      // Emergency notifications always go first
      if (a['type'] == 'emergency' && b['type'] != 'emergency') return -1;
      if (b['type'] == 'emergency' && a['type'] != 'emergency') return 1;
      
      // Then by unread status
      if (!a['isRead'] && b['isRead']) return -1;
      if (!b['isRead'] && a['isRead']) return 1;
      
      // Finally by timestamp
      return b['timestamp'].compareTo(a['timestamp']);
    });

    return filtered;
  }

  int get _unreadCount => _notifications.where((notif) => !notif['isRead']).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Notifications'),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark All Read'),
            ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'settings', child: Text('Notification Settings')),
              const PopupMenuItem(value: 'clear_read', child: Text('Clear Read Notifications')),
              const PopupMenuItem(value: 'export', child: Text('Export Notifications')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Category Filters
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip('All', 'all'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Jobs', 'job'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Inventory', 'inventory'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Payments', 'payment'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Team', 'team'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Schedule', 'schedule'),
                      const SizedBox(width: 8),
                      _buildFilterChip('System', 'system'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Show Unread Toggle
                Row(
                  children: [
                    Switch(
                      value: _showUnreadOnly,
                      onChanged: (value) {
                        setState(() {
                          _showUnreadOnly = value;
                        });
                      },
                      activeColor: const Color(0xFF14B8A6),
                    ),
                    const SizedBox(width: 8),
                    const Text('Show unread only'),
                    const Spacer(),
                    Text(
                      '${_filteredNotifications.length} notifications',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Notifications List
          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _refreshNotifications,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _filteredNotifications[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildNotificationCard(notification),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NotificationSettingsScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF14B8A6),
        child: const Icon(Icons.settings, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    final count = value == 'all' 
        ? _notifications.length 
        : _notifications.where((n) => n['category'] == value).length;
    
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: const Color(0xFF14B8A6).withOpacity(0.2),
      checkmarkColor: const Color(0xFF14B8A6),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final Color typeColor = _getTypeColor(notification['type']);
    final IconData typeIcon = _getTypeIcon(notification['type']);
    final bool isUnread = !notification['isRead'];

    return Card(
      elevation: isUnread ? 4 : 1,
      color: isUnread ? Colors.white : Colors.grey[50],
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      typeIcon,
                      color: typeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification['title'],
                                style: TextStyle(
                                  fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                  fontSize: 16,
                                  color: notification['type'] == 'emergency' ? Colors.red : null,
                                ),
                              ),
                            ),
                            if (isUnread)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF14B8A6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getCategoryLabel(notification['category']),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatTimestamp(notification['timestamp']),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Message
              Text(
                notification['message'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
              
              // Additional Info
              if (notification['clientName'] != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.business, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      notification['clientName'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              
              // Actions
              if (notification['actions'] != null && notification['actions'].isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: notification['actions'].take(3).map<Widget>((action) {
                    final isPrimary = notification['actions'].indexOf(action) == 0;
                    return SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        onPressed: () => _handleAction(notification, action),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isPrimary ? const Color(0xFF14B8A6) : null,
                          foregroundColor: isPrimary ? Colors.white : const Color(0xFF14B8A6),
                          side: BorderSide(color: const Color(0xFF14B8A6)),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: Size.zero,
                        ),
                        child: Text(
                          action,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _showUnreadOnly ? Icons.mark_email_read : Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _showUnreadOnly ? 'No unread notifications' : 'No notifications',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _showUnreadOnly 
                ? 'You\'re all caught up!' 
                : 'You\'ll receive notifications here',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getTypeColor(String type) {
    switch (type) {
      case 'emergency':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'success':
        return Colors.green;
      case 'info':
      default:
        return Colors.blue;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'emergency':
        return Icons.emergency;
      case 'warning':
        return Icons.warning;
      case 'success':
        return Icons.check_circle;
      case 'info':
      default:
        return Icons.info;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'job':
        return 'JOB ALERT';
      case 'inventory':
        return 'INVENTORY';
      case 'payment':
        return 'PAYMENT';
      case 'team':
        return 'TEAM MESSAGE';
      case 'schedule':
        return 'SCHEDULE';
      case 'system':
        return 'SYSTEM';
      case 'route':
        return 'ROUTE';
      default:
        return 'NOTIFICATION';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  // Action handlers
  void _handleNotificationTap(Map<String, dynamic> notification) {
    if (!notification['isRead']) {
      setState(() {
        notification['isRead'] = true;
      });
    }

    // Navigate based on notification type
    switch (notification['category']) {
      case 'job':
        // Navigate to job details
        break;
      case 'inventory':
        // Navigate to inventory
        break;
      case 'payment':
        // Navigate to payment details
        break;
      default:
        // Show detailed notification view
        _showNotificationDetail(notification);
    }
  }

  void _handleAction(Map<String, dynamic> notification, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Action: $action')),
    );
  }

  void _showNotificationDetail(Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => NotificationDetailSheet(notification: notification),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'settings':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NotificationSettingsScreen(),
          ),
        );
        break;
      case 'clear_read':
        setState(() {
          _notifications.removeWhere((notif) => notif['isRead']);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Read notifications cleared')),
        );
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export functionality coming soon')),
        );
        break;
    }
  }

  Future<void> _refreshNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // In a real app, you would fetch new notifications from the server
    });
  }
}

// Notification Detail Sheet
class NotificationDetailSheet extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationDetailSheet({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification['message'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Additional details would go here
                      _buildDetailRow('Category', _getCategoryLabel(notification['category'])),
                      _buildDetailRow('Type', notification['type'].toUpperCase()),
                      _buildDetailRow('Time', notification['timestamp'].toString()),
                      
                      if (notification['clientName'] != null)
                        _buildDetailRow('Client', notification['clientName']),
                      if (notification['jobId'] != null)
                        _buildDetailRow('Job ID', notification['jobId']),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'job':
        return 'Job Alert';
      case 'inventory':
        return 'Inventory';
      case 'payment':
        return 'Payment';
      case 'team':
        return 'Team Message';
      case 'schedule':
        return 'Schedule';
      case 'system':
        return 'System';
      case 'route':
        return 'Route';
      default:
        return 'Notification';
    }
  }
}

// Notification Settings Screen
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _jobAlerts = true;
  bool _inventoryAlerts = true;
  bool _paymentAlerts = true;
  bool _teamMessages = true;
  bool _systemUpdates = false;
  bool _emergencyAlerts = true;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '08:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notification Types
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notification Types',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingToggle(
                    'Emergency Alerts',
                    'Critical notifications that require immediate attention',
                    _emergencyAlerts,
                    (value) => setState(() => _emergencyAlerts = value),
                    Colors.red,
                  ),
                  _buildSettingToggle(
                    'Job Alerts',
                    'Notifications about job updates, assignments, and completions',
                    _jobAlerts,
                    (value) => setState(() => _jobAlerts = value),
                  ),
                  _buildSettingToggle(
                    'Inventory Alerts',
                    'Low stock warnings and inventory updates',
                    _inventoryAlerts,
                    (value) => setState(() => _inventoryAlerts = value),
                  ),
                  _buildSettingToggle(
                    'Payment Alerts',
                    'Payment confirmations and invoice updates',
                    _paymentAlerts,
                    (value) => setState(() => _paymentAlerts = value),
                  ),
                  _buildSettingToggle(
                    'Team Messages',
                    'Messages from team members and announcements',
                    _teamMessages,
                    (value) => setState(() => _teamMessages = value),
                  ),
                  _buildSettingToggle(
                    'System Updates',
                    'App updates and maintenance notifications',
                    _systemUpdates,
                    (value) => setState(() => _systemUpdates = value),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Delivery Methods
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Methods',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingToggle(
                    'Push Notifications',
                    'Receive notifications on your device',
                    _pushNotifications,
                    (value) => setState(() => _pushNotifications = value),
                  ),
                  _buildSettingToggle(
                    'Email Notifications',
                    'Receive notifications via email',
                    _emailNotifications,
                    (value) => setState(() => _emailNotifications = value),
                  ),
                  _buildSettingToggle(
                    'SMS Notifications',
                    'Receive emergency alerts via SMS',
                    _smsNotifications,
                    (value) => setState(() => _smsNotifications = value),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quiet Hours
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quiet Hours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Set hours when you don\'t want to receive non-emergency notifications',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Start Time'),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _selectTime(context, true),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(_quietHoursStart),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('End Time'),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _selectTime(context, false),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(_quietHoursEnd),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, [
    Color? accentColor,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: accentColor ?? const Color(0xFF14B8A6),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (picked != null) {
      setState(() {
        final timeString = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        if (isStartTime) {
          _quietHoursStart = timeString;
        } else {
          _quietHoursEnd = timeString;
        }
      });
    }
  }

  void _saveSettings() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification settings saved')),
    );
  }
} 