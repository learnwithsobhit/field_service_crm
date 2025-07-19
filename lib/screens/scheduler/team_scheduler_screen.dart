import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeamSchedulerScreen extends StatefulWidget {
  const TeamSchedulerScreen({super.key});

  @override
  State<TeamSchedulerScreen> createState() => _TeamSchedulerScreenState();
}

class _TeamSchedulerScreenState extends State<TeamSchedulerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  String _selectedView = 'week';
  Map<String, dynamic>? _selectedJob;
  Map<String, dynamic>? _selectedTechnician;

  final List<Map<String, dynamic>> _technicians = [
    {
      'id': '1',
      'name': 'Maya Chen',
      'avatar': 'MC',
      'role': 'Senior Technician',
      'specialties': ['HVAC', 'Electrical'],
      'availability': 'full_time',
      'currentLocation': 'Downtown',
      'status': 'available',
      'rating': 4.8,
      'jobsCompleted': 156,
      'phone': '+1 (555) 987-6543',
      'email': 'maya.chen@fieldservice.com',
    },
    {
      'id': '2',
      'name': 'Ravi Patel',
      'avatar': 'RP',
      'role': 'Plumbing Specialist',
      'specialties': ['Plumbing', 'Emergency Repairs'],
      'availability': 'full_time',
      'currentLocation': 'Midtown',
      'status': 'on_job',
      'rating': 4.6,
      'jobsCompleted': 142,
      'phone': '+1 (555) 876-5432',
      'email': 'ravi.patel@fieldservice.com',
    },
    {
      'id': '3',
      'name': 'Arjun Singh',
      'avatar': 'AS',
      'role': 'Emergency Response',
      'specialties': ['Emergency', 'Plumbing', 'Electrical'],
      'availability': 'on_call',
      'currentLocation': 'Uptown',
      'status': 'available',
      'rating': 4.9,
      'jobsCompleted': 203,
      'phone': '+1 (555) 765-4321',
      'email': 'arjun.singh@fieldservice.com',
    },
    {
      'id': '4',
      'name': 'Sarah Williams',
      'avatar': 'SW',
      'role': 'HVAC Technician',
      'specialties': ['HVAC', 'Maintenance'],
      'availability': 'part_time',
      'currentLocation': 'Business District',
      'status': 'available',
      'rating': 4.7,
      'jobsCompleted': 89,
      'phone': '+1 (555) 654-3210',
      'email': 'sarah.williams@fieldservice.com',
    },
  ];

  final List<Map<String, dynamic>> _jobs = [
    {
      'id': '1',
      'title': 'Quarterly Pest Control',
      'client': 'Office Complex A',
      'location': '123 Business Blvd, Downtown',
      'priority': 'medium',
      'estimatedDuration': '2 hours',
      'scheduledDate': DateTime.now(),
      'scheduledTime': '09:00 AM',
      'status': 'scheduled',
      'assignedTo': null,
      'specialties': ['pest-control'],
      'revenue': 850.00,
    },
    {
      'id': '2',
      'title': 'HVAC Maintenance',
      'client': 'Community Center',
      'location': '456 Community St, Midtown',
      'priority': 'high',
      'estimatedDuration': '3 hours',
      'scheduledDate': DateTime.now(),
      'scheduledTime': '02:00 PM',
      'status': 'scheduled',
      'assignedTo': null,
      'specialties': ['hvac'],
      'revenue': 1200.00,
    },
    {
      'id': '3',
      'title': 'Emergency Plumbing',
      'client': 'Residential Building',
      'location': '789 Residential Ave, Uptown',
      'priority': 'urgent',
      'estimatedDuration': '1 hour',
      'scheduledDate': DateTime.now(),
      'scheduledTime': 'ASAP',
      'status': 'urgent',
      'assignedTo': null,
      'specialties': ['plumbing', 'emergency'],
      'revenue': 450.00,
    },
    {
      'id': '4',
      'title': 'Electrical Inspection',
      'client': 'New Construction',
      'location': '321 Development Dr, New Area',
      'priority': 'medium',
      'estimatedDuration': '4 hours',
      'scheduledDate': DateTime.now().add(const Duration(days: 1)),
      'scheduledTime': '10:00 AM',
      'status': 'scheduled',
      'assignedTo': null,
      'specialties': ['electrical'],
      'revenue': 2100.00,
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
        title: const Text('Team Scheduler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: _optimizeRoutes,
            tooltip: 'Optimize Routes',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
            tooltip: 'Scheduler Settings',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Calendar'),
            Tab(text: 'Team'),
            Tab(text: 'Jobs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalendarView(),
          _buildTeamView(),
          _buildJobsView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'scheduler_fab',
        onPressed: _createSchedule,
        backgroundColor: const Color(0xFF14B8A6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        _buildCalendarHeader(),
        _buildCalendarGrid(),
        Expanded(child: _buildScheduleList()),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeDate(-1),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedView,
                  items: const [
                    DropdownMenuItem(value: 'day', child: Text('Day')),
                    DropdownMenuItem(value: 'week', child: Text('Week')),
                    DropdownMenuItem(value: 'month', child: Text('Month')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedView = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeDate(1),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    if (_selectedView == 'day') {
      return _buildDayView();
    } else if (_selectedView == 'week') {
      return _buildWeekView();
    } else {
      return _buildMonthView();
    }
  }

  Widget _buildDayView() {
    final hours = List.generate(24, (index) => index);
    final dayJobs = _jobs.where((job) => 
      job['scheduledDate'].day == _selectedDate.day &&
      job['scheduledDate'].month == _selectedDate.month &&
      job['scheduledDate'].year == _selectedDate.year
    ).toList();

    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: hours.length,
        itemBuilder: (context, index) {
          final hour = hours[index];
          final hourJobs = dayJobs.where((job) {
            final jobHour = int.tryParse(job['scheduledTime'].split(':')[0]) ?? 0;
            return jobHour == hour;
          }).toList();

          return Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    '${hour.toString().padLeft(2, '0')}:00',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: hourJobs.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: hourJobs.length,
                          itemBuilder: (context, jobIndex) {
                            final job = hourJobs[jobIndex];
                            return _buildJobCard(job, isCompact: true);
                          },
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeekView() {
    final weekDays = List.generate(7, (index) {
      return _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1)).add(Duration(days: index));
    });

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: weekDays.map((date) {
          final dayJobs = _jobs.where((job) => 
            job['scheduledDate'].day == date.day &&
            job['scheduledDate'].month == date.month &&
            job['scheduledDate'].year == date.year
          ).toList();

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: date.day == _selectedDate.day ? Colors.blue[50] : null,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: date.day == _selectedDate.day ? Colors.blue : Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('E').format(date),
                          style: TextStyle(
                            color: date.day == _selectedDate.day ? Colors.white : Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: date.day == _selectedDate.day ? Colors.white : Colors.grey[800],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dayJobs.length,
                      itemBuilder: (context, index) {
                        final job = dayJobs[index];
                        return Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(job['priority']).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            job['title'],
                            style: const TextStyle(fontSize: 10),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMonthView() {
    // Simplified month view
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
        ),
        itemCount: 35, // Simplified for demo
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 15));
          final dayJobs = _jobs.where((job) => 
            job['scheduledDate'].day == date.day &&
            job['scheduledDate'].month == date.month &&
            job['scheduledDate'].year == date.year
          ).toList();

          return Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
              color: date.day == _selectedDate.day ? Colors.blue[50] : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontWeight: date.day == _selectedDate.day ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (dayJobs.isNotEmpty)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleList() {
    final dayJobs = _jobs.where((job) => 
      job['scheduledDate'].day == _selectedDate.day &&
      job['scheduledDate'].month == _selectedDate.month &&
      job['scheduledDate'].year == _selectedDate.year
    ).toList();

    if (dayJobs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No jobs scheduled for this day',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dayJobs.length,
      itemBuilder: (context, index) {
        final job = dayJobs[index];
        return _buildJobCard(job);
      },
    );
  }

  Widget _buildTeamView() {
    return Column(
      children: [
        _buildTeamStats(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _technicians.length,
            itemBuilder: (context, index) {
              final technician = _technicians[index];
              return _buildTechnicianCard(technician);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTeamStats() {
    final available = _technicians.where((t) => t['status'] == 'available').length;
    final onJob = _technicians.where((t) => t['status'] == 'on_job').length;
    final total = _technicians.length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Available', available.toString(), Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('On Job', onJob.toString(), Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Total', total.toString(), Colors.grey),
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

  Widget _buildTechnicianCard(Map<String, dynamic> technician) {
    final statusColor = _getStatusColor(technician['status']);
    
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
            Text(technician['role']),
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.amber, size: 16),
            Text(
              technician['rating'].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onTap: () => _showTechnicianDetails(technician),
      ),
    );
  }

  Widget _buildJobsView() {
    return Column(
      children: [
        _buildJobFilters(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _jobs.length,
            itemBuilder: (context, index) {
              final job = _jobs[index];
              return _buildJobCard(job);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJobFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              value: null,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Priorities')),
                DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                DropdownMenuItem(value: 'high', child: Text('High')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'low', child: Text('Low')),
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
              value: null,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'scheduled', child: Text('Scheduled')),
                DropdownMenuItem(value: 'assigned', child: Text('Assigned')),
                DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
              ],
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job, {bool isCompact = false}) {
    final priorityColor = _getPriorityColor(job['priority']);
    
    if (isCompact) {
      return Container(
        width: 200,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: priorityColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: priorityColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['title'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              job['client'],
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            if (job['assignedTo'] != null)
              Text(
                'Assigned to ${job['assignedTo']}',
                style: const TextStyle(fontSize: 10, color: Colors.blue),
              ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: priorityColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getJobIcon(job['specialties']),
            color: priorityColor,
            size: 20,
          ),
        ),
        title: Text(job['title']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job['client']),
            Text(
              '${job['scheduledTime']} • ${job['estimatedDuration']}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (job['assignedTo'] != null)
              Text(
                'Assigned to ${job['assignedTo']}',
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                job['priority'].toUpperCase(),
                style: TextStyle(
                  color: priorityColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${job['revenue'].toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        onTap: () => _showJobDetails(job),
      ),
    );
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'on_job':
        return Colors.blue;
      case 'offline':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getJobIcon(List<String> specialties) {
    if (specialties.contains('hvac')) return Icons.ac_unit;
    if (specialties.contains('plumbing')) return Icons.plumbing;
    if (specialties.contains('electrical')) return Icons.electrical_services;
    if (specialties.contains('pest-control')) return Icons.bug_report;
    if (specialties.contains('emergency')) return Icons.emergency;
    return Icons.work;
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  void _optimizeRoutes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Route Optimization'),
        content: const Text('Optimizing routes for all technicians...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Routes optimized successfully!')),
              );
            },
            child: const Text('Optimize'),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scheduler Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Auto-assign jobs'),
              trailing: Switch(value: true, onChanged: null),
            ),
            ListTile(
              leading: Icon(Icons.route),
              title: Text('Route optimization'),
              trailing: Switch(value: true, onChanged: null),
            ),
            ListTile(
              leading: Icon(Icons.schedule),
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

  void _createSchedule() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Schedule'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Create a new schedule or assign jobs to technicians.'),
            SizedBox(height: 16),
            Text('This feature allows you to:'),
            SizedBox(height: 8),
            Text('• Assign jobs to available technicians'),
            Text('• Set working hours and availability'),
            Text('• Optimize routes for efficiency'),
            Text('• Handle emergency assignments'),
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
              _showAssignmentDialog();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAssignmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Job'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Job'),
              value: _selectedJob?['id'] as String?,
              items: _jobs.map((job) {
                return DropdownMenuItem<String>(
                  value: job['id'] as String,
                  child: Text(job['title'] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedJob = _jobs.firstWhere((job) => job['id'] == value);
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Technician'),
              value: _selectedTechnician?['id'] as String?,
              items: _technicians.where((tech) => tech['status'] == 'available').map((tech) {
                return DropdownMenuItem<String>(
                  value: tech['id'] as String,
                  child: Text(tech['name'] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTechnician = _technicians.firstWhere((tech) => tech['id'] == value);
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
              if (_selectedJob != null && _selectedTechnician != null) {
                Navigator.pop(context);
                _assignJob(_selectedJob!, _selectedTechnician!);
              }
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }

  void _assignJob(Map<String, dynamic> job, Map<String, dynamic> technician) {
    setState(() {
      final jobIndex = _jobs.indexWhere((j) => j['id'] == job['id']);
      if (jobIndex != -1) {
        _jobs[jobIndex]['assignedTo'] = technician['name'];
        _jobs[jobIndex]['status'] = 'assigned';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${job['title']} assigned to ${technician['name']}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showTechnicianDetails(Map<String, dynamic> technician) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(technician['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Role: ${technician['role']}'),
            Text('Status: ${technician['status'].replaceAll('_', ' ').toUpperCase()}'),
            Text('Rating: ${technician['rating']} ⭐'),
            Text('Jobs Completed: ${technician['jobsCompleted']}'),
            Text('Phone: ${technician['phone']}'),
            Text('Email: ${technician['email']}'),
            const SizedBox(height: 8),
            const Text('Specialties:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...technician['specialties'].map((specialty) => Text('• $specialty')),
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
              // Navigate to technician detail screen
            },
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }

  void _showJobDetails(Map<String, dynamic> job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(job['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client: ${job['client']}'),
            Text('Location: ${job['location']}'),
            Text('Priority: ${job['priority'].toUpperCase()}'),
            Text('Duration: ${job['estimatedDuration']}'),
            Text('Revenue: \$${job['revenue'].toStringAsFixed(2)}'),
            if (job['assignedTo'] != null)
              Text('Assigned to: ${job['assignedTo']}'),
            const SizedBox(height: 8),
            const Text('Specialties:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...job['specialties'].map((specialty) => Text('• $specialty')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (job['assignedTo'] == null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showAssignmentDialog();
              },
              child: const Text('Assign'),
            ),
        ],
      ),
    );
  }
} 