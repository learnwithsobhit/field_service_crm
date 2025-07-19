import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkOrderManagementScreen extends StatefulWidget {
  const WorkOrderManagementScreen({super.key});

  @override
  State<WorkOrderManagementScreen> createState() => _WorkOrderManagementScreenState();
}

class _WorkOrderManagementScreenState extends State<WorkOrderManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';
  String _selectedPriority = 'all';
  String _selectedStatus = 'all';

  final List<Map<String, dynamic>> _workOrders = [
    {
      'id': 'WO-001',
      'title': 'HVAC System Repair',
      'customer': 'Downtown Office Complex',
      'priority': 'high',
      'status': 'in_progress',
      'assignedTo': 'John Smith',
      'createdDate': DateTime.now().subtract(const Duration(days: 2)),
      'dueDate': DateTime.now().add(const Duration(days: 1)),
      'estimatedHours': 4,
      'actualHours': 2.5,
      'description': 'AC unit not cooling properly. Need to check refrigerant levels and clean filters.',
      'location': '123 Main St, Downtown',
      'equipment': ['HVAC Unit', 'Thermostat'],
      'parts': ['Air Filter', 'Refrigerant'],
    },
    {
      'id': 'WO-002',
      'title': 'Plumbing Emergency',
      'customer': 'Westside Restaurant',
      'priority': 'urgent',
      'status': 'pending',
      'assignedTo': 'Sarah Johnson',
      'createdDate': DateTime.now().subtract(const Duration(hours: 6)),
      'dueDate': DateTime.now().add(const Duration(hours: 2)),
      'estimatedHours': 3,
      'actualHours': 0,
      'description': 'Kitchen sink is clogged and water is backing up. Urgent repair needed.',
      'location': '456 Oak Ave, Westside',
      'equipment': ['Kitchen Sink', 'Drain System'],
      'parts': ['Drain Cleaner', 'Plumbing Tools'],
    },
    {
      'id': 'WO-003',
      'title': 'Electrical Panel Upgrade',
      'customer': 'Eastside Manufacturing',
      'priority': 'medium',
      'status': 'completed',
      'assignedTo': 'Mike Wilson',
      'createdDate': DateTime.now().subtract(const Duration(days: 5)),
      'dueDate': DateTime.now().subtract(const Duration(days: 1)),
      'estimatedHours': 8,
      'actualHours': 7.5,
      'description': 'Upgrade electrical panel to handle increased load from new machinery.',
      'location': '789 Industrial Blvd, Eastside',
      'equipment': ['Electrical Panel', 'Circuit Breakers'],
      'parts': ['New Panel', 'Wiring', 'Breakers'],
    },
    {
      'id': 'WO-004',
      'title': 'Preventive Maintenance',
      'customer': 'Northside Shopping Center',
      'priority': 'low',
      'status': 'scheduled',
      'assignedTo': 'David Brown',
      'createdDate': DateTime.now().subtract(const Duration(days: 1)),
      'dueDate': DateTime.now().add(const Duration(days: 3)),
      'estimatedHours': 2,
      'actualHours': 0,
      'description': 'Monthly HVAC system inspection and filter replacement.',
      'location': '321 Mall Dr, Northside',
      'equipment': ['HVAC Systems'],
      'parts': ['Air Filters', 'Lubricant'],
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
        title: const Text('Work Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewWorkOrder,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWorkOrderList(_getFilteredWorkOrders()),
          _buildWorkOrderList(_getWorkOrdersByStatus('pending')),
          _buildWorkOrderList(_getWorkOrdersByStatus('in_progress')),
          _buildWorkOrderList(_getWorkOrdersByStatus('completed')),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredWorkOrders() {
    return _workOrders.where((order) {
      bool matchesFilter = true;
      bool matchesPriority = true;
      bool matchesStatus = true;

      if (_selectedFilter != 'all') {
        matchesFilter = order['customer'].toLowerCase().contains(_selectedFilter.toLowerCase());
      }

      if (_selectedPriority != 'all') {
        matchesPriority = order['priority'] == _selectedPriority;
      }

      if (_selectedStatus != 'all') {
        matchesStatus = order['status'] == _selectedStatus;
      }

      return matchesFilter && matchesPriority && matchesStatus;
    }).toList();
  }

  List<Map<String, dynamic>> _getWorkOrdersByStatus(String status) {
    return _workOrders.where((order) => order['status'] == status).toList();
  }

  Widget _buildWorkOrderList(List<Map<String, dynamic>> workOrders) {
    if (workOrders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No work orders found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workOrders.length,
      itemBuilder: (context, index) {
        final workOrder = workOrders[index];
        return _buildWorkOrderCard(workOrder);
      },
    );
  }

  Widget _buildWorkOrderCard(Map<String, dynamic> workOrder) {
    final priorityColor = _getPriorityColor(workOrder['priority']);
    final statusColor = _getStatusColor(workOrder['status']);
    final isOverdue = workOrder['dueDate'].isBefore(DateTime.now()) && 
                     workOrder['status'] != 'completed';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showWorkOrderDetails(workOrder),
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
                          workOrder['id'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          workOrder['title'],
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
                          color: priorityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          workOrder['priority'].toUpperCase(),
                          style: TextStyle(
                            color: priorityColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          workOrder['status'].replaceAll('_', ' ').toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
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
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    workOrder['customer'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.assignment_ind, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Assigned to: ${workOrder['assignedTo']}',
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
                    'Due: ${DateFormat('MMM dd, yyyy').format(workOrder['dueDate'])}',
                    style: TextStyle(
                      color: isOverdue ? Colors.red : Colors.grey,
                      fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildProgressIndicator(
                      'Estimated: ${workOrder['estimatedHours']}h',
                      workOrder['actualHours'] / workOrder['estimatedHours'],
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildProgressIndicator(
                      'Actual: ${workOrder['actualHours']}h',
                      1.0,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _editWorkOrder(workOrder),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateWorkOrderStatus(workOrder),
                      icon: const Icon(Icons.update, size: 16),
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

  Widget _buildProgressIndicator(String label, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow.shade700;
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
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Work Orders'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: [
                const DropdownMenuItem(value: 'all', child: Text('All Priorities')),
                const DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                const DropdownMenuItem(value: 'high', child: Text('High')),
                const DropdownMenuItem(value: 'medium', child: Text('Medium')),
                const DropdownMenuItem(value: 'low', child: Text('Low')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
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
                const DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                const DropdownMenuItem(value: 'completed', child: Text('Completed')),
                const DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
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

  void _createNewWorkOrder() {
    // Navigate to create work order screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new work order')),
    );
  }

  void _showWorkOrderDetails(Map<String, dynamic> workOrder) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    workOrder['id'],
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
                workOrder['title'],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                workOrder['description'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Customer', workOrder['customer']),
              _buildDetailRow('Location', workOrder['location']),
              _buildDetailRow('Assigned To', workOrder['assignedTo']),
              _buildDetailRow('Created', DateFormat('MMM dd, yyyy').format(workOrder['createdDate'])),
              _buildDetailRow('Due Date', DateFormat('MMM dd, yyyy').format(workOrder['dueDate'])),
              _buildDetailRow('Estimated Hours', '${workOrder['estimatedHours']}h'),
              _buildDetailRow('Actual Hours', '${workOrder['actualHours']}h'),
              const SizedBox(height: 16),
              const Text(
                'Equipment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: workOrder['equipment'].map<Widget>((equipment) {
                  return Chip(label: Text(equipment));
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Parts Required',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: workOrder['parts'].map<Widget>((part) {
                  return Chip(
                    label: Text(part),
                    backgroundColor: Colors.orange.withOpacity(0.1),
                  );
                }).toList(),
              ),
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

  void _editWorkOrder(Map<String, dynamic> workOrder) {
    // Navigate to edit work order screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit work order ${workOrder['id']}')),
    );
  }

  void _updateWorkOrderStatus(Map<String, dynamic> workOrder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update ${workOrder['id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: workOrder['status'],
              decoration: const InputDecoration(labelText: 'Status'),
              items: [
                const DropdownMenuItem(value: 'pending', child: Text('Pending')),
                const DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                const DropdownMenuItem(value: 'completed', child: Text('Completed')),
                const DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
              ],
              onChanged: (value) {
                // Update status logic
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Actual Hours',
                suffixText: 'hours',
              ),
              keyboardType: TextInputType.number,
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
                const SnackBar(content: Text('Work order updated')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
} 