import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QualityAssuranceScreen extends StatefulWidget {
  const QualityAssuranceScreen({super.key});

  @override
  State<QualityAssuranceScreen> createState() => _QualityAssuranceScreenState();
}

class _QualityAssuranceScreenState extends State<QualityAssuranceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedInspector = 'all';
  String _selectedStatus = 'all';

  final List<Map<String, dynamic>> _inspections = [
    {
      'id': 'QA-001',
      'jobId': 'JOB-2024-001',
      'customer': 'Downtown Office Complex',
      'serviceType': 'HVAC Repair',
      'technician': 'John Smith',
      'inspector': 'Mike Wilson',
      'inspectionDate': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'passed',
      'score': 95,
      'issues': [],
      'recommendations': ['Continue current maintenance schedule'],
      'photos': ['inspection_1.jpg', 'inspection_2.jpg'],
      'notes': 'Excellent work quality. All safety protocols followed correctly.',
      'checklist': [
        {'item': 'Safety protocols followed', 'status': 'passed'},
        {'item': 'Work area cleaned', 'status': 'passed'},
        {'item': 'Equipment properly installed', 'status': 'passed'},
        {'item': 'Documentation complete', 'status': 'passed'},
        {'item': 'Customer satisfaction', 'status': 'passed'},
      ],
    },
    {
      'id': 'QA-002',
      'jobId': 'JOB-2024-002',
      'customer': 'Westside Restaurant',
      'serviceType': 'Plumbing Emergency',
      'technician': 'Sarah Johnson',
      'inspector': 'David Brown',
      'inspectionDate': DateTime.now().subtract(const Duration(hours: 6)),
      'status': 'pending',
      'score': 0,
      'issues': ['Minor cleanup needed'],
      'recommendations': ['Complete cleanup before final approval'],
      'photos': ['inspection_3.jpg'],
      'notes': 'Good emergency response. Minor cleanup required.',
      'checklist': [
        {'item': 'Safety protocols followed', 'status': 'passed'},
        {'item': 'Work area cleaned', 'status': 'failed'},
        {'item': 'Equipment properly installed', 'status': 'passed'},
        {'item': 'Documentation complete', 'status': 'passed'},
        {'item': 'Customer satisfaction', 'status': 'pending'},
      ],
    },
    {
      'id': 'QA-003',
      'jobId': 'JOB-2024-003',
      'customer': 'Eastside Manufacturing',
      'serviceType': 'Electrical Installation',
      'technician': 'Mike Wilson',
      'inspector': 'John Smith',
      'inspectionDate': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'failed',
      'score': 65,
      'issues': ['Incomplete documentation', 'Missing safety signage'],
      'recommendations': ['Complete documentation', 'Install safety signage', 'Re-inspection required'],
      'photos': ['inspection_4.jpg', 'inspection_5.jpg'],
      'notes': 'Work quality acceptable but documentation and safety measures need improvement.',
      'checklist': [
        {'item': 'Safety protocols followed', 'status': 'failed'},
        {'item': 'Work area cleaned', 'status': 'passed'},
        {'item': 'Equipment properly installed', 'status': 'passed'},
        {'item': 'Documentation complete', 'status': 'failed'},
        {'item': 'Customer satisfaction', 'status': 'passed'},
      ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quality Assurance'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Passed'),
            Tab(text: 'Failed'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createInspection,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInspectionList(_getFilteredInspections()),
          _buildInspectionList(_getInspectionsByStatus('pending')),
          _buildInspectionList(_getInspectionsByStatus('passed')),
          _buildInspectionList(_getInspectionsByStatus('failed')),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredInspections() {
    return _inspections.where((inspection) {
      bool matchesInspector = true;
      bool matchesStatus = true;

      if (_selectedInspector != 'all') {
        matchesInspector = inspection['inspector'] == _selectedInspector;
      }

      if (_selectedStatus != 'all') {
        matchesStatus = inspection['status'] == _selectedStatus;
      }

      return matchesInspector && matchesStatus;
    }).toList();
  }

  List<Map<String, dynamic>> _getInspectionsByStatus(String status) {
    return _inspections.where((inspection) => inspection['status'] == status).toList();
  }

  Widget _buildInspectionList(List<Map<String, dynamic>> inspections) {
    if (inspections.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No inspections found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: inspections.length,
      itemBuilder: (context, index) {
        final inspection = inspections[index];
        return _buildInspectionCard(inspection);
      },
    );
  }

  Widget _buildInspectionCard(Map<String, dynamic> inspection) {
    final statusColor = _getStatusColor(inspection['status']);
    final scoreColor = _getScoreColor(inspection['score']);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showInspectionDetails(inspection),
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
                          inspection['id'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          inspection['serviceType'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          inspection['status'].toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (inspection['score'] > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: scoreColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${inspection['score']}%',
                            style: TextStyle(
                              color: scoreColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
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
                      inspection['customer'],
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
                    'Technician: ${inspection['technician']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.verified_user, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Inspector: ${inspection['inspector']}',
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
                    'Date: ${DateFormat('MMM dd, yyyy').format(inspection['inspectionDate'])}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (inspection['issues'].isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.warning, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      '${inspection['issues'].length} issue(s) found',
                      style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              _buildChecklistSummary(inspection['checklist']),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewInspectionReport(inspection),
                      icon: const Icon(Icons.description, size: 16),
                      label: const Text('Report'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateInspection(inspection),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Update'),
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

  Widget _buildChecklistSummary(List<dynamic> checklist) {
    final passed = checklist.where((item) => item['status'] == 'passed').length;
    final failed = checklist.where((item) => item['status'] == 'failed').length;
    final pending = checklist.where((item) => item['status'] == 'pending').length;

    return Row(
      children: [
        if (passed > 0) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$passed Passed',
              style: const TextStyle(color: Colors.green, fontSize: 12),
            ),
          ),
          const SizedBox(width: 4),
        ],
        if (failed > 0) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$failed Failed',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
          const SizedBox(width: 4),
        ],
        if (pending > 0) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$pending Pending',
              style: const TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'passed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.orange;
    return Colors.red;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Inspections'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedInspector,
              decoration: const InputDecoration(labelText: 'Inspector'),
              items: [
                const DropdownMenuItem(value: 'all', child: Text('All Inspectors')),
                ..._inspections.map((inspection) => inspection['inspector']).toSet().map((inspector) {
                  return DropdownMenuItem(value: inspector, child: Text(inspector));
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedInspector = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Status'),
              items: [
                const DropdownMenuItem(value: 'all', child: Text('All Statuses')),
                const DropdownMenuItem(value: 'pending', child: Text('Pending')),
                const DropdownMenuItem(value: 'passed', child: Text('Passed')),
                const DropdownMenuItem(value: 'failed', child: Text('Failed')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
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

  void _createInspection() {
    // Navigate to create inspection screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new inspection')),
    );
  }

  void _showInspectionDetails(Map<String, dynamic> inspection) {
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
                    inspection['id'],
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
                inspection['serviceType'],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                inspection['customer'],
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Job ID', inspection['jobId']),
              _buildDetailRow('Technician', inspection['technician']),
              _buildDetailRow('Inspector', inspection['inspector']),
              _buildDetailRow('Inspection Date', DateFormat('MMM dd, yyyy').format(inspection['inspectionDate'])),
              _buildDetailRow('Status', inspection['status'].toUpperCase()),
              if (inspection['score'] > 0)
                _buildDetailRow('Score', '${inspection['score']}%'),
              const SizedBox(height: 16),
              const Text(
                'Checklist',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...inspection['checklist'].map<Widget>((item) {
                return _buildChecklistItem(item);
              }),
              const SizedBox(height: 16),
              if (inspection['issues'].isNotEmpty) ...[
                const Text(
                  'Issues Found',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 8),
                ...inspection['issues'].map<Widget>((issue) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(issue)),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],
              const Text(
                'Recommendations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...inspection['recommendations'].map<Widget>((rec) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(rec)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              const Text(
                'Notes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(inspection['notes']),
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

  Widget _buildChecklistItem(Map<String, dynamic> item) {
    final statusColor = _getStatusColor(item['status']);
    final statusIcon = _getStatusIcon(item['status']);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: statusColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: statusColor.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(item['item'])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item['status'].toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'passed':
        return Icons.check_circle;
      case 'failed':
        return Icons.cancel;
      case 'pending':
        return Icons.schedule;
      default:
        return Icons.help;
    }
  }

  void _viewInspectionReport(Map<String, dynamic> inspection) {
    // Navigate to inspection report screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View inspection report ${inspection['id']}')),
    );
  }

  void _updateInspection(Map<String, dynamic> inspection) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update ${inspection['id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: inspection['status'],
              decoration: const InputDecoration(labelText: 'Status'),
              items: [
                const DropdownMenuItem(value: 'pending', child: Text('Pending')),
                const DropdownMenuItem(value: 'passed', child: Text('Passed')),
                const DropdownMenuItem(value: 'failed', child: Text('Failed')),
              ],
              onChanged: (value) {
                // Update status logic
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Score (%)'),
              keyboardType: TextInputType.number,
              initialValue: inspection['score'].toString(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
              initialValue: inspection['notes'],
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
                const SnackBar(content: Text('Inspection updated')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
} 