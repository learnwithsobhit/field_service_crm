import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // General notification settings
  bool _enableAllNotifications = true;
  bool _enablePushNotifications = true;
  bool _enableEmailNotifications = true;
  bool _enableSmsNotifications = false;
  
  // Job-related notifications
  bool _newJobAssignments = true;
  bool _jobUpdates = true;
  bool _jobDeadlineReminders = true;
  bool _jobCompletionConfirmations = true;
  bool _jobCancellations = true;
  bool _emergencyJobs = true;
  
  // Communication notifications
  bool _teamMessages = true;
  bool _directMessages = true;
  bool _groupCalls = true;
  bool _emergencyAlerts = true;
  bool _systemAnnouncements = true;
  
  // Inventory notifications
  bool _lowStockAlerts = true;
  bool _stockReplenishment = false;
  bool _inventoryUpdates = false;
  bool _equipmentMaintenance = true;
  
  // Financial notifications
  bool _invoiceUpdates = true;
  bool _paymentReceived = true;
  bool _overduePayments = true;
  bool _expenseApprovals = false;
  
  // Schedule notifications
  bool _scheduleChanges = true;
  bool _upcomingAppointments = true;
  bool _shiftReminders = true;
  bool _timeOffRequests = false;
  
  // Quiet hours
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);
  bool _enableQuietHours = true;
  List<String> _quietDays = [];
  
  final List<String> _weekDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Settings
            _buildSectionHeader('General Settings'),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable All Notifications'),
                    subtitle: const Text('Master switch for all notifications'),
                    value: _enableAllNotifications,
                    onChanged: (value) {
                      setState(() {
                        _enableAllNotifications = value;
                        if (!value) {
                          _disableAllNotifications();
                        }
                      });
                    },
                    activeColor: const Color(0xFF14B8A6),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Receive notifications on device'),
                    value: _enablePushNotifications && _enableAllNotifications,
                    onChanged: _enableAllNotifications ? (value) {
                      setState(() {
                        _enablePushNotifications = value;
                      });
                    } : null,
                    activeColor: const Color(0xFF14B8A6),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Email Notifications'),
                    subtitle: const Text('Receive notifications via email'),
                    value: _enableEmailNotifications && _enableAllNotifications,
                    onChanged: _enableAllNotifications ? (value) {
                      setState(() {
                        _enableEmailNotifications = value;
                      });
                    } : null,
                    activeColor: const Color(0xFF14B8A6),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('SMS Notifications'),
                    subtitle: const Text('Receive notifications via text message'),
                    value: _enableSmsNotifications && _enableAllNotifications,
                    onChanged: _enableAllNotifications ? (value) {
                      setState(() {
                        _enableSmsNotifications = value;
                      });
                    } : null,
                    activeColor: const Color(0xFF14B8A6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Job Notifications
            _buildSectionHeader('Job Notifications'),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _buildNotificationTile(
                    'New Job Assignments',
                    'When you are assigned to a new job',
                    _newJobAssignments,
                    (value) => setState(() => _newJobAssignments = value),
                  ),
                  _buildNotificationTile(
                    'Job Updates',
                    'When job details or status changes',
                    _jobUpdates,
                    (value) => setState(() => _jobUpdates = value),
                  ),
                  _buildNotificationTile(
                    'Deadline Reminders',
                    'Reminders for upcoming job deadlines',
                    _jobDeadlineReminders,
                    (value) => setState(() => _jobDeadlineReminders = value),
                  ),
                  _buildNotificationTile(
                    'Completion Confirmations',
                    'When jobs are marked as completed',
                    _jobCompletionConfirmations,
                    (value) => setState(() => _jobCompletionConfirmations = value),
                  ),
                  _buildNotificationTile(
                    'Job Cancellations',
                    'When jobs are cancelled or postponed',
                    _jobCancellations,
                    (value) => setState(() => _jobCancellations = value),
                  ),
                  _buildNotificationTile(
                    'Emergency Jobs',
                    'Urgent job assignments requiring immediate attention',
                    _emergencyJobs,
                    (value) => setState(() => _emergencyJobs = value),
                    isImportant: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Communication Notifications
            _buildSectionHeader('Communication'),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _buildNotificationTile(
                    'Team Messages',
                    'Messages in team chat channels',
                    _teamMessages,
                    (value) => setState(() => _teamMessages = value),
                  ),
                  _buildNotificationTile(
                    'Direct Messages',
                    'Private messages from colleagues',
                    _directMessages,
                    (value) => setState(() => _directMessages = value),
                  ),
                  _buildNotificationTile(
                    'Group Calls',
                    'Incoming group call invitations',
                    _groupCalls,
                    (value) => setState(() => _groupCalls = value),
                  ),
                  _buildNotificationTile(
                    'Emergency Alerts',
                    'Critical emergency communications',
                    _emergencyAlerts,
                    (value) => setState(() => _emergencyAlerts = value),
                    isImportant: true,
                  ),
                  _buildNotificationTile(
                    'System Announcements',
                    'Important company-wide announcements',
                    _systemAnnouncements,
                    (value) => setState(() => _systemAnnouncements = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Inventory Notifications
            _buildSectionHeader('Inventory & Equipment'),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _buildNotificationTile(
                    'Low Stock Alerts',
                    'When inventory items are running low',
                    _lowStockAlerts,
                    (value) => setState(() => _lowStockAlerts = value),
                  ),
                  _buildNotificationTile(
                    'Stock Replenishment',
                    'When inventory is restocked',
                    _stockReplenishment,
                    (value) => setState(() => _stockReplenishment = value),
                  ),
                  _buildNotificationTile(
                    'Inventory Updates',
                    'General inventory changes and updates',
                    _inventoryUpdates,
                    (value) => setState(() => _inventoryUpdates = value),
                  ),
                  _buildNotificationTile(
                    'Equipment Maintenance',
                    'Equipment maintenance reminders and schedules',
                    _equipmentMaintenance,
                    (value) => setState(() => _equipmentMaintenance = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Financial Notifications
            _buildSectionHeader('Financial'),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _buildNotificationTile(
                    'Invoice Updates',
                    'Invoice generation and status changes',
                    _invoiceUpdates,
                    (value) => setState(() => _invoiceUpdates = value),
                  ),
                  _buildNotificationTile(
                    'Payment Received',
                    'When payments are received from clients',
                    _paymentReceived,
                    (value) => setState(() => _paymentReceived = value),
                  ),
                  _buildNotificationTile(
                    'Overdue Payments',
                    'Alerts for overdue payment reminders',
                    _overduePayments,
                    (value) => setState(() => _overduePayments = value),
                  ),
                  _buildNotificationTile(
                    'Expense Approvals',
                    'Expense report approval notifications',
                    _expenseApprovals,
                    (value) => setState(() => _expenseApprovals = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Schedule Notifications
            _buildSectionHeader('Schedule & Time'),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _buildNotificationTile(
                    'Schedule Changes',
                    'Changes to your work schedule',
                    _scheduleChanges,
                    (value) => setState(() => _scheduleChanges = value),
                  ),
                  _buildNotificationTile(
                    'Upcoming Appointments',
                    'Reminders for upcoming appointments',
                    _upcomingAppointments,
                    (value) => setState(() => _upcomingAppointments = value),
                  ),
                  _buildNotificationTile(
                    'Shift Reminders',
                    'Start and end of shift notifications',
                    _shiftReminders,
                    (value) => setState(() => _shiftReminders = value),
                  ),
                  _buildNotificationTile(
                    'Time Off Requests',
                    'Updates on time off request status',
                    _timeOffRequests,
                    (value) => setState(() => _timeOffRequests = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quiet Hours
            _buildSectionHeader('Quiet Hours'),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable Quiet Hours'),
                    subtitle: const Text('Disable non-critical notifications during set hours'),
                    value: _enableQuietHours,
                    onChanged: (value) {
                      setState(() {
                        _enableQuietHours = value;
                      });
                    },
                    activeColor: const Color(0xFF14B8A6),
                  ),
                  if (_enableQuietHours) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.bedtime),
                      title: const Text('Start Time'),
                      subtitle: Text(_quietHoursStart.format(context)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _selectTime(context, true),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.light_mode),
                      title: const Text('End Time'),
                      subtitle: Text(_quietHoursEnd.format(context)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _selectTime(context, false),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Quiet Days'),
                      subtitle: Text(_quietDays.isEmpty ? 'None selected' : _quietDays.join(', ')),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: _selectQuietDays,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Reset and Save buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetToDefaults,
                    child: const Text('Reset to Defaults'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF14B8A6),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save Settings'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF14B8A6),
      ),
    );
  }

  Widget _buildNotificationTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    bool isImportant = false,
  }) {
    return Column(
      children: [
        SwitchListTile(
          title: Row(
            children: [
              Expanded(child: Text(title)),
              if (isImportant)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Critical',
                    style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          subtitle: Text(subtitle),
          value: value && _enableAllNotifications,
          onChanged: _enableAllNotifications ? onChanged : null,
          activeColor: isImportant ? Colors.red : const Color(0xFF14B8A6),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _quietHoursStart : _quietHoursEnd,
    );
    
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _quietHoursStart = picked;
        } else {
          _quietHoursEnd = picked;
        }
      });
    }
  }

  void _selectQuietDays() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Quiet Days'),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: _weekDays.map((day) {
                return CheckboxListTile(
                  title: Text(day),
                  value: _quietDays.contains(day),
                  onChanged: (value) {
                    setDialogState(() {
                      if (value == true) {
                        _quietDays.add(day);
                      } else {
                        _quietDays.remove(day);
                      }
                    });
                  },
                  activeColor: const Color(0xFF14B8A6),
                );
              }).toList(),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _disableAllNotifications() {
    _enablePushNotifications = false;
    _enableEmailNotifications = false;
    _enableSmsNotifications = false;
    _newJobAssignments = false;
    _jobUpdates = false;
    _jobDeadlineReminders = false;
    _jobCompletionConfirmations = false;
    _jobCancellations = false;
    _emergencyJobs = false;
    _teamMessages = false;
    _directMessages = false;
    _groupCalls = false;
    _emergencyAlerts = false;
    _systemAnnouncements = false;
    _lowStockAlerts = false;
    _stockReplenishment = false;
    _inventoryUpdates = false;
    _equipmentMaintenance = false;
    _invoiceUpdates = false;
    _paymentReceived = false;
    _overduePayments = false;
    _expenseApprovals = false;
    _scheduleChanges = false;
    _upcomingAppointments = false;
    _shiftReminders = false;
    _timeOffRequests = false;
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text('This will reset all notification settings to their default values. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _enableAllNotifications = true;
                _enablePushNotifications = true;
                _enableEmailNotifications = true;
                _enableSmsNotifications = false;
                _newJobAssignments = true;
                _jobUpdates = true;
                _jobDeadlineReminders = true;
                _jobCompletionConfirmations = true;
                _jobCancellations = true;
                _emergencyJobs = true;
                _teamMessages = true;
                _directMessages = true;
                _groupCalls = true;
                _emergencyAlerts = true;
                _systemAnnouncements = true;
                _lowStockAlerts = true;
                _stockReplenishment = false;
                _inventoryUpdates = false;
                _equipmentMaintenance = true;
                _invoiceUpdates = true;
                _paymentReceived = true;
                _overduePayments = true;
                _expenseApprovals = false;
                _scheduleChanges = true;
                _upcomingAppointments = true;
                _shiftReminders = true;
                _timeOffRequests = false;
                _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
                _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);
                _enableQuietHours = true;
                _quietDays = [];
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }
} 