import 'package:flutter/material.dart';
import 'location_sharing_screen.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLocationEnabled = true;
  bool _isTrackingActive = false;
  String _currentLocation = 'New York, NY';
  
  final List<Map<String, dynamic>> _jobLocations = [
    {
      'id': 'JOB001',
      'title': 'Quarterly Pest Control',
      'client': 'Green Valley Restaurant',
      'address': '456 Main Street, New York, NY 10001',
      'coordinates': {'lat': 40.7589, 'lng': -73.9851},
      'status': 'in_progress',
      'priority': 'normal',
      'estimatedTime': '45 mins',
      'distance': '2.3 miles',
      'technician': 'Sam Rodriguez',
      'scheduledTime': '09:00 AM',
      'contactPhone': '+1 (555) 123-4567',
    },
    {
      'id': 'JOB002',
      'title': 'HVAC Maintenance',
      'client': 'Tech Solutions Inc.',
      'address': '789 Business Ave, New York, NY 10002',
      'coordinates': {'lat': 40.7505, 'lng': -73.9934},
      'status': 'scheduled',
      'priority': 'normal',
      'estimatedTime': '2 hours',
      'distance': '5.1 miles',
      'technician': 'Mike Johnson',
      'scheduledTime': '02:00 PM',
      'contactPhone': '+1 (555) 234-5678',
    },
    {
      'id': 'JOB003',
      'title': 'Emergency HVAC Repair',
      'client': 'Downtown Office Building',
      'address': '123 Business Plaza, New York, NY 10005',
      'coordinates': {'lat': 40.7074, 'lng': -74.0113},
      'status': 'urgent',
      'priority': 'high',
      'estimatedTime': '3 hours',
      'distance': '8.7 miles',
      'technician': 'Alex Chen',
      'scheduledTime': 'ASAP',
      'contactPhone': '+1 (555) 345-6789',
    },
    {
      'id': 'JOB004',
      'title': 'Electrical Inspection',
      'client': 'Residential Home',
      'address': '321 Oak Street, Brooklyn, NY 11201',
      'coordinates': {'lat': 40.6892, 'lng': -73.9442},
      'status': 'scheduled',
      'priority': 'normal',
      'estimatedTime': '1 hour',
      'distance': '12.4 miles',
      'technician': 'Sarah Williams',
      'scheduledTime': '11:00 AM',
      'contactPhone': '+1 (555) 456-7890',
    },
  ];

  final List<Map<String, dynamic>> _teamMembers = [
    {
      'id': 'tech_001',
      'name': 'Sam Rodriguez',
      'role': 'Field Service Manager',
      'coordinates': {'lat': 40.7614, 'lng': -73.9776},
      'status': 'active',
      'currentJob': 'JOB001',
      'lastUpdate': DateTime.now().subtract(const Duration(minutes: 2)),
      'vehicle': 'Van #1',
    },
    {
      'id': 'tech_002',
      'name': 'Mike Johnson',
      'role': 'Senior Technician',
      'coordinates': {'lat': 40.7282, 'lng': -73.7949},
      'status': 'traveling',
      'currentJob': 'JOB002',
      'lastUpdate': DateTime.now().subtract(const Duration(minutes: 5)),
      'vehicle': 'Truck #3',
    },
    {
      'id': 'tech_003',
      'name': 'Alex Chen',
      'role': 'Team Lead',
      'coordinates': {'lat': 40.7505, 'lng': -73.9934},
      'status': 'on_site',
      'currentJob': 'JOB003',
      'lastUpdate': DateTime.now().subtract(const Duration(minutes: 1)),
      'vehicle': 'Van #2',
    },
    {
      'id': 'tech_004',
      'name': 'Sarah Williams',
      'role': 'Operations Manager',
      'coordinates': {'lat': 40.7831, 'lng': -73.9712},
      'status': 'available',
      'currentJob': null,
      'lastUpdate': DateTime.now().subtract(const Duration(minutes: 8)),
      'vehicle': 'Car #1',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps & Location'),
        actions: [
          IconButton(
            icon: Icon(_isLocationEnabled ? Icons.location_on : Icons.location_off),
            onPressed: _toggleLocationServices,
          ),
          IconButton(
            icon: const Icon(Icons.route),
            onPressed: _optimizeRoute,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'refresh', child: Text('Refresh Locations')),
              const PopupMenuItem(value: 'settings', child: Text('Location Settings')),
              const PopupMenuItem(value: 'export', child: Text('Export Route Data')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Jobs Map', icon: Icon(Icons.work)),
            Tab(text: 'Team Tracking', icon: Icon(Icons.people)),
            Tab(text: 'Routes', icon: Icon(Icons.directions)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Location Status Bar
          _buildLocationStatusBar(),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildJobsMapTab(),
                _buildTeamTrackingTab(),
                _buildRoutesTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "location",
            onPressed: _shareCurrentLocation,
            backgroundColor: const Color(0xFF14B8A6),
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "emergency",
            onPressed: _sendEmergencyLocation,
            backgroundColor: Colors.red,
            child: const Icon(Icons.emergency, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStatusBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: _isLocationEnabled ? Colors.green[50] : Colors.red[50],
      child: Row(
        children: [
          Icon(
            _isLocationEnabled ? Icons.gps_fixed : Icons.gps_off,
            color: _isLocationEnabled ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isLocationEnabled ? 'Location Services Active' : 'Location Services Disabled',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _isLocationEnabled ? Colors.green[800] : Colors.red[800],
                  ),
                ),
                Text(
                  _isLocationEnabled ? 'Current: $_currentLocation' : 'Enable GPS to track location',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isLocationEnabled ? Colors.green[600] : Colors.red[600],
                  ),
                ),
              ],
            ),
          ),
          if (_isLocationEnabled)
            Switch(
              value: _isTrackingActive,
              onChanged: _toggleTracking,
              activeColor: const Color(0xFF14B8A6),
            ),
        ],
      ),
    );
  }

  Widget _buildJobsMapTab() {
    return Column(
      children: [
        // Map View Placeholder
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Interactive Map View',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Job locations and routes would be displayed here',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Column(
                    children: [
                      _buildMapControlButton(Icons.zoom_in, 'Zoom In'),
                      const SizedBox(height: 8),
                      _buildMapControlButton(Icons.zoom_out, 'Zoom Out'),
                      const SizedBox(height: 8),
                      _buildMapControlButton(Icons.center_focus_strong, 'Center'),
                      const SizedBox(height: 8),
                      _buildMapControlButton(Icons.layers, 'Layers'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Job List
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today\'s Jobs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _filterJobs,
                      icon: const Icon(Icons.filter_list, size: 16),
                      label: const Text('Filter'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: _jobLocations.length,
                    itemBuilder: (context, index) {
                      final job = _jobLocations[index];
                      return _buildJobLocationCard(job);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamTrackingTab() {
    return Column(
      children: [
        // Team Overview
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: _buildTeamStatCard('Active', '3', Icons.person, Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _buildTeamStatCard('On Site', '1', Icons.location_on, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildTeamStatCard('Traveling', '1', Icons.directions_car, Colors.orange)),
              const SizedBox(width: 12),
              Expanded(child: _buildTeamStatCard('Available', '1', Icons.check_circle, Color(0xFF14B8A6))),
            ],
          ),
        ),
        
        // Team Members List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _teamMembers.length,
            itemBuilder: (context, index) {
              final member = _teamMembers[index];
              return _buildTeamMemberCard(member);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoutesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route Optimization
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.route, color: Color(0xFF14B8A6)),
                      const SizedBox(width: 8),
                      const Text(
                        'Route Optimization',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRouteInfo('Total Distance', '28.5 miles'),
                  _buildRouteInfo('Estimated Time', '4h 15m'),
                  _buildRouteInfo('Fuel Cost', '\$12.40'),
                  _buildRouteInfo('Jobs Remaining', '4'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _optimizeRoute,
                          icon: const Icon(Icons.auto_fix_high),
                          label: const Text('Optimize Route'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _shareRoute,
                          icon: const Icon(Icons.share),
                          label: const Text('Share Route'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Saved Routes
          const Text(
            'Saved Routes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildSavedRouteCard('Downtown Circuit', '5 stops', '3h 20m', DateTime.now().subtract(const Duration(days: 1))),
          _buildSavedRouteCard('Brooklyn Route', '8 stops', '6h 45m', DateTime.now().subtract(const Duration(days: 3))),
          _buildSavedRouteCard('Emergency Response', '3 stops', '2h 10m', DateTime.now().subtract(const Duration(days: 7))),
        ],
      ),
    );
  }

  Widget _buildMapControlButton(IconData icon, String tooltip) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: () => _handleMapControl(tooltip),
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildJobLocationCard(Map<String, dynamic> job) {
    final Color statusColor = _getJobStatusColor(job['status']);
    final IconData statusIcon = _getJobStatusIcon(job['status']);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _navigateToJob(job),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(statusIcon, color: statusColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      job['client'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          job['scheduledTime'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.location_on, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          job['distance'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.directions, color: Color(0xFF14B8A6)),
                    onPressed: () => _getDirections(job),
                  ),
                  IconButton(
                    icon: const Icon(Icons.call, color: Colors.blue),
                    onPressed: () => _callClient(job),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamStatCard(String title, String count, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(Map<String, dynamic> member) {
    final Color statusColor = _getTeamStatusColor(member['status']);
    final IconData statusIcon = _getTeamStatusIcon(member['status']);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _viewTeamMemberDetails(member),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(statusIcon, color: statusColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      member['role'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            member['status'].toString().replaceAll('_', ' ').toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          member['vehicle'],
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chat, color: Color(0xFF14B8A6)),
                    onPressed: () => _chatWithMember(member),
                  ),
                  IconButton(
                    icon: const Icon(Icons.location_on, color: Colors.blue),
                    onPressed: () => _viewMemberLocation(member),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedRouteCard(String name, String stops, String duration, DateTime lastUsed) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF14B8A6),
          child: Icon(Icons.route, color: Colors.white, size: 20),
        ),
        title: Text(name),
        subtitle: Text('$stops • $duration'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleRouteAction(value, name),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'load', child: Text('Load Route')),
            const PopupMenuItem(value: 'share', child: Text('Share')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Color _getJobStatusColor(String status) {
    switch (status) {
      case 'urgent':
        return Colors.red;
      case 'in_progress':
        return Colors.blue;
      case 'scheduled':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getJobStatusIcon(String status) {
    switch (status) {
      case 'urgent':
        return Icons.warning;
      case 'in_progress':
        return Icons.work;
      case 'scheduled':
        return Icons.schedule;
      default:
        return Icons.work_outline;
    }
  }

  Color _getTeamStatusColor(String status) {
    switch (status) {
      case 'active':
      case 'on_site':
        return Colors.green;
      case 'traveling':
        return Colors.orange;
      case 'available':
        return const Color(0xFF14B8A6);
      default:
        return Colors.grey;
    }
  }

  IconData _getTeamStatusIcon(String status) {
    switch (status) {
      case 'active':
        return Icons.person;
      case 'on_site':
        return Icons.location_on;
      case 'traveling':
        return Icons.directions_car;
      case 'available':
        return Icons.check_circle;
      default:
        return Icons.person_outline;
    }
  }

  // Action handlers
  void _toggleLocationServices() {
    setState(() {
      _isLocationEnabled = !_isLocationEnabled;
      if (!_isLocationEnabled) {
        _isTrackingActive = false;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isLocationEnabled 
            ? 'Location services enabled' 
            : 'Location services disabled'),
      ),
    );
  }

  void _toggleTracking(bool value) {
    setState(() {
      _isTrackingActive = value;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isTrackingActive 
            ? 'GPS tracking started' 
            : 'GPS tracking stopped'),
      ),
    );
  }

  void _optimizeRoute() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Optimizing route...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Route optimized! Saved 35 minutes and 8.2 miles.')),
      );
    });
  }

  void _shareCurrentLocation() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LocationSharingScreen(),
      ),
    );
  }

  void _sendEmergencyLocation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emergency, color: Colors.red),
            SizedBox(width: 8),
            Text('Emergency Alert'),
          ],
        ),
        content: const Text('Send emergency location to all team members and dispatch?'),
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
                  content: Text('Emergency location sent to all team members'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Send Alert', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'refresh':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Refreshing locations...')),
        );
        break;
      case 'settings':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LocationSettingsScreen(),
          ),
        );
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exporting route data...')),
        );
        break;
    }
  }

  void _handleMapControl(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Map control: $action')),
    );
  }

  void _filterJobs() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Jobs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Job filtering options coming soon!'),
          ],
        ),
      ),
    );
  }

  void _navigateToJob(Map<String, dynamic> job) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JobNavigationScreen(job: job),
      ),
    );
  }

  void _getDirections(Map<String, dynamic> job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Getting directions to ${job['client']}')),
    );
  }

  void _callClient(Map<String, dynamic> job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling ${job['client']} at ${job['contactPhone']}')),
    );
  }

  void _viewTeamMemberDetails(Map<String, dynamic> member) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TeamMemberLocationScreen(member: member),
      ),
    );
  }

  void _chatWithMember(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening chat with ${member['name']}')),
    );
  }

  void _viewMemberLocation(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing ${member['name']}\'s location')),
    );
  }

  void _shareRoute() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing optimized route...')),
    );
  }

  void _handleRouteAction(String action, String routeName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action: $routeName')),
    );
  }
}

// Placeholder screens
class LocationSettingsScreen extends StatelessWidget {
  const LocationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Settings')),
      body: const Center(child: Text('Location Settings Screen - Implementation coming next!')),
    );
  }
}

class JobNavigationScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobNavigationScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Navigate to ${job['client']}')),
      body: const Center(child: Text('Job Navigation Screen - Implementation coming next!')),
    );
  }
}

class TeamMemberLocationScreen extends StatelessWidget {
  final Map<String, dynamic> member;

  const TeamMemberLocationScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${member['name']} Location')),
      body: const Center(child: Text('Team Member Location Screen - Implementation coming next!')),
    );
  }
} 