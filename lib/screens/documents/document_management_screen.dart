import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DocumentManagementScreen extends StatefulWidget {
  const DocumentManagementScreen({super.key});

  @override
  State<DocumentManagementScreen> createState() => _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _filterType = 'all';
  String _filterStatus = 'all';
  Map<String, dynamic>? _selectedDocument;

  final List<Map<String, dynamic>> _documents = [
    {
      'id': '1',
      'name': 'Service Contract - Office Complex A',
      'type': 'contract',
      'category': 'legal',
      'size': '2.4 MB',
      'uploadDate': DateTime.now().subtract(const Duration(days: 30)),
      'uploadedBy': 'Sam Rodriguez',
      'status': 'active',
      'jobId': '1',
      'jobTitle': 'Quarterly Pest Control',
      'client': 'Office Complex A',
      'tags': ['contract', 'pest-control', 'quarterly'],
      'description': 'Annual service contract for pest control services',
      'fileExtension': 'pdf',
      'isShared': true,
      'sharedWith': ['Maya Chen', 'Ravi Patel'],
    },
    {
      'id': '2',
      'name': 'HVAC Maintenance Report',
      'type': 'report',
      'category': 'technical',
      'size': '1.8 MB',
      'uploadDate': DateTime.now().subtract(const Duration(days: 2)),
      'uploadedBy': 'Ravi Patel',
      'status': 'active',
      'jobId': '2',
      'jobTitle': 'HVAC Maintenance',
      'client': 'Community Center',
      'tags': ['hvac', 'maintenance', 'report'],
      'description': 'Detailed maintenance report with findings and recommendations',
      'fileExtension': 'pdf',
      'isShared': false,
      'sharedWith': [],
    },
    {
      'id': '3',
      'name': 'Emergency Plumbing Photos',
      'type': 'photo',
      'category': 'evidence',
      'size': '4.2 MB',
      'uploadDate': DateTime.now().subtract(const Duration(hours: 6)),
      'uploadedBy': 'Arjun Singh',
      'status': 'active',
      'jobId': '3',
      'jobTitle': 'Emergency Plumbing',
      'client': 'Residential Building',
      'tags': ['emergency', 'plumbing', 'photos'],
      'description': 'Before and after photos of emergency plumbing repair',
      'fileExtension': 'jpg',
      'isShared': true,
      'sharedWith': ['Sam Rodriguez'],
    },
    {
      'id': '4',
      'name': 'Invoice Template',
      'type': 'template',
      'category': 'business',
      'size': '0.8 MB',
      'uploadDate': DateTime.now().subtract(const Duration(days: 15)),
      'uploadedBy': 'Sam Rodriguez',
      'status': 'active',
      'jobId': null,
      'jobTitle': null,
      'client': null,
      'tags': ['template', 'invoice', 'business'],
      'description': 'Standard invoice template for field services',
      'fileExtension': 'docx',
      'isShared': true,
      'sharedWith': ['Maya Chen', 'Ravi Patel', 'Arjun Singh', 'Sarah Williams'],
    },
    {
      'id': '5',
      'name': 'Safety Guidelines',
      'type': 'manual',
      'category': 'safety',
      'size': '3.1 MB',
      'uploadDate': DateTime.now().subtract(const Duration(days: 7)),
      'uploadedBy': 'Sam Rodriguez',
      'status': 'active',
      'jobId': null,
      'jobTitle': null,
      'client': null,
      'tags': ['safety', 'guidelines', 'manual'],
      'description': 'Updated safety guidelines for field technicians',
      'fileExtension': 'pdf',
      'isShared': true,
      'sharedWith': ['Maya Chen', 'Ravi Patel', 'Arjun Singh', 'Sarah Williams'],
    },
    {
      'id': '6',
      'name': 'Equipment Warranty',
      'type': 'warranty',
      'category': 'legal',
      'size': '1.5 MB',
      'uploadDate': DateTime.now().subtract(const Duration(days: 5)),
      'uploadedBy': 'Sarah Williams',
      'status': 'archived',
      'jobId': null,
      'jobTitle': null,
      'client': null,
      'tags': ['warranty', 'equipment', 'legal'],
      'description': 'Warranty documentation for HVAC diagnostic kit',
      'fileExtension': 'pdf',
      'isShared': false,
      'sharedWith': [],
    },
  ];

  final List<Map<String, dynamic>> _documentTypes = [
    {'id': 'contract', 'name': 'Contracts', 'icon': Icons.description, 'color': Colors.blue},
    {'id': 'report', 'name': 'Reports', 'icon': Icons.assessment, 'color': Colors.green},
    {'id': 'photo', 'name': 'Photos', 'icon': Icons.photo, 'color': Colors.orange},
    {'id': 'template', 'name': 'Templates', 'icon': Icons.description, 'color': Colors.purple},
    {'id': 'manual', 'name': 'Manuals', 'icon': Icons.menu_book, 'color': Colors.red},
    {'id': 'warranty', 'name': 'Warranties', 'icon': Icons.security, 'color': Colors.teal},
    {'id': 'invoice', 'name': 'Invoices', 'icon': Icons.receipt, 'color': Colors.indigo},
    {'id': 'other', 'name': 'Other', 'icon': Icons.more_horiz, 'color': Colors.grey},
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

  List<Map<String, dynamic>> get _filteredDocuments {
    return _documents.where((document) {
      final matchesSearch = document['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          document['description'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          document['tags'].any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      
      final matchesType = _filterType == 'all' || document['type'] == _filterType;
      final matchesStatus = _filterStatus == 'all' || document['status'] == _filterStatus;
      
      return matchesSearch && matchesType && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Documents',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showAdvancedSearch,
            tooltip: 'Advanced Search',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Documents'),
            Tab(text: 'Categories'),
            Tab(text: 'Shared'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDocumentsTab(),
          _buildCategoriesTab(),
          _buildSharedTab(),
          _buildAnalyticsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'document_fab',
        onPressed: _uploadDocument,
        backgroundColor: const Color(0xFF14B8A6),
        child: const Icon(Icons.upload, color: Colors.white),
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: _filteredDocuments.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No documents found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredDocuments.length,
                  itemBuilder: (context, index) {
                    final document = _filteredDocuments[index];
                    return _buildDocumentCard(document);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search documents...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
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
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> document) {
    final type = _documentTypes.firstWhere((t) => t['id'] == document['type']);
    final statusColor = _getStatusColor(document['status']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: type['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            type['icon'],
            color: type['color'],
          ),
        ),
        title: Text(
          document['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(document['description']),
            Text(
              '${DateFormat('MMM dd, yyyy').format(document['uploadDate'])} • ${document['uploadedBy']}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    document['status'].toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: type['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    type['name'].toUpperCase(),
                    style: TextStyle(
                      color: type['color'],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (document['isShared'])
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'SHARED',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
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
            Text(
              document['size'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            Text(
              document['fileExtension'].toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        onTap: () => _showDocumentDetails(document),
      ),
    );
  }

  Widget _buildCategoriesTab() {
    final categoryCounts = <String, int>{};
    final categorySizes = <String, double>{};
    
    for (final document in _documents) {
      final type = document['type'];
      categoryCounts[type] = (categoryCounts[type] ?? 0) + 1;
      categorySizes[type] = (categorySizes[type] ?? 0) + _parseFileSize(document['size']);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document Categories',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Category Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _documentTypes.length,
            itemBuilder: (context, index) {
              final type = _documentTypes[index];
              final count = categoryCounts[type['id']] ?? 0;
              final size = categorySizes[type['id']] ?? 0.0;
              
              return _buildCategoryCard(type, count, size);
            },
          ),
          const SizedBox(height: 24),
          
          // Category Breakdown
          Text(
            'Category Breakdown',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _documentTypes.length,
              itemBuilder: (context, index) {
                final type = _documentTypes[index];
                final count = categoryCounts[type['id']] ?? 0;
                final size = categorySizes[type['id']] ?? 0.0;
                final percentage = _documents.isNotEmpty ? (count / _documents.length * 100) : 0;
                
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: type['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      type['icon'],
                      color: type['color'],
                      size: 20,
                    ),
                  ),
                  title: Text(type['name']),
                  subtitle: Text('${count} documents'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${size.toStringAsFixed(1)} MB',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
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

  Widget _buildCategoryCard(Map<String, dynamic> type, int count, double size) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: type['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                type['icon'],
                color: type['color'],
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              type['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '$count documents',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 18,
              ),
            ),
            Text(
              '${size.toStringAsFixed(1)} MB',
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

  Widget _buildSharedTab() {
    final sharedDocuments = _documents.where((d) => d['isShared']).toList();
    
    return Column(
      children: [
        _buildSharedStats(sharedDocuments),
        Expanded(
          child: sharedDocuments.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No shared documents',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sharedDocuments.length,
                  itemBuilder: (context, index) {
                    final document = sharedDocuments[index];
                    return _buildSharedDocumentCard(document);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSharedStats(List<Map<String, dynamic>> sharedDocuments) {
    final totalShared = sharedDocuments.length;
    final totalSize = sharedDocuments.fold<double>(0, (sum, d) => sum + _parseFileSize(d['size']));
    final uniqueUsers = <String>{};
    for (final doc in sharedDocuments) {
      uniqueUsers.addAll(doc['sharedWith']);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Shared Docs', totalShared.toString(), Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Total Size', '${totalSize.toStringAsFixed(1)} MB', Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Users', uniqueUsers.length.toString(), Colors.orange),
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
              fontSize: 20,
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

  Widget _buildSharedDocumentCard(Map<String, dynamic> document) {
    final type = _documentTypes.firstWhere((t) => t['id'] == document['type']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: type['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            type['icon'],
            color: type['color'],
          ),
        ),
        title: Text(document['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(document['description']),
            Text(
              'Shared with: ${document['sharedWith'].join(', ')}',
              style: TextStyle(color: Colors.blue, fontSize: 12),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showShareOptions(document),
        ),
        onTap: () => _showDocumentDetails(document),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    final totalDocuments = _documents.length;
    final totalSize = _documents.fold<double>(0, (sum, d) => sum + _parseFileSize(d['size']));
    final sharedDocuments = _documents.where((d) => d['isShared']).length;
    final recentUploads = _documents.where((d) => 
      d['uploadDate'].isAfter(DateTime.now().subtract(const Duration(days: 7)))
    ).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document Analytics',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Key Metrics
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard('Total Documents', totalDocuments.toString(), Icons.folder, Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard('Total Size', '${totalSize.toStringAsFixed(1)} MB', Icons.storage, Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard('Shared', sharedDocuments.toString(), Icons.share, Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard('Recent Uploads', recentUploads.toString(), Icons.upload, Colors.purple),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // File Type Distribution
          Text(
            'File Type Distribution',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFileTypeChart(),
          const SizedBox(height: 24),
          
          // Recent Activity
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentActivityList(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
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

  Widget _buildFileTypeChart() {
    final fileTypeCounts = <String, int>{};
    for (final document in _documents) {
      final extension = document['fileExtension'];
      fileTypeCounts[extension] = (fileTypeCounts[extension] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: fileTypeCounts.entries.map((entry) {
            final percentage = (entry.value / _documents.length * 100).toStringAsFixed(1);
            return ListTile(
              leading: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _getFileTypeColor(entry.key),
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(entry.key.toUpperCase()),
              trailing: Text(
                '$percentage% (${entry.value})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRecentActivityList() {
    final recentDocuments = List<Map<String, dynamic>>.from(_documents);
    recentDocuments.sort((a, b) => b['uploadDate'].compareTo(a['uploadDate']));

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentDocuments.take(5).length,
        itemBuilder: (context, index) {
          final document = recentDocuments[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF14B8A6),
              child: Text(
                document['uploadedBy'][0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(document['name']),
            subtitle: Text('${document['uploadedBy']} • ${DateFormat('MMM dd').format(document['uploadDate'])}'),
            trailing: Text(
              document['size'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'archived':
        return Colors.grey;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getFileTypeColor(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'docx':
        return Colors.blue;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.green;
      case 'xlsx':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  double _parseFileSize(String size) {
    final number = double.parse(size.split(' ')[0]);
    final unit = size.split(' ')[1];
    
    switch (unit) {
      case 'KB':
        return number / 1024;
      case 'MB':
        return number;
      case 'GB':
        return number * 1024;
      default:
        return number;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Documents'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Document Type'),
              value: _filterType,
              items: [
                const DropdownMenuItem(value: 'all', child: Text('All Types')),
                ..._documentTypes.map((type) => DropdownMenuItem(
                  value: type['id'],
                  child: Text(type['name']),
                )),
              ],
              onChanged: (value) {
                setState(() {
                  _filterType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Status'),
              value: _filterStatus,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'archived', child: Text('Archived')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
              ],
              onChanged: (value) {
                setState(() {
                  _filterStatus = value!;
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

  void _showAdvancedSearch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Advanced Search'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Document Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Tags',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Uploaded By',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Date Range',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _uploadDocument() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Document'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Upload a new document to the system.'),
            SizedBox(height: 16),
            Text('This will include:'),
            SizedBox(height: 8),
            Text('• File selection'),
            Text('• Document metadata'),
            Text('• Category assignment'),
            Text('• Sharing options'),
            Text('• Job association'),
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
                const SnackBar(content: Text('Document upload coming soon!')),
              );
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _showDocumentDetails(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Document Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Name', document['name']),
              _buildDetailRow('Description', document['description']),
              _buildDetailRow('Type', _documentTypes.firstWhere((t) => t['id'] == document['type'])['name']),
              _buildDetailRow('Size', document['size']),
              _buildDetailRow('Upload Date', DateFormat('MMM dd, yyyy').format(document['uploadDate'])),
              _buildDetailRow('Uploaded By', document['uploadedBy']),
              _buildDetailRow('Status', document['status'].toUpperCase()),
              if (document['jobTitle'] != null)
                _buildDetailRow('Job', document['jobTitle']),
              if (document['client'] != null)
                _buildDetailRow('Client', document['client']),
              _buildDetailRow('Tags', document['tags'].join(', ')),
              _buildDetailRow('Shared', document['isShared'] ? 'Yes' : 'No'),
              if (document['isShared'] && document['sharedWith'].isNotEmpty)
                _buildDetailRow('Shared With', document['sharedWith'].join(', ')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadDocument(document);
            },
            child: const Text('Download'),
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

  void _showShareOptions(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this document with team members.'),
            const SizedBox(height: 16),
            const Text('Available users:'),
            const SizedBox(height: 8),
            const Text('• Maya Chen'),
            const Text('• Ravi Patel'),
            const Text('• Arjun Singh'),
            const Text('• Sarah Williams'),
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
                SnackBar(content: Text('${document['name']} shared')),
              );
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _downloadDocument(Map<String, dynamic> document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${document['name']}...')),
    );
  }
} 