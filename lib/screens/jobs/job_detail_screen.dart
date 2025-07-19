import 'package:flutter/material.dart';

class JobDetailScreen extends StatefulWidget {
  final String jobId;
  
  const JobDetailScreen({super.key, required this.jobId});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late Map<String, dynamic> _job;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobDetails();
  }

  void _loadJobDetails() {
    // Simulate loading job details
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _job = _getJobById(widget.jobId);
        _isLoading = false;
      });
    });
  }

  Map<String, dynamic> _getJobById(String id) {
    final jobs = {
      '1': {
        'id': '1',
        'title': 'Quarterly Pest Control',
        'client': 'Office Complex A',
        'clientPhone': '+1 (555) 123-4567',
        'clientEmail': 'manager@officecomplex.com',
        'location': '123 Business Blvd, Downtown',
        'coordinates': '40.7128, -74.0060',
        'status': 'in_progress',
        'priority': 'medium',
        'assignee': 'Maya Chen',
        'assigneeAvatar': 'MC',
        'assigneePhone': '+1 (555) 987-6543',
        'scheduledDate': '2024-01-15',
        'scheduledTime': '09:00 AM',
        'estimatedDuration': '2 hours',
        'actualStartTime': '09:15 AM',
        'description': 'Quarterly pest control treatment for the entire office complex. This includes spraying all common areas, offices, and storage rooms.',
        'detailedNotes': 'Focus on the basement storage area where there have been recent reports of rodent activity. Use eco-friendly solutions as requested by building management.',
        'tags': ['pest-control', 'quarterly', 'commercial'],
        'revenue': 850.00,
        'progress': 65,
        'materialsUsed': [
          {'name': 'Eco-Safe Spray', 'quantity': '2 bottles', 'cost': 45.00},
          {'name': 'Bait Stations', 'quantity': '8 units', 'cost': 120.00},
          {'name': 'Safety Equipment', 'quantity': '1 set', 'cost': 25.00},
        ],
        'timeline': [
          {'time': '09:00 AM', 'event': 'Job scheduled to start', 'status': 'completed'},
          {'time': '09:15 AM', 'event': 'Technician arrived on site', 'status': 'completed'},
          {'time': '09:30 AM', 'event': 'Initial inspection completed', 'status': 'completed'},
          {'time': '10:00 AM', 'event': 'Treatment started - Floor 1', 'status': 'completed'},
          {'time': '10:45 AM', 'event': 'Treatment started - Floor 2', 'status': 'in_progress'},
          {'time': '11:15 AM', 'event': 'Treatment - Basement area', 'status': 'pending'},
          {'time': '11:45 AM', 'event': 'Final inspection & cleanup', 'status': 'pending'},
        ],
        'images': [
          'Before inspection photo',
          'Treatment in progress',
          'Equipment setup',
        ],
        'nextService': '2024-04-15',
      },
    };
    return jobs[id] ?? {};
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Job Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_job.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Job Details')),
        body: const Center(child: Text('Job not found')),
      );
    }

    final Color statusColor = _getStatusColor(_job['status']);
    final Color priorityColor = _getPriorityColor(_job['priority']);

    return Scaffold(
      appBar: AppBar(
        title: Text(_job['title']),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareJob(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit Job')),
              const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildStatusSection(),
            _buildDetailsSection(),
            _buildTimelineSection(),
            _buildMaterialsSection(),
            _buildClientSection(),
            _buildImagesSection(),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: _buildActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _job['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _job['status'].replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
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
              const Icon(Icons.business, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _job['client'],
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _job['location'],
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Text(
                  _job['assigneeAvatar'],
                  style: const TextStyle(
                    color: Color(0xFF14B8A6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _job['assignee'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Field Technician',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '\$${_job['revenue'].toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    if (_job['status'] != 'in_progress') return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.blue),
              const SizedBox(width: 8),
              const Text(
                'Job Progress',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              Text(
                '${_job['progress']}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _job['progress'] / 100,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Started: ${_job['actualStartTime']}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const Spacer(),
              Text(
                'Est. completion: ${_job['scheduledTime']}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Job Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Priority', _job['priority'].toUpperCase(), 
              color: _getPriorityColor(_job['priority'])),
          _buildDetailRow('Scheduled', '${_job['scheduledDate']} at ${_job['scheduledTime']}'),
          _buildDetailRow('Duration', _job['estimatedDuration']),
          if (_job['nextService'] != null)
            _buildDetailRow('Next Service', _job['nextService']),
          const SizedBox(height: 16),
          Text(
            'Description',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _job['description'],
            style: TextStyle(color: Colors.grey[600]),
          ),
          if (_job['detailedNotes'] != null) ...[
            const SizedBox(height: 16),
            Text(
              'Special Notes',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Text(
                _job['detailedNotes'],
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color ?? Colors.grey[800],
                fontWeight: color != null ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Timeline',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _job['timeline'].length,
            itemBuilder: (context, index) {
              final item = _job['timeline'][index];
              final isLast = index == _job['timeline'].length - 1;
              return _buildTimelineItem(item, isLast);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> item, bool isLast) {
    Color statusColor;
    IconData statusIcon;
    
    switch (item['status']) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'in_progress':
        statusColor = Colors.blue;
        statusIcon = Icons.radio_button_checked;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.radio_button_unchecked;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: statusColor, width: 2),
              ),
              child: Icon(statusIcon, color: statusColor, size: 16),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['event'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['time'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialsSection() {
    if (_job['materialsUsed'] == null || _job['materialsUsed'].isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Materials Used',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _job['materialsUsed'].length,
            itemBuilder: (context, index) {
              final material = _job['materialsUsed'][index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF14B8A6),
                    child: Icon(Icons.inventory, color: Colors.white, size: 20),
                  ),
                  title: Text(material['name']),
                  subtitle: Text(material['quantity']),
                  trailing: Text(
                    '\$${material['cost'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              );
            },
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Materials Cost:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${_job['materialsUsed'].fold(0.0, (sum, item) => sum + item['cost']).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Client Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF14B8A6),
                      child: Icon(Icons.business, color: Colors.white),
                    ),
                    title: Text(_job['client']),
                    subtitle: Text(_job['location']),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () => _callClient(),
                          icon: const Icon(Icons.phone),
                          label: const Text('Call'),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () => _emailClient(),
                          icon: const Icon(Icons.email),
                          label: const Text('Email'),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () => _navigateToLocation(),
                          icon: const Icon(Icons.directions),
                          label: const Text('Navigate'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Job Photos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () => _addPhoto(),
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Add Photo'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _job['images'].length + 1,
              itemBuilder: (context, index) {
                if (index == _job['images'].length) {
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!, width: 2, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: () => _addPhoto(),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 32, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Add Photo', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }
                
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.grey[300],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.image, size: 32, color: Colors.grey),
                              const SizedBox(height: 4),
                              Text(
                                _job['images'][index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 16),
                            onPressed: () => _removePhoto(index),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
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

  Widget _buildActionButton() {
    String buttonText;
    IconData buttonIcon;
    VoidCallback buttonAction;

    switch (_job['status']) {
      case 'scheduled':
        buttonText = 'Start Job';
        buttonIcon = Icons.play_arrow;
        buttonAction = () => _startJob();
        break;
      case 'in_progress':
        buttonText = 'Complete Job';
        buttonIcon = Icons.check;
        buttonAction = () => _completeJob();
        break;
      case 'completed':
        buttonText = 'Generate Report';
        buttonIcon = Icons.description;
        buttonAction = () => _generateReport();
        break;
      default:
        buttonText = 'Update Status';
        buttonIcon = Icons.edit;
        buttonAction = () => _updateStatus();
    }

    return FloatingActionButton.extended(
      onPressed: buttonAction,
      backgroundColor: const Color(0xFF14B8A6),
      icon: Icon(buttonIcon, color: Colors.white),
      label: Text(buttonText, style: const TextStyle(color: Colors.white)),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'scheduled':
        return Colors.orange;
      case 'urgent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Action methods
  void _shareJob() {
    // Implement job sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job details shared')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'edit':
        // Navigate to edit job screen
        break;
      case 'duplicate':
        // Duplicate job
        break;
      case 'delete':
        // Delete job
        break;
    }
  }

  void _startJob() {
    setState(() {
      _job['status'] = 'in_progress';
      _job['actualStartTime'] = TimeOfDay.now().format(context);
    });
  }

  void _completeJob() {
    setState(() {
      _job['status'] = 'completed';
      _job['progress'] = 100;
    });
  }

  void _generateReport() {
    // Generate job report
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating job report...')),
    );
  }

  void _updateStatus() {
    // Show status update dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Job Status'),
        content: const Text('Status update functionality coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _callClient() {
    // Implement phone call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling ${_job['clientPhone']}')),
    );
  }

  void _emailClient() {
    // Implement email
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening email to ${_job['clientEmail']}')),
    );
  }

  void _navigateToLocation() {
    // Implement navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigating to ${_job['location']}')),
    );
  }

  void _addPhoto() {
    // Implement photo capture/selection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo capture coming soon')),
    );
  }

  void _removePhoto(int index) {
    setState(() {
      _job['images'].removeAt(index);
    });
  }
} 