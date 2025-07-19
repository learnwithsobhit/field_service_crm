# Field Service CRM - Quick Reference Guide

## 🚀 Common Development Tasks

### 1. Creating a New Screen

```bash
# Create directory
mkdir -p lib/screens/feature_name

# Create screen file
touch lib/screens/feature_name/feature_screen.dart
```

**Template:**
```dart
import 'package:flutter/material.dart';

class FeatureScreen extends StatefulWidget {
  const FeatureScreen({super.key});

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Name'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewItem,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feature Overview',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Your content here
          ],
        ),
      ),
    );
  }

  void _addNewItem() {
    // Implementation
  }
}
```

### 2. Adding Navigation

**In main.dart:**
```dart
// Add import
import 'screens/feature_name/feature_screen.dart';

// Add to routes
routes: {
  '/feature': (context) => const FeatureScreen(),
}

// Add to dashboard
_buildQuickActionCard(
  context,
  'Feature Name',
  'Description',
  Icons.feature_icon,
  Colors.blue,
  () => Navigator.of(context).pushNamed('/feature'),
),
```

### 3. Creating Reusable Widgets

```dart
// lib/widgets/custom_widget.dart
import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? color;

  const CustomWidget({
    super.key,
    required this.title,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title),
              // More content
            ],
          ),
        ),
      ),
    );
  }
}
```

### 4. Common UI Patterns

#### Card with Header
```dart
Widget _buildSectionCard(String title, Widget content) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    ),
  );
}
```

#### Action Button
```dart
Widget _buildActionButton({
  required String label,
  required IconData icon,
  required VoidCallback onPressed,
  Color? color,
}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon),
    label: Text(label),
    style: ElevatedButton.styleFrom(
      backgroundColor: color ?? const Color(0xFF14B8A6),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
```

#### Loading State
```dart
Widget _buildContent() {
  if (_isLoading) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  
  return _buildActualContent();
}
```

#### Error State
```dart
Widget _buildContent() {
  if (_hasError) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $_errorMessage'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _retry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  return _buildActualContent();
}
```

### 5. Form Handling

```dart
class _FeatureFormState extends State<FeatureForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process form data
      final title = _titleController.text;
      final description = _descriptionController.text;
      
      // Submit to service
      _saveFeature(title, description);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
```

### 6. List Views

#### Simple List
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return ListTile(
      title: Text(item.title),
      subtitle: Text(item.description),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => _editItem(item),
      ),
    );
  },
)
```

#### Grid List
```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return Card(
      child: InkWell(
        onTap: () => _selectItem(item),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(item.icon, size: 48),
              const SizedBox(height: 8),
              Text(item.title),
            ],
          ),
        ),
      ),
    );
  },
)
```

### 7. Dialogs and Bottom Sheets

#### Alert Dialog
```dart
void _showConfirmDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Action'),
      content: const Text('Are you sure you want to proceed?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _performAction();
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}
```

#### Bottom Sheet
```dart
void _showBottomSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Your content here
          ],
        ),
      ),
    ),
  );
}
```

### 8. Date and Time Handling

```dart
import 'package:intl/intl.dart';

// Format date
final formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.now());

// Date picker
Future<DateTime?> _selectDate() async {
  return await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
  );
}

// Time picker
Future<TimeOfDay?> _selectTime() async {
  return await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
}
```

### 9. Color and Theme Usage

```dart
// Primary colors
const Color(0xFF14B8A6) // Teal 500
const Color(0xFF0F766E) // Teal 700

// Status colors
Colors.green   // Success
Colors.red     // Error
Colors.orange  // Warning
Colors.blue    // Info

// Text styles
Theme.of(context).textTheme.headlineLarge
Theme.of(context).textTheme.bodyMedium
Theme.of(context).textTheme.titleSmall

// Spacing
const SizedBox(height: 16)
const SizedBox(width: 16)
const EdgeInsets.all(16)
const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
```

### 10. Common Commands

```bash
# Run app
flutter run

# Hot reload
r

# Hot restart
R

# Build for release
flutter build apk --release
flutter build ios --release

# Clean and rebuild
flutter clean
flutter pub get

# Run tests
flutter test

# Format code
flutter format .

# Analyze code
flutter analyze
```

### 11. Debugging Tips

```dart
// Print debug info
print('Debug: $variable');

// Debug widget
debugPrint('Widget built');

// Check if widget is mounted
if (mounted) {
  setState(() {
    // Update state
  });
}

// Handle async errors
try {
  await riskyOperation();
} catch (e) {
  debugPrint('Error: $e');
  // Handle error
}
```

### 12. Performance Tips

```dart
// Use const constructors
const Text('Hello')

// Use ListView.builder for large lists
ListView.builder(
  itemCount: largeList.length,
  itemBuilder: (context, index) => ListTile(
    title: Text(largeList[index]),
  ),
)

// Use RepaintBoundary for complex widgets
RepaintBoundary(
  child: ComplexWidget(),
)

// Avoid unnecessary rebuilds
class OptimizedWidget extends StatelessWidget {
  const OptimizedWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      // Widget content
    );
  }
}
```

### 13. Common Widgets

#### Loading Widget
```dart
class LoadingWidget extends StatelessWidget {
  final String? message;
  
  const LoadingWidget({this.message, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!),
          ],
        ],
      ),
    );
  }
}
```

#### Empty State Widget
```dart
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;
  
  const EmptyStateWidget({
    super.key,
    required this.message,
    required this.icon,
    this.onAction,
    this.actionLabel,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
```

### 14. Error Handling

```dart
// Async error handling
Future<void> _loadData() async {
  try {
    setState(() => _isLoading = true);
    final data = await _service.getData();
    setState(() {
      _data = data;
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _error = e.toString();
      _isLoading = false;
    });
  }
}

// Form validation
String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}
```

This quick reference guide covers the most common development tasks and patterns used in the Field Service CRM app. Use it as a quick lookup when implementing new features or modifying existing code. 