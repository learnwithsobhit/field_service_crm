import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  String _selectedDateRange = 'last_30_days';
  bool _isLoading = false;

  final List<String> _activityFilters = [
    'all',
    'jobs',
    'communication',
    'inventory',
    'settings',
    'reports',
  ];

  final List<String> _dateRanges = [
    'today',
    'last_7_days',
    'last_30_days',
    'last_90_days',
    'custom',
  ];

  final List<Map<String, dynamic>> _activities = [
    {
      'id': 'activity_001',
      'type': 'job_completed',
      'category': 'jobs',
      'title': 'Completed Job: Quarterly Pest Control',
      'description': 'Successfully completed pest control service at Green Valley Restaurant',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': Icons.check_circle,
      'iconColor': Colors.green,
      'metadata': {
        'jobId': 'JOB001',
        'client': 'Green Valley Restaurant',
        'duration': '1h 30m',
        'rating': 5.0,
      }
    },
    {
      'id': 'activity_002',
      'type': 'message_sent',
      'category': 'communication',
      'title': 'Sent Team Message',
      'description': 'Posted update in HVAC Maintenance Team chat about equipment arrival',
      'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
      'icon': Icons.message,
      'iconColor': Colors.blue,
      'metadata': {
        'chatId': 'team_hvac',
        'messageLength': 45,
        'attachments': 1,
      }
    },
    {
      'id': 'activity_003',
      'type': 'inventory_updated',
      'category': 'inventory',
      'title': 'Updated Inventory',
      'description': 'Added 50 HVAC filters to stock after delivery',
      'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      'icon': Icons.inventory,
      'iconColor': const Color(0xFF14B8A6),
      'metadata': {
        'itemSku': 'FM-STD-20',
        'quantity': 50,
        'action': 'stock_in',
      }
    },
    {
      'id': 'activity_004',
      'type': 'settings_changed',
      'category': 'settings',
      'title': 'Updated Profile Settings',
      'description': 'Changed notification preferences and updated emergency contact',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.settings,
      'iconColor': Colors.grey,
      'metadata': {
        'settingsChanged': ['notifications', 'emergency_contact'],
      }
    },
    {
      'id': 'activity_005',
      'type': 'job_started',
      'category': 'jobs',
      'title': 'Started Job: HVAC Maintenance',
      'description': 'Began HVAC maintenance service at Tech Solutions Inc.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      'icon': Icons.play_arrow,
      'iconColor': Colors.orange,
      'metadata': {
        'jobId': 'JOB002',
        'client': 'Tech Solutions Inc.',
        'estimatedDuration': '2h',
      }
    },
    {
      'id': 'activity_006',
      'type': 'report_generated',
      'category': 'reports',
      'title': 'Generated Monthly Report',
      'description': 'Downloaded performance analytics report for September 2024',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'icon': Icons.analytics,
      'iconColor': Colors.purple,
      'metadata': {
        'reportType': 'performance',
        'period': 'September 2024',
        'format': 'PDF',
      }
    },
    {
      'id': 'activity_007',
      'type': 'emergency_alert',
      'category': 'communication',
      'title': 'Responded to Emergency Alert',
      'description': 'Acknowledged emergency call for equipment failure at Downtown Office',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'icon': Icons.emergency,
      'iconColor': Colors.red,
      'metadata': {
        'alertId': 'EMRG001',
        'responseTime': '2 minutes',
        'action': 'acknowledged',
      }
    },
    {
      'id': 'activity_008',
      'type': 'invoice_created',
      'category': 'jobs',
      'title': 'Created Invoice',
      'description': 'Generated invoice for completed electrical work at Corporate HQ',
      'timestamp': DateTime.now().subtract(const Duration(days: 4)),
      'icon': Icons.receipt,
      'iconColor': Colors.indigo,
      'metadata': {
        'invoiceId': 'INV-2024-0234',
        'amount': 850.00,
        'client': 'Corporate HQ',
      }
    },
    {
      'id': 'activity_009',
      'type': 'training_completed',
      'category': 'settings',
      'title': 'Completed Safety Training',
      'description': 'Finished online safety certification course with 95% score',
      'timestamp': DateTime.now().subtract(const Duration(days: 7)),
      'icon': Icons.school,
      'iconColor': Colors.teal,
      'metadata': {
        'courseId': 'SAFETY-101',
        'score': 95,
        'certificateId': 'CERT-2024-SF-345',
      }
    },
    {
      'id': 'activity_010',
      'type': 'equipment_checked',
      'category': 'inventory',
      'title': 'Equipment Check Complete',
      'description': 'Performed weekly equipment maintenance check on HVAC tools',
      'timestamp': DateTime.now().subtract(const Duration(days: 8)),
      'icon': Icons.build,
      'iconColor': Colors.brown,
      'metadata': {
        'equipmentIds': ['TOOL-001', 'TOOL-002', 'TOOL-003'],
        'status': 'all_good',
        'nextCheck': DateTime.now().add(const Duration(days: 7)),
      }
    },
  ];

  List<Map<String, dynamic>> get _filteredActivities {
    List<Map<String, dynamic>> filtered = _activities;

    // Apply category filter
    if (_selectedFilter != 'all') {
      filtered = filtered.where((activity) => activity['category'] == _selectedFilter).toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((activity) =>
        activity['title'].toString().toLowerCase().contains(searchTerm) ||
        activity['description'].toString().toLowerCase().contains(searchTerm)
      ).toList();
    }

    // Apply date range filter
    final now = DateTime.now();
    DateTime cutoffDate;
    switch (_selectedDateRange) {
      case 'today':
        cutoffDate = DateTime(now.year, now.month, now.day);
        break;
      case 'last_7_days':
        cutoffDate = now.subtract(const Duration(days: 7));
        break;
      case 'last_30_days':
        cutoffDate = now.subtract(const Duration(days: 30));
        break;
      case 'last_90_days':
        cutoffDate = now.subtract(const Duration(days: 90));
        break;
      default:
        cutoffDate = DateTime(2000); // Show all
    }

    filtered = filtered.where((activity) => 
      activity['timestamp'].isAfter(cutoffDate)
    ).toList();

    // Sort by timestamp (newest first)
    filtered.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportHistory,
            tooltip: 'Export History',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'clear_all', child: Text('Clear All History')),
              const PopupMenuItem(value: 'settings', child: Text('History Settings')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search activities...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 12),
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Category filters
                      ..._activityFilters.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(_getFilterLabel(filter)),
                            selected: _selectedFilter == filter,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            selectedColor: const Color(0xFF14B8A6).withOpacity(0.2),
                            checkmarkColor: const Color(0xFF14B8A6),
                          ),
                        );
                      }).toList(),
                      const SizedBox(width: 16),
                      // Date range dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedDateRange,
                            items: _dateRanges.map((range) {
                              return DropdownMenuItem(
                                value: range,
                                child: Text(_getDateRangeLabel(range)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedDateRange = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Activities list
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredActivities.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _refreshActivities,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredActivities.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final activity = _filteredActivities[index];
                        return _buildActivityCard(activity);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    final timestamp = activity['timestamp'] as DateTime;
    final timeAgo = _getTimeAgo(timestamp);
    final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp);

    return Card(
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: activity['iconColor'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            activity['icon'],
            color: activity['iconColor'],
            size: 24,
          ),
        ),
        title: Text(
          activity['title'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(activity['description']),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  timeAgo,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(activity['category']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getFilterLabel(activity['category']),
                    style: TextStyle(
                      fontSize: 10,
                      color: _getCategoryColor(activity['category']),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleActivityAction(action, activity),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'details', child: Text('View Details')),
            const PopupMenuItem(value: 'share', child: Text('Share')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        onTap: () => _showActivityDetails(activity),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Activities Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty
              ? 'Try adjusting your search or filters'
              : 'Your activity history will appear here',
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          if (_searchController.text.isNotEmpty || _selectedFilter != 'all') ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _selectedFilter = 'all';
                  _selectedDateRange = 'last_30_days';
                });
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ],
      ),
    );
  }

  String _getFilterLabel(String filter) {
    switch (filter) {
      case 'all': return 'All';
      case 'jobs': return 'Jobs';
      case 'communication': return 'Communication';
      case 'inventory': return 'Inventory';
      case 'settings': return 'Settings';
      case 'reports': return 'Reports';
      default: return filter;
    }
  }

  String _getDateRangeLabel(String range) {
    switch (range) {
      case 'today': return 'Today';
      case 'last_7_days': return 'Last 7 Days';
      case 'last_30_days': return 'Last 30 Days';
      case 'last_90_days': return 'Last 90 Days';
      case 'custom': return 'Custom';
      default: return range;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'jobs': return Colors.green;
      case 'communication': return Colors.blue;
      case 'inventory': return const Color(0xFF14B8A6);
      case 'settings': return Colors.grey;
      case 'reports': return Colors.purple;
      default: return Colors.grey;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(timestamp);
    }
  }

  Future<void> _refreshActivities() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Activity history refreshed')),
    );
  }

  void _showActivityDetails(Map<String, dynamic> activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(activity['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity['description']),
            const SizedBox(height: 16),
            Text(
              'Time: ${DateFormat('MMM dd, yyyy • hh:mm a').format(activity['timestamp'])}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (activity['metadata'] != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Additional Details:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...activity['metadata'].entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('${entry.key}: ${entry.value}'),
                );
              }).toList(),
            ],
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

  void _handleActivityAction(String action, Map<String, dynamic> activity) {
    switch (action) {
      case 'details':
        _showActivityDetails(activity);
        break;
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sharing: ${activity['title']}')),
        );
        break;
      case 'delete':
        _deleteActivity(activity);
        break;
    }
  }

  void _deleteActivity(Map<String, dynamic> activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: Text('Are you sure you want to delete "${activity['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _activities.removeWhere((a) => a['id'] == activity['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Activity deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _exportHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting activity history...')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'clear_all':
        _clearAllHistory();
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('History settings coming soon')),
        );
        break;
    }
  }

  void _clearAllHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text('This will permanently delete all activity history. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _activities.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All activity history cleared')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
} 