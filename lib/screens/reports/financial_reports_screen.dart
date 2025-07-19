import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinancialReportsScreen extends StatefulWidget {
  const FinancialReportsScreen({super.key});

  @override
  State<FinancialReportsScreen> createState() => _FinancialReportsScreenState();
}

class _FinancialReportsScreenState extends State<FinancialReportsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'This Month';
  String _selectedReportType = 'revenue';
  
  final List<String> _periods = [
    'This Week', 'This Month', 'This Quarter', 'This Year', 'Last Year', 'Custom Range'
  ];
  
  final List<String> _reportTypes = [
    'revenue', 'expenses', 'profit', 'cash_flow', 'accounts_receivable', 'accounts_payable'
  ];

  final Map<String, String> _reportTypeLabels = {
    'revenue': 'Revenue',
    'expenses': 'Expenses',
    'profit': 'Profit & Loss',
    'cash_flow': 'Cash Flow',
    'accounts_receivable': 'Accounts Receivable',
    'accounts_payable': 'Accounts Payable',
  };

  // Sample financial data
  final Map<String, dynamic> _financialData = {
    'revenue': {
      'current': 48650.00,
      'previous': 42300.00,
      'growth': 15.0,
      'target': 50000.00,
      'monthly': [
        {'month': 'Jan', 'amount': 35000, 'target': 40000},
        {'month': 'Feb', 'amount': 38500, 'target': 42000},
        {'month': 'Mar', 'amount': 42300, 'target': 44000},
        {'month': 'Apr', 'amount': 45800, 'target': 46000},
        {'month': 'May', 'amount': 48650, 'target': 50000},
      ],
      'by_service': [
        {'service': 'Pest Control', 'amount': 18500, 'percentage': 38},
        {'service': 'HVAC Services', 'amount': 15200, 'percentage': 31},
        {'service': 'Electrical Work', 'amount': 8900, 'percentage': 18},
        {'service': 'Plumbing', 'amount': 4300, 'percentage': 9},
        {'service': 'Emergency Services', 'amount': 1750, 'percentage': 4},
      ],
    },
    'expenses': {
      'current': 32450.00,
      'previous': 29800.00,
      'growth': 8.9,
      'categories': [
        {'category': 'Labor', 'amount': 18500, 'percentage': 57},
        {'category': 'Materials', 'amount': 8900, 'percentage': 27},
        {'category': 'Vehicle & Fuel', 'amount': 3200, 'percentage': 10},
        {'category': 'Insurance', 'amount': 1200, 'percentage': 4},
        {'category': 'Other', 'amount': 650, 'percentage': 2},
      ],
    },
    'profit': {
      'gross_profit': 16200.00,
      'net_profit': 12850.00,
      'margin': 26.4,
      'monthly_trend': [
        {'month': 'Jan', 'gross': 12000, 'net': 9500},
        {'month': 'Feb', 'gross': 13500, 'net': 10800},
        {'month': 'Mar', 'gross': 14800, 'net': 11800},
        {'month': 'Apr', 'gross': 16200, 'net': 12850},
        {'month': 'May', 'gross': 17500, 'net': 13800},
      ],
    },
    'cash_flow': {
      'operating': 15200.00,
      'investing': -3200.00,
      'financing': -8000.00,
      'net_change': 4000.00,
      'opening_balance': 25000.00,
      'closing_balance': 29000.00,
    },
    'accounts_receivable': {
      'total_outstanding': 18500.00,
      'overdue': 4200.00,
      'aging': [
        {'period': '0-30 days', 'amount': 9800, 'percentage': 53},
        {'period': '31-60 days', 'amount': 4500, 'percentage': 24},
        {'period': '61-90 days', 'amount': 3200, 'percentage': 17},
        {'period': '90+ days', 'amount': 1000, 'percentage': 6},
      ],
    },
  };

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
        title: const Text('Financial Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportReport,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareReport,
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
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Detailed', icon: Icon(Icons.analytics)),
            Tab(text: 'Charts', icon: Icon(Icons.bar_chart)),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildFiltersSection(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildDetailedTab(),
                _buildChartsTab(),
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedPeriod,
                  decoration: const InputDecoration(
                    labelText: 'Time Period',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _periods.map((period) {
                    return DropdownMenuItem(value: period, child: Text(period));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedPeriod = value!);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedReportType,
                  decoration: const InputDecoration(
                    labelText: 'Report Type',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _reportTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_reportTypeLabels[type]!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedReportType = value!);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Metrics
          _buildKeyMetrics(),
          const SizedBox(height: 24),

          // Revenue vs Expenses
          _buildRevenueVsExpenses(),
          const SizedBox(height: 24),

          // Profit Trend
          _buildProfitTrend(),
          const SizedBox(height: 24),

          // Cash Flow Summary
          _buildCashFlowSummary(),
        ],
      ),
    );
  }

  Widget _buildKeyMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Financial Metrics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Revenue',
                '\$${(_financialData['revenue']['current'] as num).toStringAsFixed(0)}',
                '+${(_financialData['revenue']['growth'] as num).toStringAsFixed(1)}%',
                Colors.green,
                Icons.trending_up,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Total Expenses',
                '\$${(_financialData['expenses']['current'] as num).toStringAsFixed(0)}',
                '+${(_financialData['expenses']['growth'] as num).toStringAsFixed(1)}%',
                Colors.orange,
                Icons.trending_down,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Net Profit',
                '\$${(_financialData['profit']['net_profit'] as num).toStringAsFixed(0)}',
                '${(_financialData['profit']['margin'] as num).toStringAsFixed(1)}% margin',
                Colors.blue,
                Icons.account_balance,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Cash Balance',
                '\$${(_financialData['cash_flow']['closing_balance'] as num).toStringAsFixed(0)}',
                '+${(_financialData['cash_flow']['net_change'] as num).toStringAsFixed(0)} change',
                Colors.purple,
                Icons.account_balance_wallet,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, String subtitle, Color color, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
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

  Widget _buildRevenueVsExpenses() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue vs Expenses',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Revenue',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${(_financialData['revenue']['current'] as num).toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Expenses',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${(_financialData['expenses']['current'] as num).toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: (_financialData['expenses']['current'] as num) / 
                     (_financialData['revenue']['current'] as num),
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            const SizedBox(height: 8),
            Text(
              'Expense Ratio: ${((_financialData['expenses']['current'] as num) / (_financialData['revenue']['current'] as num) * 100).toStringAsFixed(1)}%',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitTrend() {
    final profitData = _financialData['profit']['monthly_trend'] as List;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profit Trend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${(value / 1000).toInt()}k');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < profitData.length) {
                            return Text(profitData[value.toInt()]['month']);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: profitData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value['net'].toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashFlowSummary() {
    final cashFlow = _financialData['cash_flow'];
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cash Flow Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCashFlowRow('Operating Cash Flow', cashFlow['operating'], Colors.green),
            _buildCashFlowRow('Investing Cash Flow', cashFlow['investing'], Colors.blue),
            _buildCashFlowRow('Financing Cash Flow', cashFlow['financing'], Colors.orange),
            const Divider(height: 24),
            _buildCashFlowRow('Net Change', cashFlow['net_change'], Colors.purple, isBold: true),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Opening Balance:', style: TextStyle(color: Colors.grey[600])),
                Text('\$${cashFlow['opening_balance']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Closing Balance:', style: TextStyle(color: Colors.grey[600])),
                Text('\$${cashFlow['closing_balance']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashFlowRow(String label, num amount, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revenue Breakdown
          _buildRevenueBreakdown(),
          const SizedBox(height: 24),

          // Expense Breakdown
          _buildExpenseBreakdown(),
          const SizedBox(height: 24),

          // Accounts Receivable
          _buildAccountsReceivable(),
        ],
      ),
    );
  }

  Widget _buildRevenueBreakdown() {
    final revenueData = _financialData['revenue']['by_service'] as List;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue by Service Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...revenueData.map((service) => _buildServiceRow(
              service['service'],
              service['amount'],
              service['percentage'],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceRow(String service, num amount, num percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(service),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '\$${amount.toStringAsFixed(0)}',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseBreakdown() {
    final expenseData = _financialData['expenses']['categories'] as List;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense Breakdown',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...expenseData.map((category) => _buildServiceRow(
              category['category'],
              category['amount'],
              category['percentage'],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountsReceivable() {
    final arData = _financialData['accounts_receivable'];
    final agingData = arData['aging'] as List;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accounts Receivable',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Total Outstanding',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${arData['total_outstanding']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Overdue',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${arData['overdue']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Aging Analysis',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...agingData.map((aging) => _buildServiceRow(
              aging['period'],
              aging['amount'],
              aging['percentage'],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revenue Chart
          _buildRevenueChart(),
          const SizedBox(height: 24),

          // Expense Pie Chart
          _buildExpensePieChart(),
          const SizedBox(height: 24),

          // AR Aging Chart
          _buildARAgingChart(),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    final revenueData = _financialData['revenue']['monthly'] as List;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Revenue Trend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 60000,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${(value / 1000).toInt()}k');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < revenueData.length) {
                            return Text(revenueData[value.toInt()]['month']);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  barGroups: revenueData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value['amount'].toDouble(),
                          color: Colors.green,
                          width: 20,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensePieChart() {
    final expenseData = _financialData['expenses']['categories'] as List;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense Distribution',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: expenseData.asMap().entries.map((entry) {
                    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple];
                    return PieChartSectionData(
                      value: entry.value['amount'].toDouble(),
                      title: '${entry.value['percentage']}%',
                      color: colors[entry.key % colors.length],
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: expenseData.asMap().entries.map((entry) {
                final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: colors[entry.key % colors.length],
                    ),
                    const SizedBox(width: 4),
                    Text(entry.value['category']),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildARAgingChart() {
    final arData = _financialData['accounts_receivable']['aging'] as List;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accounts Receivable Aging',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 12000,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${(value / 1000).toInt()}k');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < arData.length) {
                            return Text(arData[value.toInt()]['period']);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  barGroups: arData.asMap().entries.map((entry) {
                    final colors = [Colors.green, Colors.blue, Colors.orange, Colors.red];
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value['amount'].toDouble(),
                          color: colors[entry.key % colors.length],
                          width: 20,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting financial report...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _shareReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing financial report...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'schedule':
        _showScheduleDialog();
        break;
      case 'settings':
        _showSettingsDialog();
        break;
      case 'help':
        _showHelpDialog();
        break;
    }
  }

  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule Reports'),
        content: const Text('Set up automated report delivery via email.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report scheduling coming soon')),
              );
            },
            child: const Text('Configure'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Settings'),
        content: const Text('Configure report preferences and formatting options.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report settings coming soon')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Financial Reports Help'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Overview: Key financial metrics and trends'),
            SizedBox(height: 8),
            Text('• Detailed: Breakdown by category and service'),
            SizedBox(height: 8),
            Text('• Charts: Visual representations of data'),
            SizedBox(height: 8),
            Text('• Export: Download reports in PDF/Excel format'),
            SizedBox(height: 8),
            Text('• Schedule: Set up automated report delivery'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 