import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CreateInvoiceScreen extends StatefulWidget {
  final Map<String, dynamic>? invoice;

  const CreateInvoiceScreen({super.key, this.invoice});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers
  final TextEditingController _invoiceNumberController = TextEditingController();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _jobReferenceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _termsController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  // Form data
  DateTime _invoiceDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  String _selectedClient = '';
  String _paymentTerms = '30';
  String _status = 'draft';
  double _taxRate = 8.5;
  double _discountAmount = 0.0;
  String _discountType = 'amount'; // amount or percentage
  
  final List<Map<String, dynamic>> _lineItems = [];
  
  final List<String> _paymentTermsOptions = ['15', '30', '45', '60', 'Due on Receipt'];
  final List<String> _statusOptions = ['draft', 'sent', 'paid', 'overdue', 'cancelled'];
  
  final List<String> _clients = [
    'Green Valley Restaurant',
    'Tech Solutions Inc.',
    'Downtown Office Building',
    'Corporate Headquarters',
    'Community Center',
    'Shopping Mall Plaza',
    'Hotel Chain Management',
    'Manufacturing Facility',
  ];

  final List<Map<String, dynamic>> _serviceTemplates = [
    {
      'name': 'Pest Control Service',
      'description': 'Quarterly pest control treatment',
      'rate': 150.00,
      'unit': 'service',
    },
    {
      'name': 'HVAC Maintenance',
      'description': 'Regular HVAC system maintenance',
      'rate': 200.00,
      'unit': 'hour',
    },
    {
      'name': 'Electrical Work',
      'description': 'Electrical repair and installation',
      'rate': 85.00,
      'unit': 'hour',
    },
    {
      'name': 'Plumbing Service',
      'description': 'Plumbing repair and maintenance',
      'rate': 95.00,
      'unit': 'hour',
    },
    {
      'name': 'Equipment Rental',
      'description': 'Professional equipment rental',
      'rate': 50.00,
      'unit': 'day',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInvoiceData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _invoiceNumberController.dispose();
    _clientController.dispose();
    _jobReferenceController.dispose();
    _notesController.dispose();
    _termsController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _loadInvoiceData() {
    if (widget.invoice != null) {
      final invoice = widget.invoice!;
      _invoiceNumberController.text = invoice['id'] ?? '';
      _selectedClient = invoice['client'] ?? '';
      _jobReferenceController.text = invoice['jobReference'] ?? '';
      _status = invoice['status'] ?? 'draft';
      _notesController.text = invoice['notes'] ?? '';
      // Load other fields...
    } else {
      // Generate new invoice number
      _invoiceNumberController.text = 'INV-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    }
    
    // Load default terms
    _termsController.text = 'Payment is due within 30 days of invoice date. Late payments may incur additional charges.';
  }

  double get _subtotal {
    return _lineItems.fold(0.0, (sum, item) => sum + (item['total'] ?? 0.0));
  }

  double get _taxAmount {
    return (_subtotal - _discountAmount) * (_taxRate / 100);
  }

  double get _total {
    return _subtotal - _discountAmount + _taxAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.invoice == null ? 'Create Invoice' : 'Edit Invoice'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Details', icon: Icon(Icons.info)),
            Tab(text: 'Line Items', icon: Icon(Icons.list)),
            Tab(text: 'Summary', icon: Icon(Icons.summarize)),
          ],
        ),
        actions: [
          if (_currentStep > 0)
            TextButton(
              onPressed: _previousStep,
              child: const Text('Previous'),
            ),
          TextButton(
            onPressed: _isLoading ? null : _saveInvoice,
            child: _isLoading 
              ? const SizedBox(
                  width: 20, 
                  height: 20, 
                  child: CircularProgressIndicator(strokeWidth: 2)
                )
              : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildDetailsTab(),
            _buildLineItemsTab(),
            _buildSummaryTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '\$${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF14B8A6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _previewInvoice,
              icon: const Icon(Icons.preview),
              label: const Text('Preview'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveAndSendInvoice,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF14B8A6),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save & Send'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Invoice Number and Status
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _invoiceNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Invoice Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.receipt),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter invoice number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.flag),
                  ),
                  items: _statusOptions.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Client Selection
          DropdownButtonFormField<String>(
            value: _selectedClient.isEmpty ? null : _selectedClient,
            decoration: const InputDecoration(
              labelText: 'Client',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.business),
            ),
            items: _clients.map((client) {
              return DropdownMenuItem(
                value: client,
                child: Text(client),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedClient = value!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a client';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Job Reference
          TextFormField(
            controller: _jobReferenceController,
            decoration: const InputDecoration(
              labelText: 'Job Reference (Optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.work),
              hintText: 'Link to specific job or project',
            ),
          ),
          const SizedBox(height: 16),

          // Dates
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, true),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Invoice Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(DateFormat('MMM dd, yyyy').format(_invoiceDate)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, false),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Due Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event),
                    ),
                    child: Text(DateFormat('MMM dd, yyyy').format(_dueDate)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Payment Terms
          DropdownButtonFormField<String>(
            value: _paymentTerms,
            decoration: const InputDecoration(
              labelText: 'Payment Terms',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.payment),
            ),
            items: _paymentTermsOptions.map((terms) {
              return DropdownMenuItem(
                value: terms,
                child: Text(terms == 'Due on Receipt' ? terms : '$terms days'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _paymentTerms = value!;
                if (value != 'Due on Receipt') {
                  _dueDate = _invoiceDate.add(Duration(days: int.parse(value)));
                }
              });
            },
          ),
          const SizedBox(height: 16),

          // Notes
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes (Optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.note),
              hintText: 'Additional notes or special instructions...',
            ),
          ),
          const SizedBox(height: 16),

          // Terms and Conditions
          TextFormField(
            controller: _termsController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Terms and Conditions',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.gavel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineItemsTab() {
    return Column(
      children: [
        // Add Item Button
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _addLineItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Line Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _addFromTemplate,
                icon: const Icon(Icons.add),
                label: const Text('Template'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                ),
              ),
            ],
          ),
        ),

        // Line Items List
        Expanded(
          child: _lineItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No line items added',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add services, products, or hours to your invoice',
                      style: TextStyle(color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _lineItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return _buildLineItemCard(index);
                },
              ),
        ),

        // Subtotal Section
        if (_lineItems.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:', style: TextStyle(fontSize: 16)),
                    Text('\$${_subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _discountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Discount',
                          border: const OutlineInputBorder(),
                          suffixIcon: DropdownButton<String>(
                            value: _discountType,
                            underline: Container(),
                            items: const [
                              DropdownMenuItem(value: 'amount', child: Text('\$')),
                              DropdownMenuItem(value: 'percentage', child: Text('%')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _discountType = value!;
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _discountAmount = double.tryParse(value) ?? 0.0;
                            if (_discountType == 'percentage') {
                              _discountAmount = _subtotal * (_discountAmount / 100);
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: _taxRate.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tax Rate (%)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _taxRate = double.tryParse(value) ?? 0.0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLineItemCard(int index) {
    final item = _lineItems[index];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    item['description'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${item['quantity']} ${item['unit']}',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    '\$${item['rate'].toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    '\$${item['total'].toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (action) => _handleLineItemAction(action, index),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            if (item['notes'] != null && item['notes'].isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item['notes'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Invoice Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'INVOICE',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF14B8A6),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(_status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _status.toUpperCase(),
                          style: TextStyle(
                            color: _getStatusColor(_status),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Invoice #: ${_invoiceNumberController.text}'),
                  Text('Date: ${DateFormat('MMM dd, yyyy').format(_invoiceDate)}'),
                  Text('Due: ${DateFormat('MMM dd, yyyy').format(_dueDate)}'),
                  if (_jobReferenceController.text.isNotEmpty)
                    Text('Job Reference: ${_jobReferenceController.text}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Client Information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bill To:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_selectedClient.isEmpty ? 'No client selected' : _selectedClient),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Line Items Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Services & Products:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (_lineItems.isEmpty)
                    const Text('No line items added')
                  else
                    ..._lineItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(item['description'] ?? ''),
                            ),
                            Expanded(
                              child: Text(
                                '${item['quantity']} ${item['unit']}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '\$${item['rate'].toStringAsFixed(2)}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '\$${item['total'].toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Totals Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:'),
                      Text('\$${_subtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                  if (_discountAmount > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discount:'),
                        Text('-\$${_discountAmount.toStringAsFixed(2)}'),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax ($_taxRate%):'),
                      Text('\$${_taxAmount.toStringAsFixed(2)}'),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${_total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF14B8A6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          if (_notesController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_notesController.text),
                  ],
                ),
              ),
            ),
          ],

          if (_termsController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Terms and Conditions:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_termsController.text),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'draft': return Colors.grey;
      case 'sent': return Colors.blue;
      case 'paid': return Colors.green;
      case 'overdue': return Colors.red;
      case 'cancelled': return Colors.orange;
      default: return Colors.grey;
    }
  }

  Future<void> _selectDate(BuildContext context, bool isInvoiceDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isInvoiceDate ? _invoiceDate : _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null) {
      setState(() {
        if (isInvoiceDate) {
          _invoiceDate = picked;
          // Auto-update due date based on payment terms
          if (_paymentTerms != 'Due on Receipt') {
            _dueDate = picked.add(Duration(days: int.parse(_paymentTerms)));
          }
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  void _addLineItem() {
    _showLineItemDialog();
  }

  void _addFromTemplate() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Service Template'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _serviceTemplates.length,
            itemBuilder: (context, index) {
              final template = _serviceTemplates[index];
              return ListTile(
                title: Text(template['name']),
                subtitle: Text('\$${template['rate']} per ${template['unit']}'),
                onTap: () {
                  Navigator.pop(context);
                  _addLineItemFromTemplate(template);
                },
              );
            },
          ),
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

  void _addLineItemFromTemplate(Map<String, dynamic> template) {
    setState(() {
      _lineItems.add({
        'description': template['description'],
        'quantity': 1.0,
        'unit': template['unit'],
        'rate': template['rate'],
        'total': template['rate'],
        'notes': '',
      });
    });
  }

  void _showLineItemDialog({int? editIndex}) {
    final isEdit = editIndex != null;
    final item = isEdit ? _lineItems[editIndex] : null;
    
    final descriptionController = TextEditingController(text: item?['description'] ?? '');
    final quantityController = TextEditingController(text: (item?['quantity'] ?? 1.0).toString());
    final unitController = TextEditingController(text: item?['unit'] ?? 'hour');
    final rateController = TextEditingController(text: (item?['rate'] ?? 0.0).toString());
    final notesController = TextEditingController(text: item?['notes'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Line Item' : 'Add Line Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: rateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rate',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity = double.tryParse(quantityController.text) ?? 1.0;
              final rate = double.tryParse(rateController.text) ?? 0.0;
              final total = quantity * rate;

              final newItem = {
                'description': descriptionController.text,
                'quantity': quantity,
                'unit': unitController.text,
                'rate': rate,
                'total': total,
                'notes': notesController.text,
              };

              setState(() {
                if (isEdit) {
                  _lineItems[editIndex] = newItem;
                } else {
                  _lineItems.add(newItem);
                }
              });

              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _handleLineItemAction(String action, int index) {
    switch (action) {
      case 'edit':
        _showLineItemDialog(editIndex: index);
        break;
      case 'duplicate':
        setState(() {
          _lineItems.add(Map<String, dynamic>.from(_lineItems[index]));
        });
        break;
      case 'delete':
        setState(() {
          _lineItems.removeAt(index);
        });
        break;
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _tabController.animateTo(_currentStep);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _tabController.animateTo(_currentStep);
    }
  }

  Future<void> _saveInvoice() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClient.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a client')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invoice saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving invoice: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveAndSendInvoice() async {
    await _saveInvoice();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice sent to client!')),
      );
    }
  }

  void _previewInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invoice preview coming soon')),
    );
  }
} 