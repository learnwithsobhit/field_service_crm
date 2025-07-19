import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EquipmentManagementScreen extends StatefulWidget {
  const EquipmentManagementScreen({super.key});

  @override
  State<EquipmentManagementScreen> createState() => _EquipmentManagementScreenState();
}

class _EquipmentManagementScreenState extends State<EquipmentManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _filterCategory = 'all';
  String _filterStatus = 'all';
  Map<String, dynamic>? _selectedEquipment;

  final List<Map<String, dynamic>> _equipment = [
    {
      'id': '1',
      'name': 'HVAC Diagnostic Kit',
      'category': 'diagnostic',
      'model': 'HVAC-2024-Pro',
      'serialNumber': 'HVAC-001-2024',
      'status': 'available',
      'condition': 'excellent',
      'purchaseDate': DateTime.now().subtract(const Duration(days: 180)),
      'warrantyExpiry': DateTime.now().add(const Duration(days: 185)),
      'lastMaintenance': DateTime.now().subtract(const Duration(days: 30)),
      'nextMaintenance': DateTime.now().add(const Duration(days: 30)),
      'assignedTo': null,
      'location': 'Main Warehouse',
      'value': 2500.00,
      'maintenanceHistory': [
        {
          'date': DateTime.now().subtract(const Duration(days: 30)),
          'type': 'Routine Maintenance',
          'technician': 'Maya Chen',
          'cost': 150.00,
          'notes': 'Calibrated sensors, cleaned filters',
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 90)),
          'type': 'Software Update',
          'technician': 'Ravi Patel',
          'cost': 50.00,
          'notes': 'Updated diagnostic software',
        },
      ],
      'specifications': {
        'brand': 'TechTools Pro',
        'weight': '5.2 kg',
        'dimensions': '45 x 30 x 15 cm',
        'power': 'Battery powered',
        'warranty': '2 years',
      },
    },
    {
      'id': '2',
      'name': 'Plumbing Tool Set',
      'category': 'plumbing',
      'model': 'Plumb-Master-2024',
      'serialNumber': 'PLUMB-002-2024',
      'status': 'in_use',
      'condition': 'good',
      'purchaseDate': DateTime.now().subtract(const Duration(days: 120)),
      'warrantyExpiry': DateTime.now().add(const Duration(days: 245)),
      'lastMaintenance': DateTime.now().subtract(const Duration(days: 15)),
      'nextMaintenance': DateTime.now().add(const Duration(days: 45)),
      'assignedTo': 'Ravi Patel',
      'location': 'Field - Downtown',
      'value': 800.00,
      'maintenanceHistory': [
        {
          'date': DateTime.now().subtract(const Duration(days: 15)),
          'type': 'Tool Sharpening',
          'technician': 'Arjun Singh',
          'cost': 75.00,
          'notes': 'Sharpened cutting tools, replaced worn parts',
        },
      ],
      'specifications': {
        'brand': 'PlumbMaster',
        'weight': '8.5 kg',
        'dimensions': '60 x 40 x 20 cm',
        'power': 'Manual',
        'warranty': '1 year',
      },
    },
    {
      'id': '3',
      'name': 'Electrical Testing Equipment',
      'category': 'electrical',
      'model': 'ElectroTest-Pro',
      'serialNumber': 'ELEC-003-2024',
      'status': 'maintenance',
      'condition': 'fair',
      'purchaseDate': DateTime.now().subtract(const Duration(days: 365)),
      'warrantyExpiry': DateTime.now().subtract(const Duration(days: 5)),
      'lastMaintenance': DateTime.now().subtract(const Duration(days: 5)),
      'nextMaintenance': DateTime.now().add(const Duration(days: 7)),
      'assignedTo': null,
      'location': 'Service Center',
      'value': 1200.00,
      'maintenanceHistory': [
        {
          'date': DateTime.now().subtract(const Duration(days: 5)),
          'type': 'Major Repair',
          'technician': 'External Service',
          'cost': 300.00,
          'notes': 'Replaced faulty circuit board, recalibrated',
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 60)),
          'type': 'Routine Check',
          'technician': 'Sarah Williams',
          'cost': 100.00,
          'notes': 'Cleaned contacts, tested accuracy',
        },
      ],
      'specifications': {
        'brand': 'ElectroTest',
        'weight': '3.8 kg',
        'dimensions': '35 x 25 x 12 cm',
        'power': 'Battery powered',
        'warranty': '1 year',
      },
    },
    {
      'id': '4',
      'name': 'Safety Equipment Set',
      'category': 'safety',
      'model': 'SafeGuard-Complete',
      'serialNumber': 'SAFE-004-2024',
      'status': 'available',
      'condition': 'excellent',
      'purchaseDate': DateTime.now().subtract(const Duration(days: 90)),
      'warrantyExpiry': DateTime.now().add(const Duration(days: 275)),
      'lastMaintenance': DateTime.now().subtract(const Duration(days: 7)),
      'nextMaintenance': DateTime.now().add(const Duration(days: 23)),
      'assignedTo': null,
      'location': 'Main Warehouse',
      'value': 600.00,
      'maintenanceHistory': [
        {
          'date': DateTime.now().subtract(const Duration(days: 7)),
          'type': 'Inspection',
          'technician': 'Maya Chen',
          'cost': 25.00,
          'notes': 'Inspected all safety gear, replaced worn straps',
        },
      ],
      'specifications': {
        'brand': 'SafeGuard',
        'weight': '2.1 kg',
        'dimensions': '50 x 30 x 10 cm',
        'power': 'N/A',
        'warranty': '1 year',
      },
    },
    {
      'id': '5',
      'name': 'Mobile Work Station',
      'category': 'vehicle',
      'model': 'MobileTech-Van',
      'serialNumber': 'VEH-005-2024',
      'status': 'in_use',
      'condition': 'good',
      'purchaseDate': DateTime.now().subtract(const Duration(days: 730)),
      'warrantyExpiry': DateTime.now().subtract(const Duration(days: 365)),
      'lastMaintenance': DateTime.now().subtract(const Duration(days: 2)),
      'nextMaintenance': DateTime.now().add(const Duration(days: 28)),
      'assignedTo': 'Arjun Singh',
      'location': 'Field - Uptown',
      'value': 45000.00,
      'maintenanceHistory': [
        {
          'date': DateTime.now().subtract(const Duration(days: 2)),
          'type': 'Oil Change & Inspection',
          'technician': 'Auto Service Center',
          'cost': 200.00,
          'notes': 'Regular maintenance, replaced air filter',
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 90)),
          'type': 'Tire Replacement',
          'technician': 'Auto Service Center',
          'cost': 800.00,
          'notes': 'Replaced all four tires',
        },
      ],
      'specifications': {
        'brand': 'Ford Transit',
        'weight': '2800 kg',
        'dimensions': '5.3 x 2.0 x 2.5 m',
        'power': 'Diesel Engine',
        'warranty': '3 years',
      },
    },
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

  List<Map<String, dynamic>> get _filteredEquipment {
    return _equipment.where((equipment) {
      final matchesSearch = equipment['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          equipment['model'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          equipment['serialNumber'].toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _filterCategory == 'all' || equipment['category'] == _filterCategory;
      final matchesStatus = _filterStatus == 'all' || equipment['status'] == _filterStatus;
      
      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Equipment',
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showAnalytics,
            tooltip: 'Equipment Analytics',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Equipment'),
            Tab(text: 'Maintenance'),
            Tab(text: 'Assignments'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEquipmentTab(),
          _buildMaintenanceTab(),
          _buildAssignmentsTab(),
          _buildAnalyticsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'equipment_fab',
        onPressed: _addNewEquipment,
        backgroundColor: const Color(0xFF14B8A6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEquipmentTab() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: _filteredEquipment.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.build_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No equipment found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredEquipment.length,
                  itemBuilder: (context, index) {
                    final equipment = _filteredEquipment[index];
                    return _buildEquipmentCard(equipment);
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
          hintText: 'Search equipment...',
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

  Widget _buildEquipmentCard(Map<String, dynamic> equipment) {
    final statusColor = _getStatusColor(equipment['status']);
    final conditionColor = _getConditionColor(equipment['condition']);
    final categoryColor = _getCategoryColor(equipment['category']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(equipment['category']),
            color: categoryColor,
          ),
        ),
        title: Text(
          equipment['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(equipment['model']),
            Text(
              equipment['serialNumber'],
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    equipment['status'].replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: conditionColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    equipment['condition'].toUpperCase(),
                    style: TextStyle(
                      color: conditionColor,
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
              '\$${equipment['value'].toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              equipment['location'],
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        onTap: () => _showEquipmentDetails(equipment),
      ),
    );
  }

  Widget _buildMaintenanceTab() {
    final maintenanceItems = <Map<String, dynamic>>[];
    
    for (final equipment in _equipment) {
      if (equipment['nextMaintenance'] != null) {
        maintenanceItems.add({
          'equipment': equipment,
          'nextMaintenance': equipment['nextMaintenance'],
          'daysUntil': equipment['nextMaintenance'].difference(DateTime.now()).inDays,
        });
      }
    }
    
    maintenanceItems.sort((a, b) => a['daysUntil'].compareTo(b['daysUntil']));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: maintenanceItems.length,
      itemBuilder: (context, index) {
        final item = maintenanceItems[index];
        final equipment = item['equipment'];
        final daysUntil = item['daysUntil'];
        
        return _buildMaintenanceCard(equipment, daysUntil);
      },
    );
  }

  Widget _buildMaintenanceCard(Map<String, dynamic> equipment, int daysUntil) {
    final isOverdue = daysUntil < 0;
    final isUrgent = daysUntil <= 7;
    final color = isOverdue ? Colors.red : (isUrgent ? Colors.orange : Colors.green);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.build,
            color: color,
          ),
        ),
        title: Text(equipment['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(equipment['model']),
            Text(
              'Next maintenance: ${DateFormat('MMM dd, yyyy').format(equipment['nextMaintenance'])}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              isOverdue ? 'OVERDUE' : '${daysUntil} days',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              equipment['location'],
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        onTap: () => _scheduleMaintenance(equipment),
      ),
    );
  }

  Widget _buildAssignmentsTab() {
    final assignedEquipment = _equipment.where((e) => e['assignedTo'] != null).toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: assignedEquipment.length,
      itemBuilder: (context, index) {
        final equipment = assignedEquipment[index];
        return _buildAssignmentCard(equipment);
      },
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> equipment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF14B8A6),
          child: Text(
            equipment['assignedTo'][0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(equipment['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assigned to: ${equipment['assignedTo']}'),
            Text(
              'Location: ${equipment['location']}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.swap_horiz),
          onPressed: () => _reassignEquipment(equipment),
        ),
        onTap: () => _showAssignmentDetails(equipment),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    final totalEquipment = _equipment.length;
    final availableEquipment = _equipment.where((e) => e['status'] == 'available').length;
    final inUseEquipment = _equipment.where((e) => e['status'] == 'in_use').length;
    final maintenanceEquipment = _equipment.where((e) => e['status'] == 'maintenance').length;
    final totalValue = _equipment.fold<double>(0, (sum, e) => sum + e['value']);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Equipment Analytics',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Key Metrics
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  'Total Equipment',
                  totalEquipment.toString(),
                  Icons.build,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard(
                  'Available',
                  availableEquipment.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  'In Use',
                  inUseEquipment.toString(),
                  Icons.work,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard(
                  'Maintenance',
                  maintenanceEquipment.toString(),
                  Icons.build,
                  Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAnalyticsCard(
            'Total Value',
            '\$${totalValue.toStringAsFixed(0)}',
            Icons.attach_money,
            Colors.purple,
          ),
          const SizedBox(height: 24),
          
          // Equipment Categories
          Text(
            'Equipment by Category',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryChart(),
          const SizedBox(height: 24),
          
          // Maintenance Schedule
          Text(
            'Upcoming Maintenance',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildMaintenanceSchedule(),
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

  Widget _buildCategoryChart() {
    final categoryCounts = <String, int>{};
    for (final equipment in _equipment) {
      categoryCounts[equipment['category']] = (categoryCounts[equipment['category']] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: categoryCounts.entries.map((entry) {
            final percentage = (entry.value / _equipment.length * 100).toStringAsFixed(1);
            return ListTile(
              leading: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _getCategoryColor(entry.key),
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(entry.key.toUpperCase()),
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

  Widget _buildMaintenanceSchedule() {
    final maintenanceItems = <Map<String, dynamic>>[];
    
    for (final equipment in _equipment) {
      if (equipment['nextMaintenance'] != null) {
        final daysUntil = equipment['nextMaintenance'].difference(DateTime.now()).inDays;
        if (daysUntil <= 30) {
          maintenanceItems.add({
            'equipment': equipment,
            'daysUntil': daysUntil,
          });
        }
      }
    }
    
    maintenanceItems.sort((a, b) => a['daysUntil'].compareTo(b['daysUntil']));

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: maintenanceItems.take(5).length,
        itemBuilder: (context, index) {
          final item = maintenanceItems[index];
          final equipment = item['equipment'];
          final daysUntil = item['daysUntil'];
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _getCategoryColor(equipment['category']),
              child: Icon(
                _getCategoryIcon(equipment['category']),
                color: Colors.white,
                size: 16,
              ),
            ),
            title: Text(equipment['name']),
            subtitle: Text('${daysUntil} days until maintenance'),
            trailing: Text(
              DateFormat('MMM dd').format(equipment['nextMaintenance']),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'in_use':
        return Colors.blue;
      case 'maintenance':
        return Colors.orange;
      case 'retired':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getConditionColor(String condition) {
    switch (condition) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'fair':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'diagnostic':
        return Colors.blue;
      case 'plumbing':
        return Colors.green;
      case 'electrical':
        return Colors.orange;
      case 'safety':
        return Colors.red;
      case 'vehicle':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'diagnostic':
        return Icons.analytics;
      case 'plumbing':
        return Icons.plumbing;
      case 'electrical':
        return Icons.electrical_services;
      case 'safety':
        return Icons.security;
      case 'vehicle':
        return Icons.local_shipping;
      default:
        return Icons.build;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Equipment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Category'),
              value: _filterCategory,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Categories')),
                DropdownMenuItem(value: 'diagnostic', child: Text('Diagnostic')),
                DropdownMenuItem(value: 'plumbing', child: Text('Plumbing')),
                DropdownMenuItem(value: 'electrical', child: Text('Electrical')),
                DropdownMenuItem(value: 'safety', child: Text('Safety')),
                DropdownMenuItem(value: 'vehicle', child: Text('Vehicle')),
              ],
              onChanged: (value) {
                setState(() {
                  _filterCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Status'),
              value: _filterStatus,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'available', child: Text('Available')),
                DropdownMenuItem(value: 'in_use', child: Text('In Use')),
                DropdownMenuItem(value: 'maintenance', child: Text('Maintenance')),
                DropdownMenuItem(value: 'retired', child: Text('Retired')),
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
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Detailed equipment analytics coming soon!')),
    );
  }

  void _addNewEquipment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Equipment'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add new equipment to the inventory.'),
            SizedBox(height: 16),
            Text('This will include:'),
            SizedBox(height: 8),
            Text('• Equipment details'),
            Text('• Specifications'),
            Text('• Maintenance schedule'),
            Text('• Assignment tracking'),
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
                const SnackBar(content: Text('Add equipment form coming soon!')),
              );
            },
            child: const Text('Add Equipment'),
          ),
        ],
      ),
    );
  }

  void _showEquipmentDetails(Map<String, dynamic> equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(equipment['name']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Model', equipment['model']),
              _buildDetailRow('Serial Number', equipment['serialNumber']),
              _buildDetailRow('Status', equipment['status'].replaceAll('_', ' ').toUpperCase()),
              _buildDetailRow('Condition', equipment['condition'].toUpperCase()),
              _buildDetailRow('Location', equipment['location']),
              _buildDetailRow('Value', '\$${equipment['value'].toStringAsFixed(2)}'),
              if (equipment['assignedTo'] != null)
                _buildDetailRow('Assigned To', equipment['assignedTo']),
              if (equipment['nextMaintenance'] != null)
                _buildDetailRow('Next Maintenance', DateFormat('MMM dd, yyyy').format(equipment['nextMaintenance'])),
              const SizedBox(height: 16),
              const Text('Specifications:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...equipment['specifications'].entries.map((entry) => 
                _buildDetailRow(entry.key.toUpperCase(), entry.value.toString())
              ),
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
              _editEquipment(equipment);
            },
            child: const Text('Edit'),
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
            width: 120,
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

  void _scheduleMaintenance(Map<String, dynamic> equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Schedule Maintenance for ${equipment['name']}'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Schedule maintenance for this equipment.'),
            SizedBox(height: 16),
            Text('This will:'),
            SizedBox(height: 8),
            Text('• Update maintenance schedule'),
            Text('• Notify assigned technician'),
            Text('• Track maintenance history'),
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
                SnackBar(content: Text('Maintenance scheduled for ${equipment['name']}')),
              );
            },
            child: const Text('Schedule'),
          ),
        ],
      ),
    );
  }

  void _reassignEquipment(Map<String, dynamic> equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reassign ${equipment['name']}'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reassign this equipment to a different technician.'),
            SizedBox(height: 16),
            Text('Available technicians:'),
            SizedBox(height: 8),
            Text('• Maya Chen'),
            Text('• Ravi Patel'),
            Text('• Arjun Singh'),
            Text('• Sarah Williams'),
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
                SnackBar(content: Text('${equipment['name']} reassigned')),
              );
            },
            child: const Text('Reassign'),
          ),
        ],
      ),
    );
  }

  void _showAssignmentDetails(Map<String, dynamic> equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assignment Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Equipment', equipment['name']),
            _buildDetailRow('Assigned To', equipment['assignedTo']),
            _buildDetailRow('Location', equipment['location']),
            _buildDetailRow('Assignment Date', DateFormat('MMM dd, yyyy').format(DateTime.now().subtract(const Duration(days: 7)))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _reassignEquipment(equipment);
            },
            child: const Text('Reassign'),
          ),
        ],
      ),
    );
  }

  void _editEquipment(Map<String, dynamic> equipment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${equipment['name']} coming soon!')),
    );
  }
} 