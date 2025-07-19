import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmergencyResponseScreen extends StatefulWidget {
  const EmergencyResponseScreen({super.key});

  @override
  State<EmergencyResponseScreen> createState() => _EmergencyResponseScreenState();
}

class _EmergencyResponseScreenState extends State<EmergencyResponseScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _filterPriority = 'all';
  String _filterStatus = 'all';
  Map<String, dynamic>? _selectedEmergency;

  final List<Map<String, dynamic>> _emergencies = [
    {
      'id': '1',
      'title': 'Gas Leak Emergency',
      'description': 'Reported gas leak at residential building',
      'priority': 'critical',
      'status': 'in_progress',
      'reportedAt': DateTime.now().subtract(const Duration(hours: 2)),
      'reportedBy': 'Building Manager',
      'location': '123 Main Street, Downtown',
      'client': 'Downtown Apartments',
      'assignedTechnician': 'Arjun Singh',
      'estimatedArrival': DateTime.now().add(const Duration(minutes: 15)),
      'actualArrival': null,
      'completionTime': null,
      'emergencyType': 'gas_leak',
      'contactNumber': '+1-555-0123',
      'notes': 'Residents evacuated, gas company notified',
      'photos': ['emergency_001.jpg', 'emergency_002.jpg'],
      'actions': [
        {'action': 'Evacuated building', 'time': DateTime.now().subtract(const Duration(hours: 1, minutes: 45))},
        {'action': 'Called gas company', 'time': DateTime.now().subtract(const Duration(hours: 1, minutes: 30))},
        {'action': 'Technician dispatched', 'time': DateTime.now().subtract(const Duration(hours: 1, minutes: 15))},
      ],
    },
    {
      'id': '2',
      'title': 'Electrical Fire',
      'description': 'Electrical panel smoking in office building',
      'priority': 'high',
      'status': 'resolved',
      'reportedAt': DateTime.now().subtract(const Duration(hours: 6)),
      'reportedBy': 'Security Guard',
      'location': '456 Business Ave, Midtown',
      'client': 'Tech Solutions Inc.',
      'assignedTechnician': 'Sarah Williams',
      'estimatedArrival': DateTime.now().subtract(const Duration(hours: 5, minutes: 30)),
      'actualArrival': DateTime.now().subtract(const Duration(hours: 5, minutes: 15)),
      'completionTime': DateTime.now().subtract(const Duration(hours: 3)),
      'emergencyType': 'electrical_fire',
      'contactNumber': '+1-555-0456',
      'notes': 'Panel replaced, building safe to re-enter',
      'photos': ['emergency_003.jpg'],
      'actions': [
        {'action': 'Fire department called', 'time': DateTime.now().subtract(const Duration(hours: 5, minutes: 45))},
        {'action': 'Building evacuated', 'time': DateTime.now().subtract(const Duration(hours: 5, minutes: 30))},
        {'action': 'Technician arrived', 'time': DateTime.now().subtract(const Duration(hours: 5, minutes: 15))},
        {'action': 'Issue resolved', 'time': DateTime.now().subtract(const Duration(hours: 3))},
      ],
    },
    {
      'id': '3',
      'title': 'Water Main Break',
      'description': 'Major water main break flooding basement',
      'priority': 'critical',
      'status': 'pending',
      'reportedAt': DateTime.now().subtract(const Duration(minutes: 30)),
      'reportedBy': 'Property Owner',
      'location': '789 Industrial Blvd, Warehouse District',
      'client': 'Industrial Storage Co.',
      'assignedTechnician': 'Maya Chen',
      'estimatedArrival': DateTime.now().add(const Duration(minutes: 45)),
      'actualArrival': null,
      'completionTime': null,
      'emergencyType': 'water_damage',
      'contactNumber': '+1-555-0789',
      'notes': 'Water company en route, equipment at risk',
      'photos': ['emergency_004.jpg'],
      'actions': [
        {'action': 'Emergency reported', 'time': DateTime.now().subtract(const Duration(minutes: 30))},
        {'action': 'Water company notified', 'time': DateTime.now().subtract(const Duration(minutes: 25))},
        {'action': 'Technician dispatched', 'time': DateTime.now().subtract(const Duration(minutes: 20))},
      ],
    },
    {
      'id': '4',
      'title': 'HVAC System Failure',
      'description': 'Complete HVAC failure in data center',
      'priority': 'high',
      'status': 'in_progress',
      'reportedAt': DateTime.now().subtract(const Duration(hours: 1)),
      'reportedBy': 'IT Manager',
      'location': '321 Data Center Dr, Tech Park',
      'client': 'Cloud Computing Corp.',
      'assignedTechnician': 'Ravi Patel',
      'estimatedArrival': DateTime.now().subtract(const Duration(minutes: 30)),
      'actualArrival': DateTime.now().subtract(const Duration(minutes: 25)),
      'completionTime': null,
      'emergencyType': 'hvac_failure',
      'contactNumber': '+1-555-0321',
      'notes': 'Temporary cooling units deployed, servers safe',
      'photos': ['emergency_005.jpg', 'emergency_006.jpg'],
      'actions': [
        {'action': 'Emergency reported', 'time': DateTime.now().subtract(const Duration(hours: 1))},
        {'action': 'Backup systems activated', 'time': DateTime.now().subtract(const Duration(minutes: 55))},
        {'action': 'Technician dispatched', 'time': DateTime.now().subtract(const Duration(minutes: 45))},
        {'action': 'Technician arrived', 'time': DateTime.now().subtract(const Duration(minutes: 25))},
      ],
    },
    {
      'id': '5',
      'title': 'Elevator Malfunction',
      'description': 'Elevator stuck with passengers inside',
      'priority': 'medium',
      'status': 'resolved',
      'reportedAt': DateTime.now().subtract(const Duration(hours: 3)),
      'reportedBy': 'Building Security',
      'location': '654 High Rise Blvd, Downtown',
      'client': 'Luxury Apartments',
      'assignedTechnician': 'Arjun Singh',
      'estimatedArrival': DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
      'actualArrival': DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
      'completionTime': DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      'emergencyType': 'elevator_malfunction',
      'contactNumber': '+1-555-0654',
      'notes': 'Passengers safely rescued, elevator repaired',
      'photos': ['emergency_007.jpg'],
      'actions': [
        {'action': 'Emergency reported', 'time': DateTime.now().subtract(const Duration(hours: 3))},
        {'action': 'Fire department called', 'time': DateTime.now().subtract(const Duration(hours: 2, minutes: 45))},
        {'action': 'Technician dispatched', 'time': DateTime.now().subtract(const Duration(hours: 2, minutes: 30))},
        {'action': 'Passengers rescued', 'time': DateTime.now().subtract(const Duration(hours: 1, minutes: 45))},
        {'action': 'Issue resolved', 'time': DateTime.now().subtract(const Duration(hours: 1, minutes: 30))},
      ],
    },
  ];

  final List<Map<String, dynamic>> _emergencyTypes = [
    {'id': 'gas_leak', 'name': 'Gas Leak', 'icon': Icons.warning, 'color': Colors.red},
    {'id': 'electrical_fire', 'name': 'Electrical Fire', 'icon': Icons.local_fire_department, 'color': Colors.orange},
    {'id': 'water_damage', 'name': 'Water Damage', 'icon': Icons.water_drop, 'color': Colors.blue},
    {'id': 'hvac_failure', 'name': 'HVAC Failure', 'icon': Icons.ac_unit, 'color': Colors.purple},
    {'id': 'elevator_malfunction', 'name': 'Elevator Malfunction', 'icon': Icons.elevator, 'color': Colors.grey},
    {'id': 'security_breach', 'name': 'Security Breach', 'icon': Icons.security, 'color': Colors.indigo},
    {'id': 'structural_damage', 'name': 'Structural Damage', 'icon': Icons.home_repair_service, 'color': Colors.brown},
    {'id': 'other', 'name': 'Other', 'icon': Icons.emergency, 'color': Colors.black},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredEmergencies {
    return _emergencies.where((emergency) {
      final matchesSearch = emergency['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          emergency['description'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          emergency['location'].toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesPriority = _filterPriority == 'all' || emergency['priority'] == _filterPriority;
      final matchesStatus = _filterStatus == 'all' || emergency['status'] == _filterStatus;
      
      return matchesSearch && matchesPriority && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Response'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Emergencies',
          ),
          IconButton(
            icon: const Icon(Icons.emergency),
            onPressed: _reportEmergency,
            tooltip: 'Report Emergency',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'History'),
            Tab(text: 'Protocols'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveEmergenciesTab(),
          _buildHistoryTab(),
          _buildProtocolsTab(),
          _buildAnalyticsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'emergency_fab',
        onPressed: _reportEmergency,
        backgroundColor: Colors.red,
        child: const Icon(Icons.emergency, color: Colors.white),
      ),
    );
  }

  Widget _buildActiveEmergenciesTab() {
    final activeEmergencies = _filteredEmergencies.where((e) => 
      e['status'] == 'pending' || e['status'] == 'in_progress'
    ).toList();

    return Column(
      children: [
        _buildSearchBar(),
        _buildActiveStats(activeEmergencies),
        Expanded(
          child: activeEmergencies.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 64, color: Colors.green),
                      SizedBox(height: 16),
                      Text(
                        'No active emergencies',
                        style: TextStyle(fontSize: 18, color: Colors.green),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: activeEmergencies.length,
                  itemBuilder: (context, index) {
                    final emergency = activeEmergencies[index];
                    return _buildEmergencyCard(emergency);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search emergencies...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildActiveStats(List<Map<String, dynamic>> activeEmergencies) {
    final critical = activeEmergencies.where((e) => e['priority'] == 'critical').length;
    final high = activeEmergencies.where((e) => e['priority'] == 'high').length;
    final medium = activeEmergencies.where((e) => e['priority'] == 'medium').length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Critical', critical.toString(), Colors.red),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('High', high.toString(), Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Medium', medium.toString(), Colors.yellow),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(Map<String, dynamic> emergency) {
    final type = _emergencyTypes.firstWhere((t) => t['id'] == emergency['emergencyType']);
    final priorityColor = _getPriorityColor(emergency['priority']);
    final statusColor = _getStatusColor(emergency['status']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: type['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            type['icon'],
            color: type['color'],
          ),
        ),
        title: Text(
          emergency['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emergency['description']),
            Text(
              '${DateFormat('MMM dd, HH:mm').format(emergency['reportedAt'])} • ${emergency['location']}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    emergency['priority'].toUpperCase(),
                    style: TextStyle(
                      color: priorityColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    emergency['status'].replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (emergency['assignedTechnician'] != null)
              Text(
                emergency['assignedTechnician'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            if (emergency['estimatedArrival'] != null)
              Text(
                'ETA: ${DateFormat('HH:mm').format(emergency['estimatedArrival'])}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        onTap: () => _showEmergencyDetails(emergency),
      ),
    );
  }

  Widget _buildHistoryTab() {
    final resolvedEmergencies = _filteredEmergencies.where((e) => 
      e['status'] == 'resolved'
    ).toList();

    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: resolvedEmergencies.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No resolved emergencies',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: resolvedEmergencies.length,
                  itemBuilder: (context, index) {
                    final emergency = resolvedEmergencies[index];
                    return _buildHistoryCard(emergency);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> emergency) {
    final type = _emergencyTypes.firstWhere((t) => t['id'] == emergency['emergencyType']);
    final priorityColor = _getPriorityColor(emergency['priority']);
    final duration = emergency['completionTime']?.difference(emergency['reportedAt']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        ),
        title: Text(
          emergency['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emergency['description']),
            Text(
              '${DateFormat('MMM dd, HH:mm').format(emergency['reportedAt'])} • ${emergency['location']}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    emergency['priority'].toUpperCase(),
                    style: TextStyle(
                      color: priorityColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'RESOLVED',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              emergency['assignedTechnician'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            if (duration != null)
              Text(
                '${duration.inHours}h ${duration.inMinutes % 60}m',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        onTap: () => _showEmergencyDetails(emergency),
      ),
    );
  }

  Widget _buildProtocolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Protocols',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Emergency Types
          Text(
            'Emergency Types & Protocols',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._emergencyTypes.map((type) => _buildProtocolCard(type)),
          const SizedBox(height: 24),
          
          // Response Guidelines
          Text(
            'Response Guidelines',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildResponseGuidelines(),
        ],
      ),
    );
  }

  Widget _buildProtocolCard(Map<String, dynamic> type) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: type['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            type['icon'],
            color: type['color'],
          ),
        ),
        title: Text(type['name']),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Immediate Actions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildProtocolStep('1. Assess the situation and ensure safety'),
                _buildProtocolStep('2. Contact emergency services if needed'),
                _buildProtocolStep('3. Notify management and dispatch technician'),
                _buildProtocolStep('4. Document incident and take photos'),
                _buildProtocolStep('5. Follow up with client and insurance'),
                const SizedBox(height: 16),
                const Text(
                  'Required Equipment:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildProtocolStep('• Safety equipment (PPE)'),
                _buildProtocolStep('• Emergency contact list'),
                _buildProtocolStep('• Documentation tools'),
                _buildProtocolStep('• Communication devices'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolStep(String step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(step)),
        ],
      ),
    );
  }

  Widget _buildResponseGuidelines() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Priority Levels:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildPriorityGuideline('Critical', 'Immediate response required', Colors.red),
            _buildPriorityGuideline('High', 'Response within 1 hour', Colors.orange),
            _buildPriorityGuideline('Medium', 'Response within 4 hours', Colors.yellow),
            _buildPriorityGuideline('Low', 'Response within 24 hours', Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Communication Protocol:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildProtocolStep('1. Notify supervisor immediately'),
            _buildProtocolStep('2. Update client on response time'),
            _buildProtocolStep('3. Document all communications'),
            _buildProtocolStep('4. Provide regular status updates'),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityGuideline(String priority, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  priority,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    final totalEmergencies = _emergencies.length;
    final resolvedEmergencies = _emergencies.where((e) => e['status'] == 'resolved').length;
    final avgResponseTime = _calculateAverageResponseTime();
    final criticalEmergencies = _emergencies.where((e) => e['priority'] == 'critical').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Analytics',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Key Metrics
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard('Total Emergencies', totalEmergencies.toString(), Icons.emergency, Colors.red),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard('Resolved', resolvedEmergencies.toString(), Icons.check_circle, Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard('Avg Response', '${avgResponseTime.toStringAsFixed(1)}h', Icons.timer, Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard('Critical', criticalEmergencies.toString(), Icons.warning, Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Emergency Type Distribution
          Text(
            'Emergency Type Distribution',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildEmergencyTypeChart(),
          const SizedBox(height: 24),
          
          // Response Time Analysis
          Text(
            'Response Time Analysis',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildResponseTimeAnalysis(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyTypeChart() {
    final typeCounts = <String, int>{};
    for (final emergency in _emergencies) {
      final type = emergency['emergencyType'];
      typeCounts[type] = (typeCounts[type] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: typeCounts.entries.map((entry) {
            final type = _emergencyTypes.firstWhere((t) => t['id'] == entry.key);
            final percentage = (entry.value / _emergencies.length * 100).toStringAsFixed(1);
            return ListTile(
              leading: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: type['color'],
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(type['name']),
              trailing: Text(
                '$percentage% (${entry.value})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildResponseTimeAnalysis() {
    final resolvedEmergencies = _emergencies.where((e) => e['status'] == 'resolved').toList();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Response Time by Priority:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...['critical', 'high', 'medium'].map((priority) {
              final emergencies = resolvedEmergencies.where((e) => e['priority'] == priority).toList();
              final avgTime = emergencies.isEmpty ? 0.0 : 
                emergencies.fold<double>(0, (sum, e) {
                  final duration = e['completionTime']?.difference(e['reportedAt']);
                  return sum + (duration?.inMinutes ?? 0);
                }) / emergencies.length / 60;
              
              return ListTile(
                leading: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getPriorityColor(priority),
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(priority.toUpperCase()),
                trailing: Text(
                  '${avgTime.toStringAsFixed(1)}h',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  double _calculateAverageResponseTime() {
    final resolvedEmergencies = _emergencies.where((e) => e['status'] == 'resolved').toList();
    if (resolvedEmergencies.isEmpty) return 0.0;
    
    final totalMinutes = resolvedEmergencies.fold<double>(0, (sum, e) {
      final duration = e['completionTime']?.difference(e['reportedAt']);
      return sum + (duration?.inMinutes ?? 0);
    });
    
    return totalMinutes / resolvedEmergencies.length / 60;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Emergencies'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Priority'),
              value: _filterPriority,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Priorities')),
                DropdownMenuItem(value: 'critical', child: Text('Critical')),
                DropdownMenuItem(value: 'high', child: Text('High')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'low', child: Text('Low')),
              ],
              onChanged: (value) {
                setState(() {
                  _filterPriority = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Status'),
              value: _filterStatus,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
              ],
              onChanged: (value) {
                setState(() {
                  _filterStatus = value!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _reportEmergency() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Emergency'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Report a new emergency situation.'),
            SizedBox(height: 16),
            Text('This will include:'),
            SizedBox(height: 8),
            Text('• Emergency type and description'),
            Text('• Location and contact information'),
            Text('• Priority level assessment'),
            Text('• Immediate actions taken'),
            Text('• Photo documentation'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Emergency reporting form coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Report Emergency'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDetails(Map<String, dynamic> emergency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Title', emergency['title']),
              _buildDetailRow('Description', emergency['description']),
              _buildDetailRow('Priority', emergency['priority'].toUpperCase()),
              _buildDetailRow('Status', emergency['status'].replaceAll('_', ' ').toUpperCase()),
              _buildDetailRow('Reported At', DateFormat('MMM dd, yyyy HH:mm').format(emergency['reportedAt'])),
              _buildDetailRow('Reported By', emergency['reportedBy']),
              _buildDetailRow('Location', emergency['location']),
              _buildDetailRow('Client', emergency['client']),
              _buildDetailRow('Contact', emergency['contactNumber']),
              if (emergency['assignedTechnician'] != null)
                _buildDetailRow('Technician', emergency['assignedTechnician']),
              if (emergency['estimatedArrival'] != null)
                _buildDetailRow('ETA', DateFormat('MMM dd, HH:mm').format(emergency['estimatedArrival'])),
              if (emergency['actualArrival'] != null)
                _buildDetailRow('Arrived', DateFormat('MMM dd, HH:mm').format(emergency['actualArrival'])),
              if (emergency['completionTime'] != null)
                _buildDetailRow('Completed', DateFormat('MMM dd, HH:mm').format(emergency['completionTime'])),
              if (emergency['notes'] != null)
                _buildDetailRow('Notes', emergency['notes']),
              const SizedBox(height: 16),
              const Text(
                'Actions Taken:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...emergency['actions'].map<Widget>((action) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text('• ${action['action']}'),
                    const Spacer(),
                    Text(
                      DateFormat('HH:mm').format(action['time']),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateEmergencyStatus(emergency);
            },
            child: const Text('Update Status'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _updateEmergencyStatus(Map<String, dynamic> emergency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Update the status of this emergency.'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'New Status'),
              value: emergency['status'],
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
              ],
              onChanged: (value) {
                setState(() {
                  final index = _emergencies.indexWhere((e) => e['id'] == emergency['id']);
                  if (index != -1) {
                    _emergencies[index]['status'] = value!;
                    if (value == 'resolved') {
                      _emergencies[index]['completionTime'] = DateTime.now();
                    }
                  }
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Emergency status updated')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
} 