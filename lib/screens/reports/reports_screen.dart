import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'This Month';
  String _selectedTeamMember = 'All Team';
  
  final List<String> _periods = ['This Week', 'This Month', 'This Quarter', 'This Year', 'Custom Range'];
  final List<String> _teamMembers = ['All Team', 'Sam Rodriguez', 'Mike Johnson', 'Alex Chen', 'Sarah Williams'];

  // Sample analytics data
  final Map<String, dynamic> _analyticsData = {
    'revenue': {
      'current': 48650.00,
      'previous': 42300.00,
      'target': 50000.00,
      'growth': 15.0,
    },
    'jobs': {
      'completed': 127,
      'pending': 8,
      'cancelled': 3,
      'total': 138,
      'completion_rate': 92.0,
    },
    'customer_satisfaction': {
      'average_rating': 4.7,
      'total_reviews': 89,
      'nps_score': 68,
    },
    'team_performance': {
      'average_job_time': 2.4,
      'jobs_per_technician': 31.7,
      'efficiency_score': 87.5,
    },
    'financial_breakdown': [
      {'category': 'Pest Control', 'amount': 18500, 'percentage': 38},
      {'category': 'HVAC Services', 'amount': 15200, 'percentage': 31},
      {'category': 'Electrical Work', 'amount': 8900, 'percentage': 18},
      {'category': 'Plumbing', 'amount': 4300, 'percentage': 9},
      {'category': 'Emergency Services', 'amount': 1750, 'percentage': 4},
    ],
    'monthly_revenue': [
      {'month': 'Jan', 'revenue': 35000, 'jobs': 98},
      {'month': 'Feb', 'revenue': 38500, 'jobs': 105},
      {'month': 'Mar', 'revenue': 42300, 'jobs': 118},
      {'month': 'Apr', 'revenue': 45800, 'jobs': 125},
      {'month': 'May', 'revenue': 48650, 'jobs': 138},
    ],
    'top_clients': [
      {'name': 'Downtown Office Complex', 'revenue': 8500, 'jobs': 12},
      {'name': 'Green Valley Restaurant Chain', 'revenue': 6200, 'jobs': 18},
      {'name': 'Tech Solutions Inc.', 'revenue': 4800, 'jobs': 8},
      {'name': 'City Plaza Mall', 'revenue': 3900, 'jobs': 15},
      {'name': 'Metro Hospital Network', 'revenue': 3200, 'jobs': 6},
    ],
  };

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
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportReports,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareReports,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'schedule', child: Text('Schedule Reports')),
              const PopupMenuItem(value: 'settings', child: Text('Report Settings')),
              const PopupMenuItem(value: 'help', child: Text('Help & Tutorials')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Financial', icon: Icon(Icons.attach_money)),
            Tab(text: 'Performance', icon: Icon(Icons.trending_up)),
            Tab(text: 'Custom', icon: Icon(Icons.bar_chart)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filters Section
          _buildFiltersSection(),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildFinancialTab(),
                _buildPerformanceTab(),
                _buildCustomTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Stack vertically on smaller screens
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        'Period',
                        _selectedPeriod,
                        _periods,
                        (value) => setState(() => _selectedPeriod = value!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFilterDropdown(
                        'Team Member',
                        _selectedTeamMember,
                        _teamMembers,
                        (value) => setState(() => _selectedTeamMember = value!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _refreshData,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF14B8A6),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Horizontal layout for larger screens
            return Row(
              children: [
                Expanded(
                  child: _buildFilterDropdown(
                    'Period',
                    _selectedPeriod,
                    _periods,
                    (value) => setState(() => _selectedPeriod = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFilterDropdown(
                    'Team Member',
                    _selectedTeamMember,
                    _teamMembers,
                    (value) => setState(() => _selectedTeamMember = value!),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _refreshData,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            isDense: true,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item, 
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Metrics Row
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Revenue',
                  '\$${(_analyticsData['revenue']['current'] as num? ?? 0).toStringAsFixed(0)}',
                  '+${(_analyticsData['revenue']['growth'] as num? ?? 0).toStringAsFixed(1)}%',
                  Icons.attach_money,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Jobs Completed',
                  '${_analyticsData['jobs']['completed']}',
                  '${(_analyticsData['jobs']['completion_rate'] as num? ?? 0).toStringAsFixed(0)}% rate',
                  Icons.check_circle,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Customer Rating',
                  '${_analyticsData['customer_satisfaction']['average_rating']}⭐',
                  '${_analyticsData['customer_satisfaction']['total_reviews']} reviews',
                  Icons.star,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Team Efficiency',
                  '${(_analyticsData['team_performance']['efficiency_score'] as num? ?? 0).toStringAsFixed(0)}%',
                  '${(_analyticsData['team_performance']['average_job_time'] as num? ?? 0)}h avg',
                  Icons.trending_up,
                  const Color(0xFF14B8A6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Revenue Chart
          _buildRevenueChart(),
          const SizedBox(height: 24),

          // Service Breakdown
          _buildServiceBreakdown(),
          const SizedBox(height: 24),

          // Top Clients
          _buildTopClients(),
        ],
      ),
    );
  }

  Widget _buildFinancialTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Financial Overview
          Row(
            children: [
              Expanded(
                child: _buildFinancialCard(
                  'Total Revenue',
                  '\$${(_analyticsData['revenue']['current'] as num? ?? 0).toStringAsFixed(0)}',
                  'vs Target: \$${(_analyticsData['revenue']['target'] as num? ?? 0).toStringAsFixed(0)}',
                  _calculateProgress(_analyticsData['revenue']['current'], _analyticsData['revenue']['target']),
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFinancialCard(
                  'Growth Rate',
                  '+${(_analyticsData['revenue']['growth'] as num? ?? 0).toStringAsFixed(1)}%',
                  'vs Last Period',
                  _calculateProgress(_analyticsData['revenue']['growth'], 100),
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Monthly Revenue Trend
          _buildMonthlyRevenueTrend(),
          const SizedBox(height: 24),

          // Revenue by Service Type
          _buildRevenueByServiceType(),
          const SizedBox(height: 24),

          // Payment Status
          _buildPaymentStatus(),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team Performance Overview
          _buildTeamPerformanceOverview(),
          const SizedBox(height: 24),

          // Individual Performance
          _buildIndividualPerformance(),
          const SizedBox(height: 24),

          // Job Completion Trends
          _buildJobCompletionTrends(),
          const SizedBox(height: 24),

          // Customer Satisfaction Metrics
          _buildCustomerSatisfactionMetrics(),
        ],
      ),
    );
  }

  Widget _buildCustomTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Custom Reports',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Report Builder
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Build Custom Report',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Select metrics to include:'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildCustomMetricChip('Revenue', true),
                      _buildCustomMetricChip('Jobs Completed', true),
                      _buildCustomMetricChip('Customer Ratings', false),
                      _buildCustomMetricChip('Team Performance', false),
                      _buildCustomMetricChip('Response Time', false),
                      _buildCustomMetricChip('Route Efficiency', false),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetCustomReport,
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _generateCustomReport,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Generate Report'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Saved Reports
          _buildSavedReports(),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard(String title, String value, String subtitle, double progress, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress > 1 ? 1 : progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.show_chart, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'Revenue Chart Visualization',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Monthly revenue trends would be displayed here',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue by Service Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...(_analyticsData['financial_breakdown'] as List).map((service) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(service['category']),
                    ),
                    Expanded(
                      flex: 2,
                      child: LinearProgressIndicator(
                        value: service['percentage'] / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF14B8A6)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '\$${service['amount']}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopClients() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Clients',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _viewAllClients,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...(_analyticsData['top_clients'] as List).take(5).map((client) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF14B8A6),
                  child: Text(
                    client['name'].toString().substring(0, 1),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(client['name']),
                subtitle: Text('${client['jobs']} jobs completed'),
                trailing: Text(
                  '\$${client['revenue']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF14B8A6),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyRevenueTrend() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Revenue Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Line chart showing monthly revenue progression',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueByServiceType() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Pie chart showing revenue by service type',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildPaymentStatusCard('Paid', '\$42,300', 87, Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildPaymentStatusCard('Pending', '\$5,200', 11, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildPaymentStatusCard('Overdue', '\$1,150', 2, Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatusCard(String status, String amount, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            '$count invoices',
            style: TextStyle(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamPerformanceOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Team Performance Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildPerformanceMetric('Avg Job Time', '2.4h', Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildPerformanceMetric('Jobs/Technician', '31.7', Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildPerformanceMetric('Efficiency Score', '87.5%', const Color(0xFF14B8A6))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetric(String title, String value, Color color) {
    return Column(
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
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildIndividualPerformance() {
    final teamPerformance = [
      {'name': 'Sam Rodriguez', 'jobs': 45, 'rating': 4.8, 'efficiency': 92},
      {'name': 'Mike Johnson', 'jobs': 38, 'rating': 4.6, 'efficiency': 89},
      {'name': 'Alex Chen', 'jobs': 42, 'rating': 4.7, 'efficiency': 91},
      {'name': 'Sarah Williams', 'jobs': 35, 'rating': 4.9, 'efficiency': 85},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Individual Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...teamPerformance.map((member) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF14B8A6),
                      child: Text(
                        member['name'].toString().split(' ').map((n) => n[0]).join(),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member['name'].toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${member['jobs']} jobs • ${member['rating']}⭐ • ${member['efficiency']}% efficiency',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCompletionTrends() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Job Completion Trends',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Bar chart showing daily job completions',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSatisfactionMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Satisfaction',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSatisfactionMetric(
                    'Avg Rating',
                    '${_analyticsData['customer_satisfaction']['average_rating']}⭐',
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSatisfactionMetric(
                    'Total Reviews',
                    '${_analyticsData['customer_satisfaction']['total_reviews']}',
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSatisfactionMetric(
                    'NPS Score',
                    '${_analyticsData['customer_satisfaction']['nps_score']}',
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSatisfactionMetric(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomMetricChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {},
      backgroundColor: Colors.grey[200],
      selectedColor: const Color(0xFF14B8A6).withOpacity(0.2),
      checkmarkColor: const Color(0xFF14B8A6),
    );
  }

  Widget _buildSavedReports() {
    final savedReports = [
      {'name': 'Monthly Performance Report', 'created': '3 days ago', 'type': 'Performance'},
      {'name': 'Financial Summary Q1', 'created': '1 week ago', 'type': 'Financial'},
      {'name': 'Team Efficiency Analysis', 'created': '2 weeks ago', 'type': 'Custom'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saved Reports',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...savedReports.map((report) {
              return ListTile(
                leading: const Icon(Icons.description, color: Color(0xFF14B8A6)),
                title: Text(report['name']!),
                subtitle: Text('${report['type']} • ${report['created']}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) => _handleReportAction(value, report['name']!),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'view', child: Text('View')),
                    const PopupMenuItem(value: 'download', child: Text('Download')),
                    const PopupMenuItem(value: 'share', child: Text('Share')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Action handlers
  void _exportReports() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Export Reports',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Export as PDF'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting reports as PDF...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export as Excel'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting reports as Excel...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart),
              title: const Text('Export as CSV'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting reports as CSV...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareReports() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing reports...')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'schedule':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule reports feature coming soon')),
        );
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report settings coming soon')),
        );
        break;
      case 'help':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Help documentation coming soon')),
        );
        break;
    }
  }

  void _refreshData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing analytics data...')),
    );
  }

  void _viewAllClients() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Full client list coming soon')),
    );
  }

  void _resetCustomReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Custom report reset')),
    );
  }

  void _generateCustomReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating custom report...')),
    );
  }

  void _handleReportAction(String action, String reportName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action: $reportName')),
    );
  }

  double _calculateProgress(dynamic current, dynamic target) {
    final currentNum = current as num? ?? 0;
    final targetNum = target as num? ?? 1; // Use 1 to avoid division by zero
    if (targetNum == 0) return 0.0;
    return (currentNum / targetNum).clamp(0.0, 1.0);
  }
} 