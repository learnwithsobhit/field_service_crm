import 'package:flutter/material.dart';
import 'invoice_detail_screen.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> _invoices = [
    {
      'id': 'INV-001',
      'jobId': 'JOB001',
      'clientName': 'Green Valley Restaurant',
      'clientEmail': 'manager@greenvalley.com',
      'clientPhone': '+1 (555) 123-4567',
      'jobTitle': 'Quarterly Pest Control Service',
      'amount': 450.00,
      'taxAmount': 36.00,
      'totalAmount': 486.00,
      'status': 'paid',
      'dueDate': DateTime.now().subtract(const Duration(days: 5)),
      'issuedDate': DateTime.now().subtract(const Duration(days: 30)),
      'paidDate': DateTime.now().subtract(const Duration(days: 3)),
      'paymentMethod': 'Credit Card',
      'items': [
        {'description': 'Pest Control Treatment', 'quantity': 1, 'rate': 300.00, 'amount': 300.00},
        {'description': 'Follow-up Visit', 'quantity': 1, 'rate': 150.00, 'amount': 150.00},
      ],
      'notes': 'Regular quarterly maintenance completed successfully.',
    },
    {
      'id': 'INV-002',
      'jobId': 'JOB002',
      'clientName': 'Tech Solutions Inc.',
      'clientEmail': 'billing@techsolutions.com',
      'clientPhone': '+1 (555) 234-5678',
      'jobTitle': 'HVAC System Inspection',
      'amount': 275.00,
      'taxAmount': 22.00,
      'totalAmount': 297.00,
      'status': 'overdue',
      'dueDate': DateTime.now().subtract(const Duration(days: 15)),
      'issuedDate': DateTime.now().subtract(const Duration(days: 45)),
      'paidDate': null,
      'paymentMethod': null,
      'items': [
        {'description': 'HVAC System Inspection', 'quantity': 1, 'rate': 200.00, 'amount': 200.00},
        {'description': 'Filter Replacement', 'quantity': 3, 'rate': 25.00, 'amount': 75.00},
      ],
      'notes': 'Annual HVAC maintenance and filter replacement.',
    },
    {
      'id': 'INV-003',
      'jobId': 'JOB003',
      'clientName': 'Downtown Office Building',
      'clientEmail': 'facilities@downtown.com',
      'clientPhone': '+1 (555) 345-6789',
      'jobTitle': 'Emergency HVAC Repair',
      'amount': 850.00,
      'taxAmount': 68.00,
      'totalAmount': 918.00,
      'status': 'pending',
      'dueDate': DateTime.now().add(const Duration(days: 15)),
      'issuedDate': DateTime.now().subtract(const Duration(days: 2)),
      'paidDate': null,
      'paymentMethod': null,
      'items': [
        {'description': 'Emergency Service Call', 'quantity': 1, 'rate': 150.00, 'amount': 150.00},
        {'description': 'HVAC System Repair', 'quantity': 4, 'rate': 125.00, 'amount': 500.00},
        {'description': 'Replacement Parts', 'quantity': 1, 'rate': 200.00, 'amount': 200.00},
      ],
      'notes': 'Emergency repair completed. System fully operational.',
      'priority': 'high',
    },
    {
      'id': 'INV-004',
      'jobId': 'JOB004',
      'clientName': 'Residential Home',
      'clientEmail': 'sarah.homeowner@email.com',
      'clientPhone': '+1 (555) 456-7890',
      'jobTitle': 'Electrical Safety Inspection',
      'amount': 180.00,
      'taxAmount': 14.40,
      'totalAmount': 194.40,
      'status': 'draft',
      'dueDate': DateTime.now().add(const Duration(days: 30)),
      'issuedDate': null,
      'paidDate': null,
      'paymentMethod': null,
      'items': [
        {'description': 'Electrical Safety Inspection', 'quantity': 1, 'rate': 150.00, 'amount': 150.00},
        {'description': 'Minor Outlet Repair', 'quantity': 1, 'rate': 30.00, 'amount': 30.00},
      ],
      'notes': 'Routine safety inspection with minor repairs.',
    },
    {
      'id': 'INV-005',
      'jobId': 'JOB005',
      'clientName': 'City Plaza Mall',
      'clientEmail': 'management@cityplaza.com',
      'clientPhone': '+1 (555) 567-8901',
      'jobTitle': 'Monthly Pest Control Service',
      'amount': 750.00,
      'taxAmount': 60.00,
      'totalAmount': 810.00,
      'status': 'sent',
      'dueDate': DateTime.now().add(const Duration(days: 10)),
      'issuedDate': DateTime.now().subtract(const Duration(days: 5)),
      'paidDate': null,
      'paymentMethod': null,
      'items': [
        {'description': 'Monthly Pest Control', 'quantity': 1, 'rate': 500.00, 'amount': 500.00},
        {'description': 'Additional Treatment Areas', 'quantity': 5, 'rate': 50.00, 'amount': 250.00},
      ],
      'notes': 'Monthly service for large commercial facility.',
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
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredInvoices {
    List<Map<String, dynamic>> filtered = _invoices;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((invoice) {
        final id = invoice['id'].toString().toLowerCase();
        final clientName = invoice['clientName'].toString().toLowerCase();
        final jobTitle = invoice['jobTitle'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return id.contains(query) || clientName.contains(query) || jobTitle.contains(query);
      }).toList();
    }

    // Filter by status
    if (_selectedFilter != 'all') {
      filtered = filtered.where((invoice) => invoice['status'] == _selectedFilter).toList();
    }

    // Sort by issued date (newest first)
    filtered.sort((a, b) {
      final aDate = a['issuedDate'] ?? DateTime.now();
      final bDate = b['issuedDate'] ?? DateTime.now();
      return bDate.compareTo(aDate);
    });

    return filtered;
  }

  double get _totalRevenue => _invoices.where((inv) => inv['status'] == 'paid').fold(0.0, (sum, inv) => sum + inv['totalAmount']);
  double get _pendingAmount => _invoices.where((inv) => inv['status'] != 'paid' && inv['status'] != 'draft').fold(0.0, (sum, inv) => sum + inv['totalAmount']);
  int get _overdueCount => _invoices.where((inv) => inv['status'] == 'overdue').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoicing & Payments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showFinancialReports,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMoreOptions,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All', icon: Icon(Icons.receipt_long)),
            Tab(text: 'Pending', icon: Icon(Icons.pending)),
            Tab(text: 'Overdue', icon: Icon(Icons.warning)),
            Tab(text: 'Paid', icon: Icon(Icons.check_circle)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search invoices by ID, client, or job...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Financial Summary Cards
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _buildSummaryCard('Total Revenue', '\$${_totalRevenue.toStringAsFixed(2)}', Icons.trending_up, Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('Pending', '\$${_pendingAmount.toStringAsFixed(2)}', Icons.pending, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('Overdue', '$_overdueCount invoices', Icons.warning, Colors.red)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInvoicesList('all'),
                _buildInvoicesList('pending'),
                _buildInvoicesList('overdue'),
                _buildInvoicesList('paid'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewInvoice,
        backgroundColor: const Color(0xFF14B8A6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoicesList(String filter) {
    List<Map<String, dynamic>> invoices = _filteredInvoices;
    
    if (filter != 'all') {
      invoices = invoices.where((invoice) => invoice['status'] == filter).toList();
    }

    if (invoices.isEmpty) {
      return _buildEmptyState(filter);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          final invoice = invoices[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildInvoiceCard(invoice),
          );
        },
      ),
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> invoice) {
    final Color statusColor = _getStatusColor(invoice['status']);
    final IconData statusIcon = _getStatusIcon(invoice['status']);
    final bool isOverdue = invoice['status'] == 'overdue';
    final bool isPaid = invoice['status'] == 'paid';

    return Card(
      elevation: isOverdue ? 4 : 2,
      color: isOverdue ? Colors.red[50] : null,
      child: InkWell(
        onTap: () => _viewInvoiceDetail(invoice),
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
                        Row(
                          children: [
                            Text(
                              invoice['id'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                invoice['status'].toString().toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          invoice['clientName'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Job Info
              Text(
                invoice['jobTitle'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              
              // Amount and Dates
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '\$${invoice['totalAmount'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF14B8A6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPaid ? 'Paid Date' : 'Due Date',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _formatDate(isPaid ? invoice['paidDate'] : invoice['dueDate']),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isOverdue ? Colors.red : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (invoice['status'] != 'paid' && invoice['status'] != 'draft')
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => _processPayment(invoice),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                          ),
                          child: const Text('Pay Now', style: TextStyle(fontSize: 12)),
                        ),
                        if (isOverdue)
                          TextButton(
                            onPressed: () => _sendReminder(invoice),
                            child: const Text('Send Reminder', style: TextStyle(fontSize: 10)),
                          ),
                      ],
                    ),
                ],
              ),
              
              // Quick Actions
              const SizedBox(height: 12),
              Row(
                children: [
                  if (invoice['status'] == 'draft') ...[
                    OutlinedButton.icon(
                      onPressed: () => _editInvoice(invoice),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _sendInvoice(invoice),
                      icon: const Icon(Icons.send, size: 16),
                      label: const Text('Send'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14B8A6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                    ),
                  ] else ...[
                    OutlinedButton.icon(
                      onPressed: () => _downloadInvoice(invoice),
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Download'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => _shareInvoice(invoice),
                      icon: const Icon(Icons.share, size: 16),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String filter) {
    String title = 'No invoices found';
    String subtitle = 'Create your first invoice to get started';
    
    switch (filter) {
      case 'pending':
        title = 'No pending invoices';
        subtitle = 'All invoices are either paid or in draft';
        break;
      case 'overdue':
        title = 'No overdue invoices';
        subtitle = 'Great! All payments are up to date';
        break;
      case 'paid':
        title = 'No paid invoices';
        subtitle = 'Completed payments will appear here';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            filter == 'overdue' ? Icons.check_circle : Icons.receipt_long,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'pending':
      case 'sent':
        return Colors.blue;
      case 'overdue':
        return Colors.red;
      case 'draft':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'paid':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'sent':
        return Icons.send;
      case 'overdue':
        return Icons.warning;
      case 'draft':
        return Icons.drafts;
      default:
        return Icons.receipt;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.day}/${date.month}/${date.year}';
  }

  // Action handlers
  void _createNewInvoice() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateInvoiceScreen(),
      ),
    );
  }

  void _viewInvoiceDetail(Map<String, dynamic> invoice) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InvoiceDetailScreen(invoice: invoice),
      ),
    );
  }

  void _editInvoice(Map<String, dynamic> invoice) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateInvoiceScreen(invoice: invoice),
      ),
    );
  }

  void _sendInvoice(Map<String, dynamic> invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Invoice'),
        content: Text('Send invoice ${invoice['id']} to ${invoice['clientName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                invoice['status'] = 'sent';
                invoice['issuedDate'] = DateTime.now();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invoice ${invoice['id']} sent successfully')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _processPayment(Map<String, dynamic> invoice) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentProcessingScreen(invoice: invoice),
      ),
    );
  }

  void _sendReminder(Map<String, dynamic> invoice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment reminder sent for ${invoice['id']}')),
    );
  }

  void _downloadInvoice(Map<String, dynamic> invoice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${invoice['id']}.pdf')),
    );
  }

  void _shareInvoice(Map<String, dynamic> invoice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${invoice['id']}')),
    );
  }

  void _showFinancialReports() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FinancialReportsScreen(),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Invoice Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('Export All Invoices'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting all invoices...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Invoice Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invoice settings coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder screens that will be implemented next
class FinancialReportsScreen extends StatelessWidget {
  const FinancialReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Reports'),
      ),
      body: const Center(
        child: Text('Financial Reports Screen - Implementation coming next!'),
      ),
    );
  }
} 