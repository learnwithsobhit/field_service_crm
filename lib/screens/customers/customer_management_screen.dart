import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  State<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _filterStatus = 'all';
  Map<String, dynamic>? _selectedCustomer;

  final List<Map<String, dynamic>> _customers = [
    {
      'id': '1',
      'name': 'Office Complex A',
      'type': 'commercial',
      'contactPerson': 'John Smith',
      'email': 'john.smith@officecomplex.com',
      'phone': '+1 (555) 123-4567',
      'address': '123 Business Blvd, Downtown, NY 10001',
      'status': 'active',
      'totalSpent': 12500.00,
      'lastService': DateTime.now().subtract(const Duration(days: 5)),
      'nextService': DateTime.now().add(const Duration(days: 25)),
      'serviceHistory': [
        {
          'date': DateTime.now().subtract(const Duration(days: 5)),
          'service': 'Quarterly Pest Control',
          'amount': 850.00,
          'status': 'completed',
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 35)),
          'service': 'HVAC Maintenance',
          'amount': 1200.00,
          'status': 'completed',
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 65)),
          'service': 'Emergency Plumbing',
          'amount': 450.00,
          'status': 'completed',
        },
      ],
      'notes': 'Prefers morning appointments. Building manager is very responsive.',
      'contracts': [
        {
          'id': 'CON-001',
          'type': 'Annual Service',
          'startDate': DateTime.now().subtract(const Duration(days: 90)),
          'endDate': DateTime.now().add(const Duration(days: 275)),
          'value': 8500.00,
          'status': 'active',
        },
      ],
    },
    {
      'id': '2',
      'name': 'Community Center',
      'type': 'public',
      'contactPerson': 'Sarah Johnson',
      'email': 'sarah.johnson@communitycenter.org',
      'phone': '+1 (555) 234-5678',
      'address': '456 Community St, Midtown, NY 10002',
      'status': 'active',
      'totalSpent': 8900.00,
      'lastService': DateTime.now().subtract(const Duration(days: 2)),
      'nextService': DateTime.now().add(const Duration(days: 28)),
      'serviceHistory': [
        {
          'date': DateTime.now().subtract(const Duration(days: 2)),
          'service': 'HVAC Maintenance',
          'amount': 1200.00,
          'status': 'completed',
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 32)),
          'service': 'Electrical Inspection',
          'amount': 800.00,
          'status': 'completed',
        },
      ],
      'notes': 'Public facility with high traffic. Requires flexible scheduling.',
      'contracts': [
        {
          'id': 'CON-002',
          'type': 'Quarterly Maintenance',
          'startDate': DateTime.now().subtract(const Duration(days: 60)),
          'endDate': DateTime.now().add(const Duration(days: 305)),
          'value': 4800.00,
          'status': 'active',
        },
      ],
    },
    {
      'id': '3',
      'name': 'Residential Building',
      'type': 'residential',
      'contactPerson': 'Mike Davis',
      'email': 'mike.davis@residential.com',
      'phone': '+1 (555) 345-6789',
      'address': '789 Residential Ave, Uptown, NY 10003',
      'status': 'active',
      'totalSpent': 3200.00,
      'lastService': DateTime.now().subtract(const Duration(hours: 12)),
      'nextService': null,
      'serviceHistory': [
        {
          'date': DateTime.now().subtract(const Duration(hours: 12)),
          'service': 'Emergency Plumbing',
          'amount': 450.00,
          'status': 'completed',
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 15)),
          'service': 'General Maintenance',
          'amount': 300.00,
          'status': 'completed',
        },
      ],
      'notes': 'Emergency contact for building. 24/7 availability required.',
      'contracts': [],
    },
    {
      'id': '4',
      'name': 'New Construction Site',
      'type': 'construction',
      'contactPerson': 'Lisa Chen',
      'email': 'lisa.chen@construction.com',
      'phone': '+1 (555) 456-7890',
      'address': '321 Development Dr, New Area, NY 10004',
      'status': 'pending',
      'totalSpent': 0.00,
      'lastService': null,
      'nextService': DateTime.now().add(const Duration(days: 3)),
      'serviceHistory': [],
      'notes': 'New construction project. Electrical inspection scheduled.',
      'contracts': [
        {
          'id': 'CON-003',
          'type': 'Construction Support',
          'startDate': DateTime.now().add(const Duration(days: 3)),
          'endDate': DateTime.now().add(const Duration(days: 90)),
          'value': 15000.00,
          'status': 'pending',
        },
      ],
    },
    {
      'id': '5',
      'name': 'Retail Store Chain',
      'type': 'commercial',
      'contactPerson': 'David Wilson',
      'email': 'david.wilson@retailchain.com',
      'phone': '+1 (555) 567-8901',
      'address': 'Multiple Locations',
      'status': 'active',
      'totalSpent': 25000.00,
      'lastService': DateTime.now().subtract(const Duration(days: 1)),
      'nextService': DateTime.now().add(const Duration(days: 7)),
      'serviceHistory': [
        {
          'date': DateTime.now().subtract(const Duration(days: 1)),
          'service': 'Multi-location HVAC Service',
          'amount': 3500.00,
          'status': 'completed',
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 30)),
          'service': 'Preventive Maintenance',
          'amount': 2800.00,
          'status': 'completed',
        },
      ],
      'notes': 'Chain with 5 locations. Bulk pricing applied.',
      'contracts': [
        {
          'id': 'CON-004',
          'type': 'Multi-location Service',
          'startDate': DateTime.now().subtract(const Duration(days: 45)),
          'endDate': DateTime.now().add(const Duration(days: 320)),
          'value': 25000.00,
          'status': 'active',
        },
      ],
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

  List<Map<String, dynamic>> get _filteredCustomers {
    return _customers.where((customer) {
      final matchesSearch = customer['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer['contactPerson'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer['email'].toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesFilter = _filterStatus == 'all' || customer['status'] == _filterStatus;
      
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Customers',
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showAnalytics,
            tooltip: 'Customer Analytics',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Customers'),
            Tab(text: 'Contracts'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCustomersTab(),
          _buildContractsTab(),
          _buildAnalyticsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'customer_fab',
        onPressed: _addNewCustomer,
        backgroundColor: const Color(0xFF14B8A6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCustomersTab() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: _filteredCustomers.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No customers found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = _filteredCustomers[index];
                    return _buildCustomerCard(customer);
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
          hintText: 'Search customers...',
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

  Widget _buildCustomerCard(Map<String, dynamic> customer) {
    final statusColor = _getStatusColor(customer['status']);
    final typeColor = _getTypeColor(customer['type']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: typeColor,
          child: Text(
            customer['name'][0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          customer['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customer['contactPerson']),
            Text(
              customer['email'],
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    customer['type'].toUpperCase(),
                    style: TextStyle(
                      color: typeColor,
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
                    customer['status'].toUpperCase(),
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
            Text(
              '\$${customer['totalSpent'].toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              'Total Spent',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        onTap: () => _showCustomerDetails(customer),
      ),
    );
  }

  Widget _buildContractsTab() {
    final allContracts = <Map<String, dynamic>>[];
    for (final customer in _customers) {
      for (final contract in customer['contracts']) {
        allContracts.add({
          ...contract,
          'customerName': customer['name'],
          'customerContact': customer['contactPerson'],
        });
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allContracts.length,
      itemBuilder: (context, index) {
        final contract = allContracts[index];
        return _buildContractCard(contract);
      },
    );
  }

  Widget _buildContractCard(Map<String, dynamic> contract) {
    final statusColor = _getContractStatusColor(contract['status']);
    final isActive = contract['status'] == 'active';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isActive ? Icons.description : Icons.pending,
            color: statusColor,
          ),
        ),
        title: Text(contract['type']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contract['customerName']),
            Text(
              '${DateFormat('MMM dd, yyyy').format(contract['startDate'])} - ${DateFormat('MMM dd, yyyy').format(contract['endDate'])}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${contract['value'].toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                contract['status'].toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showContractDetails(contract),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    final totalCustomers = _customers.length;
    final activeCustomers = _customers.where((c) => c['status'] == 'active').length;
    final totalRevenue = _customers.fold<double>(0, (sum, c) => sum + c['totalSpent']);
    final avgRevenue = totalRevenue / totalCustomers;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Analytics',
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
                  'Total Customers',
                  totalCustomers.toString(),
                  Icons.people,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard(
                  'Active Customers',
                  activeCustomers.toString(),
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
                  'Total Revenue',
                  '\$${totalRevenue.toStringAsFixed(0)}',
                  Icons.attach_money,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard(
                  'Avg Revenue',
                  '\$${avgRevenue.toStringAsFixed(0)}',
                  Icons.trending_up,
                  Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Customer Types
          Text(
            'Customer Types',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildCustomerTypeChart(),
          const SizedBox(height: 24),
          
          // Top Customers
          Text(
            'Top Customers by Revenue',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTopCustomersList(),
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

  Widget _buildCustomerTypeChart() {
    final typeCounts = <String, int>{};
    for (final customer in _customers) {
      typeCounts[customer['type']] = (typeCounts[customer['type']] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: typeCounts.entries.map((entry) {
            final percentage = (entry.value / _customers.length * 100).toStringAsFixed(1);
            return ListTile(
              leading: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _getTypeColor(entry.key),
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

  Widget _buildTopCustomersList() {
    final sortedCustomers = List<Map<String, dynamic>>.from(_customers);
    sortedCustomers.sort((a, b) => b['totalSpent'].compareTo(a['totalSpent']));

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sortedCustomers.take(5).length,
        itemBuilder: (context, index) {
          final customer = sortedCustomers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _getTypeColor(customer['type']),
              child: Text(
                customer['name'][0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(customer['name']),
            subtitle: Text(customer['contactPerson']),
            trailing: Text(
              '\$${customer['totalSpent'].toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'inactive':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'commercial':
        return Colors.blue;
      case 'residential':
        return Colors.green;
      case 'public':
        return Colors.purple;
      case 'construction':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getContractStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Customers'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Status'),
              value: _filterStatus,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
              ],
              onChanged: (value) {
                setState(() {
                  _filterStatus = value!;
                });
                Navigator.pop(context);
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

  void _showAnalytics() {
    // Navigate to detailed analytics screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Detailed analytics coming soon!')),
    );
  }

  void _addNewCustomer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Customer'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add a new customer to the system.'),
            SizedBox(height: 16),
            Text('This will include:'),
            SizedBox(height: 8),
            Text('• Customer information'),
            Text('• Contact details'),
            Text('• Service preferences'),
            Text('• Contract management'),
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
                const SnackBar(content: Text('Add customer form coming soon!')),
              );
            },
            child: const Text('Add Customer'),
          ),
        ],
      ),
    );
  }

  void _showCustomerDetails(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(customer['name']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Contact Person', customer['contactPerson']),
              _buildDetailRow('Email', customer['email']),
              _buildDetailRow('Phone', customer['phone']),
              _buildDetailRow('Address', customer['address']),
              _buildDetailRow('Type', customer['type'].toUpperCase()),
              _buildDetailRow('Status', customer['status'].toUpperCase()),
              _buildDetailRow('Total Spent', '\$${customer['totalSpent'].toStringAsFixed(2)}'),
              if (customer['lastService'] != null)
                _buildDetailRow('Last Service', DateFormat('MMM dd, yyyy').format(customer['lastService'])),
              if (customer['nextService'] != null)
                _buildDetailRow('Next Service', DateFormat('MMM dd, yyyy').format(customer['nextService'])),
              const SizedBox(height: 16),
              const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(customer['notes']),
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
              _editCustomer(customer);
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

  void _showContractDetails(Map<String, dynamic> contract) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(contract['type']),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Customer', contract['customerName']),
            _buildDetailRow('Contact', contract['customerContact']),
            _buildDetailRow('Start Date', DateFormat('MMM dd, yyyy').format(contract['startDate'])),
            _buildDetailRow('End Date', DateFormat('MMM dd, yyyy').format(contract['endDate'])),
            _buildDetailRow('Value', '\$${contract['value'].toStringAsFixed(2)}'),
            _buildDetailRow('Status', contract['status'].toUpperCase()),
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
              _editContract(contract);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _editCustomer(Map<String, dynamic> customer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${customer['name']} coming soon!')),
    );
  }

  void _editContract(Map<String, dynamic> contract) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${contract['type']} contract coming soon!')),
    );
  }
} 