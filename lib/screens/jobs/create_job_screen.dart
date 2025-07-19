import 'package:flutter/material.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  // Form controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _estimatedDurationController = TextEditingController();
  final TextEditingController _revenueController = TextEditingController();
  
  // Form data
  String? _selectedClient;
  String? _selectedServiceType;
  String _selectedPriority = 'medium';
  String? _selectedAssignee;
  DateTime? _scheduledDate;
  TimeOfDay? _scheduledTime;
  List<String> _selectedTags = [];
  List<Map<String, dynamic>> _materials = [];

  final List<String> _clients = [
    'Office Complex A',
    'Community Center',
    'Residential Building',
    'New Construction',
    'Corporate Headquarters',
    'Shopping Mall',
    'Hotel Chain',
    'Restaurant Group',
  ];

  final List<String> _serviceTypes = [
    'Pest Control',
    'HVAC Maintenance',
    'Plumbing',
    'Electrical',
    'Landscaping',
    'Cleaning',
    'Security',
    'General Maintenance',
  ];

  final List<String> _priorities = ['low', 'medium', 'high', 'urgent'];

  final List<String> _assignees = [
    'Maya Chen',
    'Ravi Patel',
    'Arjun Singh',
    'Sarah Wilson',
    'David Kim',
    'Lisa Rodriguez',
  ];

  final List<String> _availableTags = [
    'emergency', 'routine', 'quarterly', 'annual',
    'commercial', 'residential', 'inspection',
    'repair', 'maintenance', 'installation'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    _estimatedDurationController.dispose();
    _revenueController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Job'),
        actions: [
          TextButton(
            onPressed: _currentStep < 3 ? null : _saveJob,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                _buildBasicInfoStep(),
                _buildClientLocationStep(),
                _buildSchedulingStep(),
                _buildMaterialsReviewStep(),
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;
          
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF14B8A6) : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                if (index < 3)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index < _currentStep ? const Color(0xFF14B8A6) : Colors.grey[300],
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Job Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Job Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Job Title *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a job title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Service Type
            DropdownButtonFormField<String>(
              value: _selectedServiceType,
              decoration: const InputDecoration(
                labelText: 'Service Type *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.build),
              ),
              items: _serviceTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedServiceType = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a service type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Priority
            const Text('Priority *', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _priorities.map((priority) {
                final isSelected = _selectedPriority == priority;
                return FilterChip(
                  label: Text(priority.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: _getPriorityColor(priority).withOpacity(0.2),
                  checkmarkColor: _getPriorityColor(priority),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Special Notes
            TextFormField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Special Notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            
            // Tags
            const Text('Tags', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientLocationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Client & Location',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          // Client Selection
          DropdownButtonFormField<String>(
            value: _selectedClient,
            decoration: const InputDecoration(
              labelText: 'Client *',
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
                _selectedClient = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a client';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Location
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Job Location *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
              suffixIcon: Icon(Icons.my_location),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the job location';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Assignee
          DropdownButtonFormField<String>(
            value: _selectedAssignee,
            decoration: const InputDecoration(
              labelText: 'Assign to Technician *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            items: _assignees.map((assignee) {
              return DropdownMenuItem(
                value: assignee,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color(0xFF14B8A6),
                      child: Text(
                        assignee.split(' ').map((n) => n[0]).join(''),
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(assignee),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedAssignee = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please assign a technician';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          
          // Contact Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.contacts, color: Color(0xFF14B8A6)),
                      const SizedBox(width: 8),
                      Text(
                        'Contact Information',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Contact Person',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulingStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scheduling & Pricing',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          // Date Selection
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today, color: Color(0xFF14B8A6)),
              title: const Text('Scheduled Date *'),
              subtitle: Text(_scheduledDate != null 
                  ? '${_scheduledDate!.day}/${_scheduledDate!.month}/${_scheduledDate!.year}'
                  : 'Select date'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _scheduledDate = date;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          
          // Time Selection
          Card(
            child: ListTile(
              leading: const Icon(Icons.access_time, color: Color(0xFF14B8A6)),
              title: const Text('Scheduled Time *'),
              subtitle: Text(_scheduledTime != null 
                  ? _scheduledTime!.format(context)
                  : 'Select time'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    _scheduledTime = time;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          
          // Duration
          TextFormField(
            controller: _estimatedDurationController,
            decoration: const InputDecoration(
              labelText: 'Estimated Duration *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.timer),
              suffixText: 'hours',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter estimated duration';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Revenue
          TextFormField(
            controller: _revenueController,
            decoration: const InputDecoration(
              labelText: 'Expected Revenue *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
              prefixText: '\$',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter expected revenue';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          
          // Recurrence Options
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recurring Job',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Make this a recurring job'),
                    value: false,
                    onChanged: (value) {
                      // Handle recurring job logic
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Materials & Review',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          // Materials Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Required Materials',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: _addMaterial,
                icon: const Icon(Icons.add),
                label: const Text('Add Material'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (_materials.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.inventory_2_outlined, 
                         size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      'No materials added yet',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _addMaterial,
                      icon: const Icon(Icons.add),
                      label: const Text('Add First Material'),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _materials.length,
              itemBuilder: (context, index) {
                final material = _materials[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF14B8A6),
                      child: Icon(Icons.inventory, color: Colors.white),
                    ),
                    title: Text(material['name']),
                    subtitle: Text('Qty: ${material['quantity']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${material['cost'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeMaterial(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          
          const SizedBox(height: 24),
          
          // Job Summary
          Card(
            color: Colors.blue.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Job Summary',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Title', _titleController.text),
                  _buildSummaryRow('Service Type', _selectedServiceType ?? ''),
                  _buildSummaryRow('Client', _selectedClient ?? ''),
                  _buildSummaryRow('Assignee', _selectedAssignee ?? ''),
                  _buildSummaryRow('Priority', _selectedPriority.toUpperCase()),
                  _buildSummaryRow('Date', _scheduledDate != null 
                      ? '${_scheduledDate!.day}/${_scheduledDate!.month}/${_scheduledDate!.year}'
                      : ''),
                  _buildSummaryRow('Time', _scheduledTime?.format(context) ?? ''),
                  _buildSummaryRow('Duration', '${_estimatedDurationController.text} hours'),
                  _buildSummaryRow('Revenue', '\$${_revenueController.text}'),
                  if (_selectedTags.isNotEmpty)
                    _buildSummaryRow('Tags', _selectedTags.join(', ')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not set' : value,
              style: TextStyle(
                color: value.isEmpty ? Colors.red[400] : Colors.grey[800],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Previous'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep < 3 ? _nextStep : _saveJob,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF14B8A6),
                foregroundColor: Colors.white,
              ),
              child: Text(_currentStep < 3 ? 'Next' : 'Create Job'),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < 3) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (!_formKey.currentState!.validate()) return false;
        if (_selectedServiceType == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a service type')),
          );
          return false;
        }
        break;
      case 1:
        if (_selectedClient == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a client')),
          );
          return false;
        }
        if (_locationController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter job location')),
          );
          return false;
        }
        if (_selectedAssignee == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please assign a technician')),
          );
          return false;
        }
        break;
      case 2:
        if (_scheduledDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a date')),
          );
          return false;
        }
        if (_scheduledTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a time')),
          );
          return false;
        }
        if (_estimatedDurationController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter estimated duration')),
          );
          return false;
        }
        if (_revenueController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter expected revenue')),
          );
          return false;
        }
        break;
    }
    return true;
  }

  void _addMaterial() {
    showDialog(
      context: context,
      builder: (context) => _MaterialDialog(
        onSave: (material) {
          setState(() {
            _materials.add(material);
          });
        },
      ),
    );
  }

  void _removeMaterial(int index) {
    setState(() {
      _materials.removeAt(index);
    });
  }

  void _saveJob() {
    if (_validateCurrentStep()) {
      // Create job object
      final job = {
        'title': _titleController.text,
        'serviceType': _selectedServiceType,
        'priority': _selectedPriority,
        'description': _descriptionController.text,
        'notes': _notesController.text,
        'client': _selectedClient,
        'location': _locationController.text,
        'assignee': _selectedAssignee,
        'scheduledDate': _scheduledDate,
        'scheduledTime': _scheduledTime,
        'estimatedDuration': _estimatedDurationController.text,
        'revenue': double.tryParse(_revenueController.text) ?? 0.0,
        'tags': _selectedTags,
        'materials': _materials,
        'status': 'scheduled',
        'createdAt': DateTime.now(),
      };

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.of(context).pop(job);
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

class _MaterialDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const _MaterialDialog({required this.onSave});

  @override
  State<_MaterialDialog> createState() => _MaterialDialogState();
}

class _MaterialDialogState extends State<_MaterialDialog> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Material'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Material Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _costController,
            decoration: const InputDecoration(
              labelText: 'Cost',
              border: OutlineInputBorder(),
              prefixText: '\$',
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
            if (_nameController.text.isNotEmpty &&
                _quantityController.text.isNotEmpty &&
                _costController.text.isNotEmpty) {
              widget.onSave({
                'name': _nameController.text,
                'quantity': _quantityController.text,
                'cost': double.tryParse(_costController.text) ?? 0.0,
              });
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
} 