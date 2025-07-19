import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'month';
  String _selectedMetric = 'revenue';

  final List<Map<String, dynamic>> _revenueData = [
    {'month': 'Jan', 'revenue': 45000, 'jobs': 45, 'customers': 12},
    {'month': 'Feb', 'revenue': 52000, 'jobs': 52, 'customers': 15},
    {'month': 'Mar', 'revenue': 48000, 'jobs': 48, 'customers': 13},
    {'month': 'Apr', 'revenue': 61000, 'jobs': 61, 'customers': 18},
    {'month': 'May', 'revenue': 58000, 'jobs': 58, 'customers': 16},
    {'month': 'Jun', 'revenue': 67000, 'jobs': 67, 'customers': 20},
  ];

  final List<Map<String, dynamic>> _technicianPerformance = [
    {
      'name': 'Maya Chen',
      'jobsCompleted': 45,
      'avgRating': 4.8,
      'revenue': 125000,
      'efficiency': 92,
      'specialties': ['HVAC', 'Electrical'],
    },
    {
      'name': 'Ravi Patel',
      'jobsCompleted': 38,
      'avgRating': 4.6,
      'revenue': 98000,
      'efficiency': 88,
      'specialties': ['Plumbing', 'HVAC'],
    },
    {
      'name': 'Arjun Singh',
      'jobsCompleted': 42,
      'avgRating': 4.9,
      'revenue': 115000,
      'efficiency': 95,
      'specialties': ['Emergency', 'Plumbing'],
    },
    {
      'name': 'Sarah Williams',
      'jobsCompleted': 35,
      'avgRating': 4.7,
      'revenue': 89000,
      'efficiency': 90,
      'specialties': ['Electrical', 'Security'],
    },
  ];

  final List<Map<String, dynamic>> _customerMetrics = [
    {
      'category': 'New Customers',
      'count': 8,
      'percentage': 15.2,
      'trend': 'up',
      'color': Colors.green,
    },
    {
      'category': 'Returning Customers',
      'count': 32,
      'percentage': 60.8,
      'trend': 'up',
      'color': Colors.blue,
    },
    {
      'category': 'At Risk',
      'count': 8,
      'percentage': 15.2,
      'trend': 'down',
      'color': Colors.orange,
    },
    {
      'category': 'Lost',
      'count': 4,
      'percentage': 7.6,
      'trend': 'down',
      'color': Colors.red,
    },
  ];

  final List<Map<String, dynamic>> _jobMetrics = [
    {
      'status': 'Completed',
      'count': 45,
      'percentage': 67.2,
      'color': Colors.green,
    },
    {
      'status': 'In Progress',
      'count': 12,
      'percentage': 17.9,
      'color': Colors.blue,
    },
    {
      'status': 'Scheduled',
      'count': 8,
      'percentage': 11.9,
      'color': Colors.orange,
    },
    {
      'status': 'Cancelled',
      'count': 2,
      'percentage': 3.0,
      'color': Colors.red,
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
        title: const Text('Analytics Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Analytics',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
            tooltip: 'Export Report',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Revenue'),
            Tab(text: 'Performance'),
            Tab(text: 'Trends'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildRevenueTab(),
          _buildPerformanceTab(),
          _buildTrendsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final totalRevenue = _revenueData.fold<double>(0, (sum, data) => sum + data['revenue']);
    final totalJobs = _revenueData.fold<int>(0, (sum, data) => sum + data['jobs']);
    final avgRating = _technicianPerformance.fold<double>(0, (sum, tech) => sum + tech['avgRating']) / _technicianPerformance.length;
    final customerSatisfaction = 94.5;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Overview',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Key Metrics
          Row(
            children: [
              Expanded(
                child: _buildMetricCard('Total Revenue', '\$${NumberFormat('#,###').format(totalRevenue)}', Icons.attach_money, Colors.green),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard('Total Jobs', totalJobs.toString(), Icons.work, Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard('Avg Rating', avgRating.toStringAsFixed(1), Icons.star, Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard('Satisfaction', '${customerSatisfaction.toStringAsFixed(1)}%', Icons.thumb_up, Colors.purple),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Revenue Chart
          Text(
            'Revenue Trend',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRevenueChart(),
          const SizedBox(height: 24),
          
          // Customer Metrics
          Text(
            'Customer Metrics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildCustomerMetricsGrid(),
          const SizedBox(height: 24),
          
          // Job Status
          Text(
            'Job Status Distribution',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildJobStatusChart(),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
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

  Widget _buildRevenueChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _revenueData.map((data) => Text(data['month'])).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _revenueData.map((data) {
                final height = (data['revenue'] / 70000 * 100).clamp(10.0, 100.0);
                return Container(
                  width: 40,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _revenueData.map((data) => Text('\$${(data['revenue'] / 1000).toStringAsFixed(0)}k')).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerMetricsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _customerMetrics.length,
      itemBuilder: (context, index) {
        final metric = _customerMetrics[index];
        return _buildCustomerMetricCard(metric);
      },
    );
  }

  Widget _buildCustomerMetricCard(Map<String, dynamic> metric) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  metric['category'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Icon(
                  metric['trend'] == 'up' ? Icons.trending_up : Icons.trending_down,
                  color: metric['trend'] == 'up' ? Colors.green : Colors.red,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              metric['count'].toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: metric['color'],
                fontSize: 24,
              ),
            ),
            Text(
              '${metric['percentage'].toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobStatusChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: _jobMetrics.map((metric) => ListTile(
            leading: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: metric['color'],
                shape: BoxShape.circle,
              ),
            ),
            title: Text(metric['status']),
            trailing: Text(
              '${metric['count']} (${metric['percentage'].toStringAsFixed(1)}%)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildRevenueTab() {
    final totalRevenue = _revenueData.fold<double>(0, (sum, data) => sum + data['revenue']);
    final avgRevenue = totalRevenue / _revenueData.length;
    final growthRate = ((_revenueData.last['revenue'] - _revenueData.first['revenue']) / _revenueData.first['revenue'] * 100);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Analysis',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Revenue Summary
          Row(
            children: [
              Expanded(
                child: _buildRevenueCard('Total Revenue', '\$${NumberFormat('#,###').format(totalRevenue)}', Colors.green),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRevenueCard('Average Revenue', '\$${NumberFormat('#,###').format(avgRevenue.toInt())}', Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRevenueCard('Growth Rate', '${growthRate.toStringAsFixed(1)}%', growthRate >= 0 ? Colors.green : Colors.red),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRevenueCard('Best Month', 'June', Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Detailed Revenue Chart
          Text(
            'Monthly Revenue Breakdown',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailedRevenueChart(),
          const SizedBox(height: 24),
          
          // Revenue by Service Type
          Text(
            'Revenue by Service Type',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildServiceTypeRevenue(),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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

  Widget _buildDetailedRevenueChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _revenueData.map((data) => Column(
                children: [
                  Text(
                    data['month'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: (data['revenue'] / 70000 * 120).clamp(10.0, 120.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${(data['revenue'] / 1000).toStringAsFixed(0)}k',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTypeRevenue() {
    final serviceTypes = [
      {'type': 'HVAC', 'revenue': 180000, 'percentage': 35.2},
      {'type': 'Plumbing', 'revenue': 145000, 'percentage': 28.4},
      {'type': 'Electrical', 'revenue': 120000, 'percentage': 23.5},
      {'type': 'Emergency', 'revenue': 45000, 'percentage': 8.8},
      {'type': 'Other', 'revenue': 20000, 'percentage': 3.9},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: serviceTypes.map((service) => ListTile(
            leading: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _getServiceTypeColor(service['type']),
                shape: BoxShape.circle,
              ),
            ),
            title: Text(service['type']),
            subtitle: Text('\$${NumberFormat('#,###').format(service['revenue'])}'),
            trailing: Text(
              '${service['percentage'].toStringAsFixed(1)}%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Performance',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Performance Summary
          Row(
            children: [
              Expanded(
                child: _buildPerformanceCard('Top Performer', 'Arjun Singh', Icons.emoji_events, Colors.amber),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPerformanceCard('Most Efficient', 'Arjun Singh', Icons.speed, Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPerformanceCard('Highest Rated', 'Arjun Singh', Icons.star, Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPerformanceCard('Most Revenue', 'Maya Chen', Icons.attach_money, Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Technician Performance Table
          Text(
            'Technician Performance',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTechnicianPerformanceTable(),
          const SizedBox(height: 24),
          
          // Performance Metrics
          Text(
            'Performance Metrics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPerformanceMetrics(),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
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

  Widget _buildTechnicianPerformanceTable() {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Technician')),
            DataColumn(label: Text('Jobs')),
            DataColumn(label: Text('Rating')),
            DataColumn(label: Text('Revenue')),
            DataColumn(label: Text('Efficiency')),
          ],
          rows: _technicianPerformance.map((tech) => DataRow(
            cells: [
              DataCell(Text(tech['name'])),
              DataCell(Text(tech['jobsCompleted'].toString())),
              DataCell(Text(tech['avgRating'].toString())),
              DataCell(Text('\$${NumberFormat('#,###').format(tech['revenue'])}')),
              DataCell(Text('${tech['efficiency']}%')),
            ],
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    final avgJobsPerTech = _technicianPerformance.fold<int>(0, (sum, tech) => sum + tech['jobsCompleted']) / _technicianPerformance.length;
    final avgRating = _technicianPerformance.fold<double>(0, (sum, tech) => sum + tech['avgRating']) / _technicianPerformance.length;
    final avgEfficiency = _technicianPerformance.fold<int>(0, (sum, tech) => sum + tech['efficiency']) / _technicianPerformance.length;

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard('Avg Jobs/Tech', avgJobsPerTech.toStringAsFixed(0), Icons.work, Colors.blue),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard('Avg Rating', avgRating.toStringAsFixed(1), Icons.star, Colors.orange),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard('Avg Efficiency', '${avgEfficiency.toStringAsFixed(0)}%', Icons.speed, Colors.green),
        ),
      ],
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Trends',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Trend Summary
          Row(
            children: [
              Expanded(
                child: _buildTrendCard('Revenue Trend', '+12.5%', Icons.trending_up, Colors.green),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTrendCard('Customer Growth', '+8.2%', Icons.people, Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTrendCard('Job Completion', '+5.8%', Icons.check_circle, Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTrendCard('Satisfaction', '+2.1%', Icons.thumb_up, Colors.purple),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Monthly Trends
          Text(
            'Monthly Trends',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildMonthlyTrendsChart(),
          const SizedBox(height: 24),
          
          // Forecast
          Text(
            'Forecast & Predictions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildForecastSection(),
        ],
      ),
    );
  }

  Widget _buildTrendCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

  Widget _buildMonthlyTrendsChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _revenueData.map((data) => Column(
                children: [
                  Text(data['month']),
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: (data['jobs'] / 70 * 100).clamp(10.0, 100.0),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['jobs'].toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              )).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Jobs Completed per Month',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Next Quarter Forecast',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildForecastItem('Revenue', '\$195,000', '+15.2%'),
            _buildForecastItem('Jobs', '180', '+12.8%'),
            _buildForecastItem('New Customers', '25', '+18.5%'),
            _buildForecastItem('Team Efficiency', '94%', '+2.1%'),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastItem(String metric, String value, String change) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(metric),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            change,
            style: TextStyle(
              color: change.startsWith('+') ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getServiceTypeColor(String type) {
    switch (type) {
      case 'HVAC':
        return Colors.blue;
      case 'Plumbing':
        return Colors.green;
      case 'Electrical':
        return Colors.orange;
      case 'Emergency':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Analytics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Time Period'),
              value: _selectedPeriod,
              items: const [
                DropdownMenuItem(value: 'week', child: Text('This Week')),
                DropdownMenuItem(value: 'month', child: Text('This Month')),
                DropdownMenuItem(value: 'quarter', child: Text('This Quarter')),
                DropdownMenuItem(value: 'year', child: Text('This Year')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPeriod = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Primary Metric'),
              value: _selectedMetric,
              items: const [
                DropdownMenuItem(value: 'revenue', child: Text('Revenue')),
                DropdownMenuItem(value: 'jobs', child: Text('Jobs')),
                DropdownMenuItem(value: 'customers', child: Text('Customers')),
                DropdownMenuItem(value: 'efficiency', child: Text('Efficiency')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedMetric = value!;
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

  void _exportReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Report'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Export analytics data as a report.'),
            SizedBox(height: 16),
            Text('Available formats:'),
            SizedBox(height: 8),
            Text('• PDF Report'),
            Text('• Excel Spreadsheet'),
            Text('• CSV Data Export'),
            Text('• PowerPoint Presentation'),
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
                const SnackBar(content: Text('Report export coming soon!')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }
} 