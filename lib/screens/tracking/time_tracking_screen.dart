import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeTrackingScreen extends StatefulWidget {
  const TimeTrackingScreen({super.key});

  @override
  State<TimeTrackingScreen> createState() => _TimeTrackingScreenState();
}

class _TimeTrackingScreenState extends State<TimeTrackingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isClockedIn = false;
  DateTime? _clockInTime;
  DateTime? _lastBreakStart;
  bool _isOnBreak = false;
  String _selectedJob = '';
  String _selectedActivity = '';

  final List<Map<String, dynamic>> _technicians = [
    {
      'id': '1',
      'name': 'Maya Chen',
      'avatar': 'MC',
      'status': 'clocked_in',
      'clockInTime': DateTime.now().subtract(const Duration(hours: 3)),
      'currentJob': 'Quarterly Pest Control',
      'totalHours': 8.5,
      'breaks': [
        {
          'start': DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
          'end': DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
          'duration': 15,
        },
      ],
    },
    {
      'id': '2',
      'name': 'Ravi Patel',
      'avatar': 'RP',
      'status': 'on_break',
      'clockInTime': DateTime.now().subtract(const Duration(hours: 4)),
      'currentJob': 'HVAC Maintenance',
      'totalHours': 6.0,
      'breaks': [
        {
          'start': DateTime.now().subtract(const Duration(minutes: 30)),
          'end': null,
          'duration': 0,
        },
      ],
    },
    {
      'id': '3',
      'name': 'Arjun Singh',
      'avatar': 'AS',
      'status': 'clocked_out',
      'clockInTime': null,
      'currentJob': null,
      'totalHours': 0.0,
      'breaks': [],
    },
    {
      'id': '4',
      'name': 'Sarah Williams',
      'avatar': 'SW',
      'status': 'clocked_in',
      'clockInTime': DateTime.now().subtract(const Duration(hours: 2)),
      'currentJob': 'Electrical Inspection',
      'totalHours': 4.0,
      'breaks': [],
    },
  ];

  final List<Map<String, dynamic>> _jobs = [
    {
      'id': '1',
      'title': 'Quarterly Pest Control',
      'client': 'Office Complex A',
      'estimatedHours': 2.0,
      'actualHours': 1.5,
      'status': 'in_progress',
    },
    {
      'id': '2',
      'title': 'HVAC Maintenance',
      'client': 'Community Center',
      'estimatedHours': 3.0,
      'actualHours': 2.5,
      'status': 'in_progress',
    },
    {
      'id': '3',
      'title': 'Emergency Plumbing',
      'client': 'Residential Building',
      'estimatedHours': 1.0,
      'actualHours': 1.0,
      'status': 'completed',
    },
    {
      'id': '4',
      'title': 'Electrical Inspection',
      'client': 'New Construction',
      'estimatedHours': 4.0,
      'actualHours': 2.0,
      'status': 'in_progress',
    },
  ];

  final List<Map<String, dynamic>> _timeEntries = [
    {
      'id': '1',
      'technician': 'Maya Chen',
      'job': 'Quarterly Pest Control',
      'date': DateTime.now(),
      'clockIn': DateTime.now().subtract(const Duration(hours: 3)),
      'clockOut': null,
      'breaks': [
        {
          'start': DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
          'end': DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
          'duration': 15,
        },
      ],
      'totalHours': 3.0,
      'status': 'active',
    },
    {
      'id': '2',
      'technician': 'Ravi Patel',
      'job': 'HVAC Maintenance',
      'date': DateTime.now(),
      'clockIn': DateTime.now().subtract(const Duration(hours: 4)),
      'clockOut': null,
      'breaks': [
        {
          'start': DateTime.now().subtract(const Duration(minutes: 30)),
          'end': null,
          'duration': 0,
        },
      ],
      'totalHours': 3.5,
      'status': 'break',
    },
    {
      'id': '3',
      'technician': 'Sarah Williams',
      'job': 'Electrical Inspection',
      'date': DateTime.now(),
      'clockIn': DateTime.now().subtract(const Duration(hours: 2)),
      'clockOut': null,
      'breaks': [],
      'totalHours': 2.0,
      'status': 'active',
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
        title: const Text('Time Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showTimeReports,
            tooltip: 'Time Reports',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
            tooltip: 'Time Tracking Settings',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Clock In/Out'),
            Tab(text: 'Team Status'),
            Tab(text: 'Time Entries'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildClockInOutTab(),
          _buildTeamStatusTab(),
          _buildTimeEntriesTab(),
        ],
      ),
    );
  }

  Widget _buildClockInOutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Status Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    _isClockedIn ? Icons.work : Icons.work_outline,
                    size: 64,
                    color: _isClockedIn ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isClockedIn ? 'Currently Working' : 'Not Clocked In',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isClockedIn ? Colors.green : Colors.grey,
                    ),
                  ),
                  if (_isClockedIn && _clockInTime != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Since ${DateFormat('HH:mm').format(_clockInTime!)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getCurrentDuration(),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF14B8A6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Clock In/Out Buttons
          if (!_isClockedIn) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _clockIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'CLOCK IN',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isOnBreak ? _endBreak : _startBreak,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isOnBreak ? Colors.orange : Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isOnBreak ? 'END BREAK' : 'START BREAK',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clockOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'CLOCK OUT',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),

          // Job Assignment
          if (_isClockedIn) ...[
            Text(
              'Current Job',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Job',
                border: OutlineInputBorder(),
              ),
              value: _selectedJob.isEmpty ? null : _selectedJob,
              items: _jobs.map((job) {
                return DropdownMenuItem<String>(
                  value: job['id'] as String,
                  child: Text(job['title'] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedJob = value ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Activity Type',
                border: OutlineInputBorder(),
              ),
              value: _selectedActivity.isEmpty ? null : _selectedActivity,
              items: const [
                DropdownMenuItem(value: 'work', child: Text('Work')),
                DropdownMenuItem(value: 'travel', child: Text('Travel')),
                DropdownMenuItem(value: 'training', child: Text('Training')),
                DropdownMenuItem(value: 'meeting', child: Text('Meeting')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedActivity = value ?? '';
                });
              },
            ),
          ],
          const SizedBox(height: 24),

          // Today's Summary
          Text(
            'Today\'s Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTodaySummary(),
        ],
      ),
    );
  }

  Widget _buildTeamStatusTab() {
    return Column(
      children: [
        _buildTeamStats(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _technicians.length,
            itemBuilder: (context, index) {
              final technician = _technicians[index];
              return _buildTechnicianStatusCard(technician);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTeamStats() {
    final clockedIn = _technicians.where((t) => t['status'] == 'clocked_in').length;
    final onBreak = _technicians.where((t) => t['status'] == 'on_break').length;
    final clockedOut = _technicians.where((t) => t['status'] == 'clocked_out').length;
    final total = _technicians.length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Clocked In', clockedIn.toString(), Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('On Break', onBreak.toString(), Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Clocked Out', clockedOut.toString(), Colors.grey),
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

  Widget _buildTechnicianStatusCard(Map<String, dynamic> technician) {
    final statusColor = _getStatusColor(technician['status']);
    final isActive = technician['status'] == 'clocked_in' || technician['status'] == 'on_break';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF14B8A6),
          child: Text(
            technician['avatar'],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(technician['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (technician['currentJob'] != null)
              Text(technician['currentJob']),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  technician['status'].replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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
            if (isActive && technician['clockInTime'] != null)
              Text(
                _getDurationSince(technician['clockInTime']),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14B8A6),
                ),
              ),
            Text(
              '${technician['totalHours'].toStringAsFixed(1)}h',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        onTap: () => _showTechnicianDetails(technician),
      ),
    );
  }

  Widget _buildTimeEntriesTab() {
    return Column(
      children: [
        _buildTimeEntryFilters(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _timeEntries.length,
            itemBuilder: (context, index) {
              final entry = _timeEntries[index];
              return _buildTimeEntryCard(entry);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeEntryFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Date Range',
                border: OutlineInputBorder(),
              ),
              value: 'today',
              items: const [
                DropdownMenuItem(value: 'today', child: Text('Today')),
                DropdownMenuItem(value: 'week', child: Text('This Week')),
                DropdownMenuItem(value: 'month', child: Text('This Month')),
              ],
              onChanged: (value) {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              value: 'all',
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
              ],
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeEntryCard(Map<String, dynamic> entry) {
    final statusColor = _getEntryStatusColor(entry['status']);
    final isActive = entry['status'] == 'active';
    
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
            isActive ? Icons.work : Icons.check_circle,
            color: statusColor,
          ),
        ),
        title: Text(entry['technician']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry['job']),
            Text(
              '${DateFormat('MMM dd, yyyy').format(entry['date'])} • ${DateFormat('HH:mm').format(entry['clockIn'])}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${entry['totalHours'].toStringAsFixed(1)}h',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF14B8A6),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                entry['status'].toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showTimeEntryDetails(entry),
      ),
    );
  }

  Widget _buildTodaySummary() {
    final totalHours = 8.5;
    final workedHours = 3.0;
    final breakTime = 0.25;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Hours'),
                Text(
                  '${totalHours.toStringAsFixed(1)}h',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Worked Hours'),
                Text(
                  '${workedHours.toStringAsFixed(1)}h',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Break Time'),
                Text(
                  '${breakTime.toStringAsFixed(1)}h',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Remaining'),
                Text(
                  '${(totalHours - workedHours - breakTime).toStringAsFixed(1)}h',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'clocked_in':
        return Colors.green;
      case 'on_break':
        return Colors.orange;
      case 'clocked_out':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getEntryStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'break':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getCurrentDuration() {
    if (_clockInTime == null) return '0:00';
    
    final now = DateTime.now();
    final duration = now.difference(_clockInTime!);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    return '${hours}:${minutes.toString().padLeft(2, '0')}';
  }

  String _getDurationSince(DateTime startTime) {
    final now = DateTime.now();
    final duration = now.difference(startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    return '${hours}:${minutes.toString().padLeft(2, '0')}';
  }

  void _clockIn() {
    setState(() {
      _isClockedIn = true;
      _clockInTime = DateTime.now();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Clocked in successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clockOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clock Out'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to clock out?'),
            const SizedBox(height: 16),
            Text('Total time worked: ${_getCurrentDuration()}'),
            if (_selectedJob.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Job: ${_jobs.firstWhere((j) => j['id'] == _selectedJob)['title']}'),
            ],
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
              setState(() {
                _isClockedIn = false;
                _clockInTime = null;
                _isOnBreak = false;
                _lastBreakStart = null;
                _selectedJob = '';
                _selectedActivity = '';
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Clocked out successfully!'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Clock Out'),
          ),
        ],
      ),
    );
  }

  void _startBreak() {
    setState(() {
      _isOnBreak = true;
      _lastBreakStart = DateTime.now();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Break started'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _endBreak() {
    setState(() {
      _isOnBreak = false;
      _lastBreakStart = null;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Break ended'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showTimeReports() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time Reports'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Generate detailed time reports.'),
            SizedBox(height: 16),
            Text('Available reports:'),
            SizedBox(height: 8),
            Text('• Daily time summary'),
            Text('• Weekly time report'),
            Text('• Monthly time analysis'),
            Text('• Job time tracking'),
            Text('• Break time analysis'),
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
                const SnackBar(content: Text('Time reports coming soon!')),
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time Tracking Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Break reminders'),
              trailing: Switch(value: true, onChanged: null),
            ),
            ListTile(
              leading: Icon(Icons.timer),
              title: Text('Auto clock out'),
              trailing: Switch(value: false, onChanged: null),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Location tracking'),
              trailing: Switch(value: true, onChanged: null),
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('Working hours'),
              subtitle: Text('8:00 AM - 6:00 PM'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTechnicianDetails(Map<String, dynamic> technician) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(technician['name']),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Status', technician['status'].replaceAll('_', ' ').toUpperCase()),
            if (technician['currentJob'] != null)
              _buildDetailRow('Current Job', technician['currentJob']),
            if (technician['clockInTime'] != null)
              _buildDetailRow('Clock In', DateFormat('HH:mm').format(technician['clockInTime'])),
            _buildDetailRow('Total Hours', '${technician['totalHours'].toStringAsFixed(1)}h'),
            if (technician['breaks'].isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Breaks:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...technician['breaks'].map((break_) => Text(
                '• ${break_['duration']} minutes',
                style: const TextStyle(fontSize: 12),
              )),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTimeEntryDetails(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time Entry Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Technician', entry['technician']),
            _buildDetailRow('Job', entry['job']),
            _buildDetailRow('Date', DateFormat('MMM dd, yyyy').format(entry['date'])),
            _buildDetailRow('Clock In', DateFormat('HH:mm').format(entry['clockIn'])),
            if (entry['clockOut'] != null)
              _buildDetailRow('Clock Out', DateFormat('HH:mm').format(entry['clockOut'])),
            _buildDetailRow('Total Hours', '${entry['totalHours'].toStringAsFixed(1)}h'),
            _buildDetailRow('Status', entry['status'].toUpperCase()),
            if (entry['breaks'].isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Breaks:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...entry['breaks'].map((break_) => Text(
                '• ${break_['duration']} minutes',
                style: const TextStyle(fontSize: 12),
              )),
            ],
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
              _editTimeEntry(entry);
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

  void _editTimeEntry(Map<String, dynamic> entry) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit time entry for ${entry['technician']} coming soon!')),
    );
  }
} 