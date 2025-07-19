import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceHistoryScreen extends StatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCustomer = 'all';
  String _selectedEquipment = 'all';
  String _selectedServiceType = 'all';

  final List<Map<String, dynamic>> _serviceHistory = [
    {
      'id': 'SH-001',
      'customer': 'Downtown Office Complex',
      'equipment': 'HVAC System #1',
      'serviceType': 'preventive',
      'technician': 'John Smith',
      'serviceDate': DateTime.now().subtract(const Duration(days: 30)),
      'nextServiceDate': DateTime.now().add(const Duration(days: 30)),
      'duration': 2.5,
      'cost': 450.0,
      'description': 'Monthly preventive maintenance. Replaced air filters, cleaned coils, checked refrigerant levels.',
      'parts': ['Air Filter', 'Coil Cleaner'],
      'laborHours': 2.5,
      'status': 'completed',
      'photos': ['filter_before.jpg', 'filter_after.jpg'],
      'notes': 'System running efficiently. Recommend next service in 30 days.',
    },
    {
      'id': 'SH-002',
      'customer': 'Westside Restaurant',
      'equipment': 'Walk-in Freezer',
      'serviceType': 'repair',
      'technician': 'Sarah Johnson',
      'serviceDate': DateTime.now().subtract(const Duration(days: 15)),
      'nextServiceDate': DateTime.now().add(const Duration(days: 90)),
      'duration': 4.0,
      'cost': 1200.0,
      'description': 'Emergency repair - freezer not maintaining temperature. Replaced compressor and thermostat.',
      'parts': ['Compressor', 'Thermostat', 'Refrigerant'],
      'laborHours': 4.0,
      'status': 'completed',
      'photos': ['compressor_old.jpg', 'compressor_new.jpg'],
      'notes': 'Compressor was 8 years old. New unit has 2-year warranty.',
    },
    {
      'id': 'SH-003',
      'customer': 'Eastside Manufacturing',
      'equipment': 'Industrial HVAC',
      'serviceType': 'inspection',
      'technician': 'Mike Wilson',
      'serviceDate': DateTime.now().subtract(const Duration(days: 7)),
      'nextServiceDate': DateTime.now().add(const Duration(days: 60)),
      'duration': 1.5,
      'cost': 200.0,
      'description': 'Quarterly inspection. System operating within normal parameters.',
      'parts': [],
      'laborHours': 1.5,
      'status': 'completed',
      'photos': ['inspection_report.pdf'],
      'notes': 'No issues found. Continue with current maintenance schedule.',
    },
    {
      'id': 'SH-004',
      'customer': 'Northside Shopping Center',
      'equipment': 'RTU Units (Multiple)',
      'serviceType': 'preventive',
      'technician': 'David Brown',
      'serviceDate': DateTime.now().subtract(const Duration(days: 2)),
      'nextServiceDate': DateTime.now().add(const Duration(days: 30)),
      'duration': 6.0,
      'cost': 800.0,
      'description': 'Semi-annual maintenance on all rooftop units. Replaced filters, cleaned coils, lubricated motors.',
      'parts': ['Air Filters (x12)', 'Motor Oil', 'Coil Cleaner'],
      'laborHours': 6.0,
      'status': 'completed',
      'photos': ['rtu_1.jpg', 'rtu_2.jpg', 'rtu_3.jpg'],
      'notes': 'All units performing well. One unit showing slight vibration - monitor closely.',
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
        title: const Text('Service History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Services'),
            Tab(text: 'Preventive'),
            Tab(text: 'Repairs'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addServiceRecord,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildServiceHistoryList(_getFilteredServices()),
          _buildServiceHistoryList(_getServicesByType('preventive')),
          _buildServiceHistoryList(_getServicesByType('repair')),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredServices() {
    return _serviceHistory.where((service) {
      bool matchesCustomer = true;
      bool matchesEquipment = true;
      bool matchesServiceType = true;

      if (_selectedCustomer != 'all') {
        matchesCustomer = service['customer'] == _selectedCustomer;
      }

      if (_selectedEquipment != 'all') {
        matchesEquipment = service['equipment'] == _selectedEquipment;
      }

      if (_selectedServiceType != 'all') {
        matchesServiceType = service['serviceType'] == _selectedServiceType;
      }

      return matchesCustomer && matchesEquipment && matchesServiceType;
    }).toList();
  }

  List<Map<String, dynamic>> _getServicesByType(String type) {
    return _serviceHistory.where((service) => service['serviceType'] == type).toList();
  }

  Widget _buildServiceHistoryList(List<Map<String, dynamic>> services) {
    if (services.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No service records found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(service);
      },
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final serviceTypeColor = _getServiceTypeColor(service['serviceType']);
    final isUpcoming = service['nextServiceDate'].isAfter(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showServiceDetails(service),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service['id'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service['equipment'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: serviceTypeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      service['serviceType'].toUpperCase(),
                      style: TextStyle(
                        color: serviceTypeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.business, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      service['customer'],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Technician: ${service['technician']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Service Date: ${DateFormat('MMM dd, yyyy').format(service['serviceDate'])}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Duration: ${service['duration']} hours',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    '\$${service['cost'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.event, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    'Next Service: ${DateFormat('MMM dd, yyyy').format(service['nextServiceDate'])}',
                    style: TextStyle(
                      color: isUpcoming ? Colors.blue : Colors.orange,
                      fontWeight: isUpcoming ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewServiceReport(service),
                      icon: const Icon(Icons.description, size: 16),
                      label: const Text('Report'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _scheduleFollowUp(service),
                      icon: const Icon(Icons.schedule, size: 16),
                      label: const Text('Schedule'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14B8A6),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getServiceTypeColor(String serviceType) {
    switch (serviceType) {
      case 'preventive':
        return Colors.green;
      case 'repair':
        return Colors.red;
      case 'inspection':
        return Colors.blue;
      case 'emergency':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Service History'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCustomer,
              decoration: const InputDecoration(labelText: 'Customer'),
              items: [
                const DropdownMenuItem(value: 'all', child: Text('All Customers')),
                ..._serviceHistory.map((service) => service['customer']).toSet().map((customer) {
                  return DropdownMenuItem(value: customer, child: Text(customer));
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCustomer = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedEquipment,
              decoration: const InputDecoration(labelText: 'Equipment'),
              items: [
                const DropdownMenuItem(value: 'all', child: Text('All Equipment')),
                ..._serviceHistory.map((service) => service['equipment']).toSet().map((equipment) {
                  return DropdownMenuItem(value: equipment, child: Text(equipment));
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedEquipment = value!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {});
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _addServiceRecord() {
    // Navigate to add service record screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add new service record')),
    );
  }

  void _showServiceDetails(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.6,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    service['id'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                service['equipment'],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                service['customer'],
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Service Type', service['serviceType'].toUpperCase()),
              _buildDetailRow('Technician', service['technician']),
              _buildDetailRow('Service Date', DateFormat('MMM dd, yyyy').format(service['serviceDate'])),
              _buildDetailRow('Next Service', DateFormat('MMM dd, yyyy').format(service['nextServiceDate'])),
              _buildDetailRow('Duration', '${service['duration']} hours'),
              _buildDetailRow('Cost', '\$${service['cost'].toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(service['description']),
              const SizedBox(height: 16),
              const Text(
                'Parts Used',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (service['parts'].isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: service['parts'].map<Widget>((part) {
                    return Chip(label: Text(part));
                  }).toList(),
                )
              else
                const Text('No parts used', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              const Text(
                'Notes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(service['notes']),
              const SizedBox(height: 16),
              const Text(
                'Photos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (service['photos'].isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: service['photos'].length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.photo, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                )
              else
                const Text('No photos', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
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

  void _viewServiceReport(Map<String, dynamic> service) {
    // Navigate to service report screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View service report ${service['id']}')),
    );
  }

  void _scheduleFollowUp(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule Follow-up'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Follow-up Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {
                // Show date picker
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Follow-up scheduled')),
              );
            },
            child: const Text('Schedule'),
          ),
        ],
      ),
    );
  }
} 