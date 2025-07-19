import 'package:flutter/material.dart';
import 'payment_processing_screen.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late Map<String, dynamic> _invoice;

  @override
  void initState() {
    super.initState();
    _invoice = Map<String, dynamic>.from(widget.invoice);
  }

  Color get _statusColor {
    switch (_invoice['status']) {
      case 'paid':
        return Colors.green;
      case 'pending':
      case 'sent':
        return Colors.blue;
      case 'overdue':
        return Colors.red;
      case 'draft':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData get _statusIcon {
    switch (_invoice['status']) {
      case 'paid':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'sent':
        return Icons.send;
      case 'overdue':
        return Icons.warning;
      case 'draft':
        return Icons.drafts;
      default:
        return Icons.receipt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPaid = _invoice['status'] == 'paid';
    final bool isDraft = _invoice['status'] == 'draft';
    final bool isOverdue = _invoice['status'] == 'overdue';

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice ${_invoice['id']}'),
        actions: [
          if (!isDraft)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareInvoice,
            ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadInvoice,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              if (isDraft) const PopupMenuItem(value: 'edit', child: Text('Edit Invoice')),
              if (isDraft) const PopupMenuItem(value: 'send', child: Text('Send Invoice')),
              if (!isPaid && !isDraft) const PopupMenuItem(value: 'payment', child: Text('Record Payment')),
              if (isOverdue) const PopupMenuItem(value: 'reminder', child: Text('Send Reminder')),
              const PopupMenuItem(value: 'duplicate', child: Text('Duplicate Invoice')),
              if (!isPaid) const PopupMenuItem(value: 'void', child: Text('Void Invoice')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            if (isOverdue)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This invoice is overdue. Payment was due ${_formatDate(_invoice['dueDate'])}.',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Invoice Header
            _buildInvoiceHeader(),
            const SizedBox(height: 24),

            // Client Information
            _buildClientInformation(),
            const SizedBox(height: 24),

            // Job Information
            _buildJobInformation(),
            const SizedBox(height: 24),

            // Invoice Items
            _buildInvoiceItems(),
            const SizedBox(height: 24),

            // Payment Information
            if (isPaid) ...[
              _buildPaymentInformation(),
              const SizedBox(height: 24),
            ],

            // Notes
            if (_invoice['notes'] != null && _invoice['notes'].isNotEmpty) ...[
              _buildNotes(),
              const SizedBox(height: 24),
            ],

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice ${_invoice['id']}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_statusIcon, color: _statusColor, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            _invoice['status'].toString().toUpperCase(),
                            style: TextStyle(
                              color: _statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${_invoice['totalAmount'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _statusColor,
                      ),
                    ),
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDateInfo(
                    'Issue Date',
                    _formatDate(_invoice['issuedDate']),
                    Icons.calendar_today,
                  ),
                ),
                Expanded(
                  child: _buildDateInfo(
                    'Due Date',
                    _formatDate(_invoice['dueDate']),
                    Icons.event,
                  ),
                ),
                if (_invoice['paidDate'] != null)
                  Expanded(
                    child: _buildDateInfo(
                      'Paid Date',
                      _formatDate(_invoice['paidDate']),
                      Icons.check_circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, String date, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildClientInformation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.business, color: Color(0xFF14B8A6)),
                const SizedBox(width: 8),
                const Text(
                  'Bill To',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _invoice['clientName'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (_invoice['clientEmail'] != null) ...[
              Row(
                children: [
                  Icon(Icons.email, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    _invoice['clientEmail'],
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            if (_invoice['clientPhone'] != null) ...[
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    _invoice['clientPhone'],
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildJobInformation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.work, color: Color(0xFF14B8A6)),
                const SizedBox(width: 8),
                const Text(
                  'Service Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _invoice['jobTitle'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.confirmation_number, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Job ID: ${_invoice['jobId']}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceItems() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.list_alt, color: Color(0xFF14B8A6)),
                const SizedBox(width: 8),
                const Text(
                  'Invoice Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Items Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Expanded(flex: 3, child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text('Rate', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                  Expanded(flex: 1, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            
            // Items List
            ...(_invoice['items'] as List<Map<String, dynamic>>).map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        item['description'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item['quantity']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '\$${item['rate'].toStringAsFixed(2)}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '\$${item['amount'].toStringAsFixed(2)}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            const SizedBox(height: 16),
            const Divider(),
            
            // Totals
            _buildTotalRow('Subtotal:', '\$${_invoice['amount'].toStringAsFixed(2)}'),
            _buildTotalRow('Tax:', '\$${_invoice['taxAmount'].toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildTotalRow(
              'Total:',
              '\$${_invoice['totalAmount'].toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? const Color(0xFF14B8A6) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInformation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.payment, color: Colors.green[600]),
                const SizedBox(width: 8),
                const Text(
                  'Payment Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Method',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _invoice['paymentMethod'] ?? 'Not specified',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount Paid',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${_invoice['totalAmount'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.note, color: Color(0xFF14B8A6)),
                const SizedBox(width: 8),
                const Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _invoice['notes'],
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final bool isPaid = _invoice['status'] == 'paid';
    final bool isDraft = _invoice['status'] == 'draft';
    final bool isOverdue = _invoice['status'] == 'overdue';

    return Column(
      children: [
        if (isDraft) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _sendInvoice,
              icon: const Icon(Icons.send),
              label: const Text('Send Invoice'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF14B8A6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _editInvoice,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _previewInvoice,
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
              ),
            ],
          ),
        ] else if (!isPaid) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _processPayment,
              icon: const Icon(Icons.payment),
              label: const Text('Process Payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF14B8A6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (isOverdue) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _sendReminder,
                icon: const Icon(Icons.notifications),
                label: const Text('Send Payment Reminder'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                ),
              ),
            ),
          ],
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _downloadInvoice,
                icon: const Icon(Icons.download),
                label: const Text('Download PDF'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _shareInvoice,
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper methods
  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.day}/${date.month}/${date.year}';
  }

  // Action handlers
  void _handleMenuAction(String action) {
    switch (action) {
      case 'edit':
        _editInvoice();
        break;
      case 'send':
        _sendInvoice();
        break;
      case 'payment':
        _recordPayment();
        break;
      case 'reminder':
        _sendReminder();
        break;
      case 'duplicate':
        _duplicateInvoice();
        break;
      case 'void':
        _voidInvoice();
        break;
    }
  }

  void _editInvoice() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateInvoiceScreen(invoice: _invoice),
      ),
    );
  }

  void _sendInvoice() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Invoice'),
        content: Text('Send invoice ${_invoice['id']} to ${_invoice['clientName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _invoice['status'] = 'sent';
                _invoice['issuedDate'] = DateTime.now();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invoice ${_invoice['id']} sent successfully')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _processPayment() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentProcessingScreen(invoice: _invoice),
      ),
    );
  }

  void _recordPayment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Payment'),
        content: const Text('Mark this invoice as paid?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _invoice['status'] = 'paid';
                _invoice['paidDate'] = DateTime.now();
                _invoice['paymentMethod'] = 'Manual Entry';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment recorded successfully')),
              );
            },
            child: const Text('Record'),
          ),
        ],
      ),
    );
  }

  void _sendReminder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment reminder sent for ${_invoice['id']}')),
    );
  }

  void _duplicateInvoice() {
    final duplicateInvoice = Map<String, dynamic>.from(_invoice);
    duplicateInvoice['id'] = 'INV-${DateTime.now().millisecondsSinceEpoch}';
    duplicateInvoice['status'] = 'draft';
    duplicateInvoice['issuedDate'] = null;
    duplicateInvoice['paidDate'] = null;
    duplicateInvoice['paymentMethod'] = null;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateInvoiceScreen(invoice: duplicateInvoice),
      ),
    );
  }

  void _voidInvoice() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Void Invoice'),
        content: const Text('Are you sure you want to void this invoice? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invoice voided')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Void', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _previewInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invoice preview coming soon')),
    );
  }

  void _downloadInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${_invoice['id']}.pdf')),
    );
  }

  void _shareInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${_invoice['id']}')),
    );
  }
}

// Placeholder screens
class CreateInvoiceScreen extends StatelessWidget {
  final Map<String, dynamic>? invoice;

  const CreateInvoiceScreen({super.key, this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(invoice == null ? 'Create Invoice' : 'Edit Invoice'),
      ),
      body: const Center(
        child: Text('Create/Edit Invoice Screen - Implementation coming next!'),
      ),
    );
  }
} 