import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> _inventoryItems = [
    {
      'id': 'INV001',
      'name': 'Eco-Safe Pest Spray',
      'category': 'Chemicals',
      'brand': 'EcoClean Pro',
      'sku': 'ECP-001',
      'currentStock': 15,
      'minStock': 10,
      'maxStock': 50,
      'unit': 'bottles',
      'unitPrice': 22.50,
      'totalValue': 337.50,
      'location': 'Warehouse A - Shelf 3',
      'status': 'in_stock',
    },
    {
      'id': 'INV002',
      'name': 'HVAC Filter - Standard',
      'category': 'Parts',
      'brand': 'FilterMax',
      'sku': 'FM-STD-20',
      'currentStock': 5,
      'minStock': 8,
      'maxStock': 30,
      'unit': 'pieces',
      'unitPrice': 15.00,
      'totalValue': 75.00,
      'location': 'Warehouse B - Shelf 1',
      'status': 'low_stock',
    },
    {
      'id': 'INV003',
      'name': 'Professional Bait Stations',
      'category': 'Equipment',
      'brand': 'PestGuard',
      'sku': 'PG-BS-12',
      'currentStock': 25,
      'minStock': 15,
      'maxStock': 60,
      'unit': 'units',
      'unitPrice': 8.75,
      'totalValue': 218.75,
      'location': 'Warehouse A - Shelf 5',
      'status': 'in_stock',
    },
    {
      'id': 'INV004',
      'name': 'Safety Equipment Set',
      'category': 'Safety',
      'brand': 'SafeWork Pro',
      'sku': 'SWP-SET-01',
      'currentStock': 12,
      'minStock': 5,
      'maxStock': 25,
      'unit': 'sets',
      'unitPrice': 35.00,
      'totalValue': 420.00,
      'location': 'Safety Cabinet - Main',
      'status': 'in_stock',
    },
    {
      'id': 'INV005',
      'name': 'Electrical Wire - 12 AWG',
      'category': 'Parts',
      'brand': 'ElectroMax',
      'sku': 'EM-12AWG-100',
      'currentStock': 0,
      'minStock': 5,
      'maxStock': 20,
      'unit': 'feet',
      'unitPrice': 1.25,
      'totalValue': 0.00,
      'location': 'Warehouse C - Shelf 2',
      'status': 'out_of_stock',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredItems {
    return _inventoryItems.where((item) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final name = (item['name'] ?? '').toString().toLowerCase();
        final sku = (item['sku'] ?? '').toString().toLowerCase();
        final brand = (item['brand'] ?? '').toString().toLowerCase();
        final searchQuery = _searchQuery.toLowerCase();
        
        if (!name.contains(searchQuery) && 
            !sku.contains(searchQuery) && 
            !brand.contains(searchQuery)) {
          return false;
        }
      }
      
      // Status filter
      switch (_selectedFilter) {
        case 'low_stock':
          return item['status'] == 'low_stock';
        case 'out_of_stock':
          return item['status'] == 'out_of_stock';
        case 'in_stock':
          return item['status'] == 'in_stock';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Barcode scanner coming soon!')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Items')),
              const PopupMenuItem(value: 'in_stock', child: Text('In Stock')),
              const PopupMenuItem(value: 'low_stock', child: Text('Low Stock')),
              const PopupMenuItem(value: 'out_of_stock', child: Text('Out of Stock')),
            ],
            child: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search items by name, SKU, or brand...',
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
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Stats Row
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _buildStatCard('Total', '${_inventoryItems.length}', Icons.inventory, Colors.blue)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard('Low Stock', '${_getLowStockCount()}', Icons.warning, Colors.orange)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard('Out of Stock', '${_getOutOfStockCount()}', Icons.error, Colors.red)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard('Value', '\$${_getTotalValue().toInt()}', Icons.attach_money, Colors.green)),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Filter Chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('In Stock', 'in_stock'),
                const SizedBox(width: 8),
                _buildFilterChip('Low Stock', 'low_stock'),
                const SizedBox(width: 8),
                _buildFilterChip('Out of Stock', 'out_of_stock'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Items List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
                setState(() {});
              },
              child: _filteredItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildInventoryCard(item),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'inventory_fab',
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add inventory item coming soon!')),
          );
        },
        backgroundColor: const Color(0xFF14B8A6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: const Color(0xFF14B8A6).withOpacity(0.2),
      checkmarkColor: const Color(0xFF14B8A6),
    );
  }

  Widget _buildInventoryCard(Map<String, dynamic> item) {
    final Color statusColor = _getStatusColor(item['status'] ?? 'in_stock');
    final int currentStock = item['currentStock'] ?? 0;
    final int maxStock = item['maxStock'] ?? 1;
    final double stockPercentage = maxStock > 0 ? currentStock / maxStock : 0.0;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => InventoryDetailScreen(item: item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(item['category']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(item['category']),
                      color: _getCategoryColor(item['category']),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name']?.toString() ?? 'Unknown Item',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'SKU: ${item['sku']?.toString() ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      (item['status']?.toString() ?? 'unknown').replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Stock Info
              Row(
                children: [
                  Text(
                    'Stock: $currentStock ${item['unit']?.toString() ?? 'units'}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    '\$${(item['totalValue'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Progress Bar
              LinearProgressIndicator(
                value: stockPercentage,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
              const SizedBox(height: 8),
              
              // Location
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item['location']?.toString() ?? 'Unknown Location',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (item['status'] == 'low_stock' || item['status'] == 'out_of_stock')
                    ElevatedButton(
                      onPressed: () => _showRestockDialog(item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14B8A6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Restock', style: TextStyle(fontSize: 12)),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No inventory items found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  int _getLowStockCount() {
    return _inventoryItems.where((item) => item['status'] == 'low_stock').length;
  }

  int _getOutOfStockCount() {
    return _inventoryItems.where((item) => item['status'] == 'out_of_stock').length;
  }

  double _getTotalValue() {
    return _inventoryItems.fold(0.0, (sum, item) => sum + ((item['totalValue'] as num?) ?? 0.0));
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'in_stock':
        return Colors.green;
      case 'low_stock':
        return Colors.orange;
      case 'out_of_stock':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'Chemicals':
        return Colors.purple;
      case 'Parts':
        return Colors.blue;
      case 'Equipment':
        return Colors.orange;
      case 'Safety':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'Chemicals':
        return Icons.science;
      case 'Parts':
        return Icons.settings;
      case 'Equipment':
        return Icons.build;
      case 'Safety':
        return Icons.security;
      default:
        return Icons.inventory;
    }
  }

  void _showRestockDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => RestockDialog(item: item),
    );
  }
}

// Simplified detail screen
class InventoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  
  const InventoryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']?.toString() ?? 'Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name']?.toString() ?? 'Unknown Item',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('SKU', item['sku']?.toString() ?? 'N/A'),
                    _buildDetailRow('Brand', item['brand']?.toString() ?? 'Unknown'),
                    _buildDetailRow('Category', item['category']?.toString() ?? 'Unknown'),
                    _buildDetailRow('Current Stock', '${item['currentStock'] ?? 0} ${item['unit']?.toString() ?? 'units'}'),
                    _buildDetailRow('Min Stock', '${item['minStock'] ?? 0}'),
                    _buildDetailRow('Max Stock', '${item['maxStock'] ?? 0}'),
                    _buildDetailRow('Unit Price', '\$${(item['unitPrice'] as num?)?.toStringAsFixed(2) ?? '0.00'}'),
                    _buildDetailRow('Total Value', '\$${(item['totalValue'] as num?)?.toStringAsFixed(2) ?? '0.00'}'),
                    _buildDetailRow('Location', item['location']?.toString() ?? 'Unknown'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

// Simplified restock dialog
class RestockDialog extends StatefulWidget {
  final Map<String, dynamic> item;
  
  const RestockDialog({super.key, required this.item});

  @override
  State<RestockDialog> createState() => _RestockDialogState();
}

class _RestockDialogState extends State<RestockDialog> {
  final _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Restock ${widget.item['name']?.toString() ?? 'Item'}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Current Stock: ${widget.item['currentStock'] ?? 0} ${widget.item['unit']?.toString() ?? 'units'}'),
          const SizedBox(height: 16),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantity to Add',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
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
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item restocked successfully')),
            );
          },
          child: const Text('Restock'),
        ),
      ],
    );
  }
} 