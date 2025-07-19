import 'package:flutter/material.dart';
import 'create_job_screen.dart';
import 'job_detail_screen.dart';

class JobListScreen extends StatefulWidget {
  final String? filter;
  
  const JobListScreen({super.key, this.filter});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> _jobs = [
    {
      'id': '1',
      'title': 'Quarterly Pest Control',
      'client': 'Office Complex A',
      'location': '123 Business Blvd, Downtown',
      'status': 'in_progress',
      'priority': 'medium',
      'assignee': 'Maya Chen',
      'assigneeAvatar': 'MC',
      'scheduledDate': '2024-01-15',
      'scheduledTime': '09:00 AM',
      'estimatedDuration': '2 hours',
      'description': 'Quarterly pest control treatment for the entire office complex.',
      'tags': ['pest-control', 'quarterly', 'commercial'],
      'revenue': 850.00,
      'progress': 65,
    },
    {
      'id': '2',
      'title': 'HVAC Maintenance',
      'client': 'Community Center',
      'location': '456 Community St, Midtown',
      'status': 'scheduled',
      'priority': 'high',
      'assignee': 'Ravi Patel',
      'assigneeAvatar': 'RP',
      'scheduledDate': '2024-01-15',
      'scheduledTime': '02:00 PM',
      'estimatedDuration': '3 hours',
      'description': 'Regular HVAC system maintenance and filter replacement.',
      'tags': ['hvac', 'maintenance', 'commercial'],
      'revenue': 1200.00,
      'progress': 0,
    },
    {
      'id': '3',
      'title': 'Emergency Plumbing',
      'client': 'Residential Building',
      'location': '789 Residential Ave, Uptown',
      'status': 'urgent',
      'priority': 'urgent',
      'assignee': 'Arjun Singh',
      'assigneeAvatar': 'AS',
      'scheduledDate': '2024-01-15',
      'scheduledTime': 'ASAP',
      'estimatedDuration': '1 hour',
      'description': 'Emergency plumbing repair - burst pipe in basement.',
      'tags': ['plumbing', 'emergency', 'residential'],
      'revenue': 450.00,
      'progress': 0,
    },
    {
      'id': '4',
      'title': 'Electrical Inspection',
      'client': 'New Construction',
      'location': '321 Development Dr, New Area',
      'status': 'completed',
      'priority': 'medium',
      'assignee': 'Maya Chen',
      'assigneeAvatar': 'MC',
      'scheduledDate': '2024-01-14',
      'scheduledTime': '10:00 AM',
      'estimatedDuration': '4 hours',
      'description': 'Final electrical inspection for new construction project.',
      'tags': ['electrical', 'inspection', 'construction'],
      'revenue': 2100.00,
      'progress': 100,
    },
    {
      'id': '5',
      'title': 'Garden Maintenance',
      'client': 'Corporate Headquarters',
      'location': '555 Corporate Plaza, Business District',
      'status': 'scheduled',
      'priority': 'low',
      'assignee': 'Ravi Patel',
      'assigneeAvatar': 'RP',
      'scheduledDate': '2024-01-16',
      'scheduledTime': '08:00 AM',
      'estimatedDuration': '5 hours',
      'description': 'Monthly garden and landscape maintenance service.',
      'tags': ['landscaping', 'monthly', 'commercial'],
      'revenue': 680.00,
      'progress': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    if (widget.filter != null) {
      _selectedFilter = widget.filter!;
      _setInitialTab();
    }
  }

  void _setInitialTab() {
    switch (widget.filter) {
      case 'in_progress':
        _tabController.index = 1;
        break;
      case 'scheduled':
        _tabController.index = 2;
        break;
      case 'completed':
        _tabController.index = 3;
        break;
      case 'urgent':
        _tabController.index = 4;
        break;
      default:
        _tabController.index = 0;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredJobs {
    var jobs = _jobs.where((job) {
      final matchesSearch = job['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           job['client'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           job['location'].toLowerCase().contains(_searchQuery.toLowerCase());
      
      if (!matchesSearch) return false;
      
      switch (_selectedFilter) {
        case 'in_progress':
          return job['status'] == 'in_progress';
        case 'scheduled':
          return job['status'] == 'scheduled';
        case 'completed':
          return job['status'] == 'completed';
        case 'urgent':
          return job['status'] == 'urgent' || job['priority'] == 'urgent';
        default:
          return true;
      }
    }).toList();

    // Sort by priority and date
    jobs.sort((a, b) {
      final priorityOrder = {'urgent': 0, 'high': 1, 'medium': 2, 'low': 3};
      final aPriority = priorityOrder[a['priority']] ?? 4;
      final bPriority = priorityOrder[b['priority']] ?? 4;
      
      if (aPriority != bPriority) {
        return aPriority.compareTo(bPriority);
      }
      
      return a['scheduledDate'].compareTo(b['scheduledDate']);
    });

    return jobs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search jobs, clients, locations...',
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
                      borderSide: BorderSide.none,
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
              ),
              // Tabs
              TabBar(
                controller: _tabController,
                isScrollable: true,
                onTap: (index) {
                  setState(() {
                    switch (index) {
                      case 0:
                        _selectedFilter = 'all';
                        break;
                      case 1:
                        _selectedFilter = 'in_progress';
                        break;
                      case 2:
                        _selectedFilter = 'scheduled';
                        break;
                      case 3:
                        _selectedFilter = 'completed';
                        break;
                      case 4:
                        _selectedFilter = 'urgent';
                        break;
                    }
                  });
                },
                tabs: [
                  Tab(child: _buildTabChip('All', _filteredJobs.length)),
                  Tab(child: _buildTabChip('In Progress', _jobs.where((j) => j['status'] == 'in_progress').length)),
                  Tab(child: _buildTabChip('Scheduled', _jobs.where((j) => j['status'] == 'scheduled').length)),
                  Tab(child: _buildTabChip('Completed', _jobs.where((j) => j['status'] == 'completed').length)),
                  Tab(child: _buildTabChip('Urgent', _jobs.where((j) => j['status'] == 'urgent' || j['priority'] == 'urgent').length)),
                ],
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
        },
        child: _filteredJobs.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredJobs.length,
                itemBuilder: (context, index) {
                  final job = _filteredJobs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildJobCard(job),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'job_list_fab',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateJobScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF14B8A6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTabChip(String label, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF14B8A6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No jobs found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    final Color statusColor = _getStatusColor(job['status']);
    final Color priorityColor = _getPriorityColor(job['priority']);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => JobDetailScreen(jobId: job['id']),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['title'],
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job['client'],
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          job['status'].replaceAll('_', ' ').toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
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
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Location and Time
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      job['location'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${job['scheduledDate']} • ${job['scheduledTime']} • ${job['estimatedDuration']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Progress Bar (if in progress)
              if (job['status'] == 'in_progress') ...[
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: job['progress'] / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${job['progress']}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              
              // Bottom Row - Assignee and Revenue
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xFF14B8A6),
                    child: Text(
                      job['assigneeAvatar'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      job['assignee'],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '\$${job['revenue'].toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
}

 