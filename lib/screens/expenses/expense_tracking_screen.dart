import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseTrackingScreen extends StatefulWidget {
  const ExpenseTrackingScreen({super.key});

  @override
  State<ExpenseTrackingScreen> createState() => _ExpenseTrackingScreenState();
}

class _ExpenseTrackingScreenState extends State<ExpenseTrackingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _filterStatus = 'all';
  String _filterCategory = 'all';
  Map<String, dynamic>? _selectedExpense;

  final List<Map<String, dynamic>> _expenses = [
    {
      'id': '1',
      'technician': 'Maya Chen',
      'category': 'travel',
      'description': 'Gas for service vehicle',
      'amount': 45.50,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'approved',
      'approvedBy': 'Sam Rodriguez',
      'approvedDate': DateTime.now().subtract(const Duration(hours: 2)),
      'receipt': 'receipt_001.jpg',
      'jobId': '1',
      'jobTitle': 'Quarterly Pest Control',
      'location': 'Office Complex A',
      'notes': 'Filled up tank before heading to job site',
    },
    {
      'id': '2',
      'technician': 'Ravi Patel',
      'category': 'materials',
      'description': 'HVAC filters and parts',
      'amount': 125.75,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'pending',
      'approvedBy': null,
      'approvedDate': null,
      'receipt': 'receipt_002.jpg',
      'jobId': '2',
      'jobTitle': 'HVAC Maintenance',
      'location': 'Community Center',
      'notes': 'Replaced air filters and thermostat sensor',
    },
    {
      'id': '3',
      'technician': 'Arjun Singh',
      'category': 'emergency',
      'description': 'Emergency plumbing supplies',
      'amount': 89.25,
      'date': DateTime.now().subtract(const Duration(hours: 6)),
      'status': 'approved',
      'approvedBy': 'Sam Rodriguez',
      'approvedDate': DateTime.now().subtract(const Duration(hours: 5)),
      'receipt': 'receipt_003.jpg',
      'jobId': '3',
      'jobTitle': 'Emergency Plumbing',
      'location': 'Residential Building',
      'notes': 'Urgent repair - pipe burst emergency',
    },
    {
      'id': '4',
      'technician': 'Sarah Williams',
      'category': 'meals',
      'description': 'Lunch during long job',
      'amount': 18.50,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'rejected',
      'approvedBy': 'Sam Rodriguez',
      'approvedDate': DateTime.now().subtract(const Duration(hours: 1)),
      'receipt': 'receipt_004.jpg',
      'jobId': '4',
      'jobTitle': 'Electrical Inspection',
      'location': 'New Construction',
      'notes': 'Rejected - meal expenses not covered for local jobs',
    },
    {
      'id': '5',
      'technician': 'Maya Chen',
      'category': 'tools',
      'description': 'Replacement drill bits',
      'amount': 32.00,
      'date': DateTime.now(),
      'status': 'pending',
      'approvedBy': null,
      'approvedDate': null,
      'receipt': 'receipt_005.jpg',
      'jobId': '1',
      'jobTitle': 'Quarterly Pest Control',
      'location': 'Office Complex A',
      'notes': 'Drill bits worn out during installation',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {'id': 'travel', 'name': 'Travel', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'id': 'materials', 'name': 'Materials', 'icon': Icons.build, 'color': Colors.green},
    {'id': 'tools', 'name': 'Tools', 'icon': Icons.handyman, 'color': Colors.orange},
    {'id': 'meals', 'name': 'Meals', 'icon': Icons.restaurant, 'color': Colors.purple},
    {'id': 'emergency', 'name': 'Emergency', 'icon': Icons.emergency, 'color': Colors.red},
    {'id': 'other', 'name': 'Other', 'icon': Icons.more_horiz, 'color': Colors.grey},
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

  List<Map<String, dynamic>> get _filteredExpenses {
    return _expenses.where((expense) {
      final matchesSearch = expense['description'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          expense['technician'].toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesStatus = _filterStatus == 'all' || expense['status'] == _filterStatus;
      final matchesCategory = _filterCategory == 'all' || expense['category'] == _filterCategory;
      
      return matchesSearch && matchesStatus && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Expenses',
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showExpenseReports,
            tooltip: 'Expense Reports',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Expenses'),
            Tab(text: 'Categories'),
            Tab(text: 'Approvals'),
            Tab(text: 'Reports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExpensesTab(),
          _buildCategoriesTab(),
          _buildApprovalsTab(),
          _buildReportsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'expense_fab',
        onPressed: _addNewExpense,
        backgroundColor: const Color(0xFF14B8A6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildExpensesTab() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: _filteredExpenses.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No expenses found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = _filteredExpenses[index];
                    return _buildExpenseCard(expense);
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
          hintText: 'Search expenses...',
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

  Widget _buildExpenseCard(Map<String, dynamic> expense) {
    final category = _categories.firstWhere((cat) => cat['id'] == expense['category']);
    final statusColor = _getStatusColor(expense['status']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: category['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            category['icon'],
            color: category['color'],
          ),
        ),
        title: Text(
          expense['description'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense['technician']),
            Text(
              '${DateFormat('MMM dd, yyyy').format(expense['date'])} • ${expense['jobTitle']}',
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
                    expense['status'].toUpperCase(),
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
                    color: category['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category['name'].toUpperCase(),
                    style: TextStyle(
                      color: category['color'],
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
              '\$${expense['amount'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 16,
              ),
            ),
            if (expense['receipt'] != null)
              Icon(
                Icons.receipt,
                color: Colors.blue,
                size: 16,
              ),
          ],
        ),
        onTap: () => _showExpenseDetails(expense),
      ),
    );
  }

  Widget _buildCategoriesTab() {
    final categoryTotals = <String, double>{};
    for (final expense in _expenses) {
      final category = expense['category'];
      categoryTotals[category] = (categoryTotals[category] ?? 0) + expense['amount'];
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expense Categories',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Category Summary Cards
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final total = categoryTotals[category['id']] ?? 0.0;
              final count = _expenses.where((e) => e['category'] == category['id']).length;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildCategoryCard(category, total, count),
              );
            },
          ),
          const SizedBox(height: 24),
          
          // Category Breakdown
          Text(
            'Category Breakdown',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final total = categoryTotals[category['id']] ?? 0.0;
                final count = _expenses.where((e) => e['category'] == category['id']).length;
                final percentage = _expenses.isNotEmpty ? (total / _expenses.fold<double>(0, (sum, e) => sum + e['amount']) * 100) : 0;
                
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: category['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      category['icon'],
                      color: category['color'],
                      size: 20,
                    ),
                  ),
                  title: Text(category['name']),
                  subtitle: Text('$count expenses'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, double total, int count) {
    return Card(
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: category['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Icon(
                category['icon'],
                color: category['color'],
                size: 10,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalsTab() {
    final pendingExpenses = _expenses.where((e) => e['status'] == 'pending').toList();
    final approvedExpenses = _expenses.where((e) => e['status'] == 'approved').toList();
    final rejectedExpenses = _expenses.where((e) => e['status'] == 'rejected').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Approval Stats
          Row(
            children: [
              Expanded(
                child: _buildApprovalStatCard('Pending', pendingExpenses.length, Colors.orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildApprovalStatCard('Approved', approvedExpenses.length, Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildApprovalStatCard('Rejected', rejectedExpenses.length, Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Pending Approvals
          if (pendingExpenses.isNotEmpty) ...[
            Text(
              'Pending Approvals',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...pendingExpenses.map((expense) => _buildApprovalCard(expense)),
            const SizedBox(height: 24),
          ],
          
          // Recent Approvals
          Text(
            'Recent Approvals',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...approvedExpenses.take(3).map((expense) => _buildApprovalCard(expense)),
        ],
      ),
    );
  }

  Widget _buildApprovalStatCard(String label, int count, Color color) {
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
            count.toString(),
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

  Widget _buildApprovalCard(Map<String, dynamic> expense) {
    final statusColor = _getStatusColor(expense['status']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF14B8A6),
          child: Text(
            expense['technician'][0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(expense['description']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense['technician']),
            Text(
              DateFormat('MMM dd, yyyy').format(expense['date']),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${expense['amount'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                expense['status'].toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showApprovalDialog(expense),
      ),
    );
  }

  Widget _buildReportsTab() {
    final totalExpenses = _expenses.fold<double>(0, (sum, e) => sum + e['amount']);
    final approvedExpenses = _expenses.where((e) => e['status'] == 'approved').fold<double>(0, (sum, e) => sum + e['amount']);
    final pendingExpenses = _expenses.where((e) => e['status'] == 'pending').fold<double>(0, (sum, e) => sum + e['amount']);
    final rejectedExpenses = _expenses.where((e) => e['status'] == 'rejected').fold<double>(0, (sum, e) => sum + e['amount']);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expense Reports',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildReportCard('Total Expenses', totalExpenses, Icons.account_balance_wallet, Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildReportCard('Approved', approvedExpenses, Icons.check_circle, Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildReportCard('Pending', pendingExpenses, Icons.pending, Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildReportCard('Rejected', rejectedExpenses, Icons.cancel, Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Monthly Trend
          Text(
            'Monthly Trend',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildMonthlyTrendChart(),
          const SizedBox(height: 24),
          
          // Top Technicians
          Text(
            'Top Technicians by Expenses',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTopTechniciansList(),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, double amount, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              '\$${amount.toStringAsFixed(2)}',
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

  Widget _buildMonthlyTrendChart() {
    // Simplified monthly trend chart
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('January'),
                const Text('February'),
                const Text('March'),
                const Text('April'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 40,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 40,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 40,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTechniciansList() {
    final technicianTotals = <String, double>{};
    for (final expense in _expenses) {
      final technician = expense['technician'];
      technicianTotals[technician] = (technicianTotals[technician] ?? 0) + expense['amount'];
    }

    final sortedTechnicians = technicianTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sortedTechnicians.take(5).length,
        itemBuilder: (context, index) {
          final entry = sortedTechnicians[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF14B8A6),
              child: Text(
                entry.key[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(entry.key),
            trailing: Text(
              '\$${entry.value.toStringAsFixed(2)}',
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
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Expenses'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Status'),
              value: _filterStatus,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'approved', child: Text('Approved')),
                DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
              ],
              onChanged: (value) {
                setState(() {
                  _filterStatus = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Category'),
              value: _filterCategory,
              items: [
                const DropdownMenuItem(value: 'all', child: Text('All Categories')),
                ..._categories.map((category) => DropdownMenuItem(
                  value: category['id'],
                  child: Text(category['name']),
                )),
              ],
              onChanged: (value) {
                setState(() {
                  _filterCategory = value!;
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

  void _showExpenseReports() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Expense Reports'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Generate detailed expense reports.'),
            SizedBox(height: 16),
            Text('Available reports:'),
            SizedBox(height: 8),
            Text('• Monthly expense summary'),
            Text('• Category-wise breakdown'),
            Text('• Technician expense analysis'),
            Text('• Approval workflow report'),
            Text('• Budget vs actual comparison'),
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
                const SnackBar(content: Text('Expense reports coming soon!')),
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Expense'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add a new expense entry.'),
            SizedBox(height: 16),
            Text('This will include:'),
            SizedBox(height: 8),
            Text('• Expense details'),
            Text('• Category selection'),
            Text('• Receipt upload'),
            Text('• Job association'),
            Text('• Approval workflow'),
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
                const SnackBar(content: Text('Add expense form coming soon!')),
              );
            },
            child: const Text('Add Expense'),
          ),
        ],
      ),
    );
  }

  void _showExpenseDetails(Map<String, dynamic> expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Expense Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Description', expense['description']),
              _buildDetailRow('Technician', expense['technician']),
              _buildDetailRow('Amount', '\$${expense['amount'].toStringAsFixed(2)}'),
              _buildDetailRow('Date', DateFormat('MMM dd, yyyy').format(expense['date'])),
              _buildDetailRow('Status', expense['status'].toUpperCase()),
              _buildDetailRow('Job', expense['jobTitle']),
              _buildDetailRow('Location', expense['location']),
              if (expense['approvedBy'] != null)
                _buildDetailRow('Approved By', expense['approvedBy']),
              if (expense['approvedDate'] != null)
                _buildDetailRow('Approved Date', DateFormat('MMM dd, yyyy').format(expense['approvedDate'])),
              if (expense['notes'] != null)
                _buildDetailRow('Notes', expense['notes']),
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
              _editExpense(expense);
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

  void _showApprovalDialog(Map<String, dynamic> expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Review Expense'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Description: ${expense['description']}'),
            Text('Amount: \$${expense['amount'].toStringAsFixed(2)}'),
            Text('Technician: ${expense['technician']}'),
            Text('Date: ${DateFormat('MMM dd, yyyy').format(expense['date'])}'),
            if (expense['notes'] != null) Text('Notes: ${expense['notes']}'),
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
              _approveExpense(expense);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Approve'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _rejectExpense(expense);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _approveExpense(Map<String, dynamic> expense) {
    setState(() {
      final index = _expenses.indexWhere((e) => e['id'] == expense['id']);
      if (index != -1) {
        _expenses[index]['status'] = 'approved';
        _expenses[index]['approvedBy'] = 'Sam Rodriguez';
        _expenses[index]['approvedDate'] = DateTime.now();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${expense['description']} approved'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rejectExpense(Map<String, dynamic> expense) {
    setState(() {
      final index = _expenses.indexWhere((e) => e['id'] == expense['id']);
      if (index != -1) {
        _expenses[index]['status'] = 'rejected';
        _expenses[index]['approvedBy'] = 'Sam Rodriguez';
        _expenses[index]['approvedDate'] = DateTime.now();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${expense['description']} rejected'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _editExpense(Map<String, dynamic> expense) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${expense['description']} coming soon!')),
    );
  }
} 