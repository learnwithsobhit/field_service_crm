# Field Service CRM - Developer Guide

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture & Structure](#architecture--structure)
3. [Technology Stack](#technology-stack)
4. [Project Setup](#project-setup)
5. [Code Organization](#code-organization)
6. [Development Patterns](#development-patterns)
7. [Adding New Screens](#adding-new-screens)
8. [Adding New Features](#adding-new-features)
9. [State Management](#state-management)
10. [Navigation](#navigation)
11. [Styling & Theming](#styling--theming)
12. [Testing](#testing)
13. [Deployment](#deployment)
14. [Troubleshooting](#troubleshooting)
15. [Best Practices](#best-practices)

---

## 🎯 Project Overview

**Field Service CRM** is a comprehensive mobile application built with Flutter for managing field service operations. The app provides tools for job management, customer relationship management, inventory tracking, scheduling, invoicing, and team collaboration.

### Key Features
- **Job Management**: Create, track, and manage service jobs
- **Customer Management**: Maintain customer information and service history
- **Inventory Tracking**: Real-time inventory management with alerts
- **Team Scheduling**: Optimize job assignments and routes
- **Financial Management**: Invoicing, expense tracking, and reporting
- **Quality Assurance**: Inspection checklists and quality control
- **Communication**: Team chat and notification system
- **Analytics**: Business insights and performance metrics

---

## 🏗️ Architecture & Structure

### Project Structure
```
field_service_crm/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── screens/                  # All UI screens
│   │   ├── auth/                 # Authentication screens
│   │   ├── jobs/                 # Job management screens
│   │   ├── customers/            # Customer management screens
│   │   ├── inventory/            # Inventory management screens
│   │   ├── scheduler/            # Scheduling screens
│   │   ├── equipment/            # Equipment management screens
│   │   ├── tracking/             # Time tracking screens
│   │   ├── invoicing/            # Financial management screens
│   │   ├── maps/                 # Location and mapping screens
│   │   ├── reports/              # Reporting screens
│   │   ├── settings/             # Settings and configuration screens
│   │   ├── chat/                 # Communication screens
│   │   ├── notifications/        # Notification screens
│   │   ├── profile/              # User profile screens
│   │   ├── emergency/            # Emergency response screens
│   │   ├── analytics/            # Analytics and dashboard screens
│   │   ├── expenses/             # Expense tracking screens
│   │   ├── documents/            # Document management screens
│   │   ├── dashboard/            # Dashboard widgets
│   │   ├── work_orders/          # Work order management
│   │   ├── service_history/      # Service history tracking
│   │   ├── quality/              # Quality assurance
│   │   ├── splash_screen.dart    # App splash screen
│   │   └── icon_preview_screen.dart
│   ├── widgets/                  # Reusable UI components
│   │   ├── app_logo.dart         # App logo components
│   │   ├── brand_header.dart     # Brand header components
│   │   ├── simple_app_icon.dart  # App icon generator
│   │   └── app_icon_generator.dart
│   ├── models/                   # Data models (to be added)
│   ├── services/                 # Business logic services (to be added)
│   ├── providers/                # State management (to be added)
│   └── utils/                    # Utility functions (to be added)
├── assets/
│   ├── images/                   # Image assets
│   ├── icons/                    # Icon assets
│   ├── animations/               # Animation files
│   └── mock_data/                # Mock data files
├── test/                         # Test files
├── android/                      # Android-specific files
├── ios/                          # iOS-specific files
├── pubspec.yaml                  # Dependencies and configuration
└── README.md                     # Project documentation
```

### Architecture Pattern
The app follows a **Feature-Based Architecture** where:
- Each feature has its own directory under `screens/`
- Related screens are grouped together
- Shared components are in the `widgets/` directory
- Business logic will be separated into `services/` and `providers/`

---

## 🛠️ Technology Stack

### Core Technologies
- **Flutter**: 3.5.4+ (Dart SDK)
- **Dart**: Latest stable version

### Key Dependencies
```yaml
# State Management
flutter_riverpod: ^2.5.1
riverpod_annotation: ^2.3.5

# Routing
go_router: ^14.2.7

# Local Storage
hive: ^2.2.3
hive_flutter: ^1.1.0

# Network & API
dio: ^5.4.3+1
connectivity_plus: ^6.0.5

# UI Components
shimmer: ^3.0.0
lottie: ^3.1.2
fl_chart: ^0.68.0

# Maps & Location
google_maps_flutter: ^2.7.0
location: ^7.0.0

# Camera & Barcode
camera: ^0.11.0+2
mobile_scanner: ^5.2.3

# Notifications
flutter_local_notifications: ^17.2.2

# Utilities
intl: ^0.19.0
uuid: ^4.4.2
```

---

## 🚀 Project Setup

### Prerequisites
1. **Flutter SDK**: Install Flutter 3.5.4 or higher
2. **Dart SDK**: Latest stable version
3. **IDE**: VS Code, Android Studio, or IntelliJ IDEA
4. **Git**: For version control

### Installation Steps
```bash
# Clone the repository
git clone <repository-url>
cd field_service_crm

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Development Environment Setup
1. **Flutter Doctor**: Run `flutter doctor` to verify setup
2. **IDE Extensions**: Install Flutter and Dart extensions
3. **Emulator/Device**: Set up iOS Simulator or Android Emulator
4. **Code Formatting**: Enable format on save in your IDE

---

## 📁 Code Organization

### Screen Structure
Each screen follows a consistent structure:

```dart
import 'package:flutter/material.dart';

class ScreenName extends StatefulWidget {
  const ScreenName({super.key});

  @override
  State<ScreenName> createState() => _ScreenNameState();
}

class _ScreenNameState extends State<ScreenName> {
  // State variables
  String _selectedValue = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Title'),
        actions: [
          // Action buttons
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Screen content
          ],
        ),
      ),
    );
  }

  // Helper methods
  Widget _buildSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Section content
          ],
        ),
      ),
    );
  }
}
```

### Widget Structure
Reusable widgets follow this pattern:

```dart
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
    return Container(
      // Widget implementation
    );
  }
}
```

---

## 🔄 Development Patterns

### 1. Consistent Naming Conventions
- **Files**: `snake_case.dart` (e.g., `job_list_screen.dart`)
- **Classes**: `PascalCase` (e.g., `JobListScreen`)
- **Variables**: `camelCase` (e.g., `selectedJob`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `DEFAULT_PADDING`)

### 2. Widget Composition
```dart
// Good: Break down complex widgets
Widget _buildComplexSection() {
  return Column(
    children: [
      _buildHeader(),
      _buildContent(),
      _buildActions(),
    ],
  );
}

// Good: Extract reusable components
Widget _buildMetricCard(String title, String value, IconData icon) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon),
          Text(title),
          Text(value),
        ],
      ),
    ),
  );
}
```

### 3. Error Handling
```dart
try {
  // Risky operation
  await performOperation();
} catch (e) {
  // Handle error gracefully
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error: ${e.toString()}'),
      backgroundColor: Colors.red,
    ),
  );
}
```

### 4. Loading States
```dart
bool _isLoading = false;

Widget _buildContent() {
  if (_isLoading) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  
  return _buildActualContent();
}
```

---

## 📱 Adding New Screens

### Step 1: Create Screen File
```bash
# Create directory if needed
mkdir -p lib/screens/feature_name

# Create screen file
touch lib/screens/feature_name/feature_screen.dart
```

### Step 2: Implement Screen
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 8),
            Text(
              'Description of the feature',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
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

### Step 3: Add to Navigation
```dart
// In main.dart, add import
import 'screens/feature_name/feature_screen.dart';

// Add to routes
routes: {
  '/feature': (context) => const FeatureScreen(),
}

// Add navigation button in dashboard
_buildQuickActionCard(
  context,
  'Feature Name',
  'Feature description',
  Icons.feature_icon,
  Colors.blue,
  () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FeatureScreen(),
      ),
    );
  },
),
```

---

## ⚡ Adding New Features

### 1. Data Models
Create models in `lib/models/`:

```dart
// lib/models/feature_model.dart
class FeatureModel {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;

  FeatureModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
```

### 2. Services
Create business logic in `lib/services/`:

```dart
// lib/services/feature_service.dart
class FeatureService {
  Future<List<FeatureModel>> getFeatures() async {
    // API call or local storage logic
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    
    return [
      FeatureModel(
        id: '1',
        name: 'Feature 1',
        description: 'Description 1',
        createdAt: DateTime.now(),
      ),
    ];
  }

  Future<void> createFeature(FeatureModel feature) async {
    // Create feature logic
  }

  Future<void> updateFeature(FeatureModel feature) async {
    // Update feature logic
  }

  Future<void> deleteFeature(String id) async {
    // Delete feature logic
  }
}
```

### 3. State Management
Create providers in `lib/providers/`:

```dart
// lib/providers/feature_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feature_model.dart';
import '../services/feature_service.dart';

final featureServiceProvider = Provider<FeatureService>((ref) {
  return FeatureService();
});

final featuresProvider = FutureProvider<List<FeatureModel>>((ref) async {
  final service = ref.read(featureServiceProvider);
  return await service.getFeatures();
});

final featureProvider = StateNotifierProvider<FeatureNotifier, AsyncValue<List<FeatureModel>>>((ref) {
  return FeatureNotifier(ref.read(featureServiceProvider));
});

class FeatureNotifier extends StateNotifier<AsyncValue<List<FeatureModel>>> {
  final FeatureService _service;

  FeatureNotifier(this._service) : super(const AsyncValue.loading()) {
    loadFeatures();
  }

  Future<void> loadFeatures() async {
    state = const AsyncValue.loading();
    try {
      final features = await _service.getFeatures();
      state = AsyncValue.data(features);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addFeature(FeatureModel feature) async {
    try {
      await _service.createFeature(feature);
      loadFeatures(); // Reload the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
```

### 4. UI Integration
Use providers in your screen:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feature_provider.dart';

class FeatureScreen extends ConsumerWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuresAsync = ref.watch(featuresProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Features')),
      body: featuresAsync.when(
        data: (features) => ListView.builder(
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return ListTile(
              title: Text(feature.name),
              subtitle: Text(feature.description),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
```

---

## 🎨 Styling & Theming

### Color Scheme
The app uses a consistent color scheme defined in `main.dart`:

```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF14B8A6), // Teal 500
  ),
)
```

### Custom Colors
```dart
// Primary colors
const Color(0xFF14B8A6) // Teal 500
const Color(0xFF0F766E) // Teal 700

// Status colors
Colors.green   // Success
Colors.red     // Error
Colors.orange  // Warning
Colors.blue    // Info
Colors.grey    // Neutral
```

### Typography
```dart
// Headlines
Theme.of(context).textTheme.headlineLarge
Theme.of(context).textTheme.headlineMedium
Theme.of(context).textTheme.headlineSmall

// Body text
Theme.of(context).textTheme.bodyLarge
Theme.of(context).textTheme.bodyMedium
Theme.of(context).textTheme.bodySmall

// Titles
Theme.of(context).textTheme.titleLarge
Theme.of(context).textTheme.titleMedium
Theme.of(context).textTheme.titleSmall
```

### Common Widgets
```dart
// Card with consistent styling
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        // Content
      ],
    ),
  ),
)

// Action button
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF14B8A6),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: const Text('Action'),
)

// Quick action card
Widget _buildQuickActionCard(
  BuildContext context,
  String title,
  String description,
  IconData icon,
  Color color,
  VoidCallback onTap,
) {
  return Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
```

---

## 🧪 Testing

### Unit Tests
Create tests in `test/` directory:

```dart
// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:field_service_crm/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FieldServiceCRMApp());
    expect(find.text('Field Service CRM'), findsOneWidget);
  });
}
```

### Widget Tests
```dart
// test/screens/feature_screen_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:field_service_crm/screens/feature_name/feature_screen.dart';

void main() {
  group('FeatureScreen', () {
    testWidgets('displays feature title', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: FeatureScreen(),
      ));
      
      expect(find.text('Feature Name'), findsOneWidget);
    });
  });
}
```

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/screens/feature_screen_test.dart

# Run with coverage
flutter test --coverage
```

---

## 🚀 Deployment

### Android Deployment
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS Deployment
```bash
# Build iOS app
flutter build ios --release

# Open Xcode for signing
open ios/Runner.xcworkspace
```

### Web Deployment
```bash
# Build web app
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy
```

---

## 🔧 Troubleshooting

### Common Issues

#### 1. Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

#### 2. Dependency Issues
```bash
# Update dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

#### 3. iOS Simulator Issues
```bash
# Reset iOS Simulator
xcrun simctl erase all

# Open Simulator
open -a Simulator
```

#### 4. Android Emulator Issues
```bash
# List available emulators
flutter emulators

# Start emulator
flutter emulators --launch <emulator_id>
```

### Debug Tips
1. **Hot Reload**: Use `r` in terminal or `Ctrl+S` in IDE
2. **Hot Restart**: Use `R` in terminal or `Ctrl+Shift+S` in IDE
3. **Flutter Inspector**: Use DevTools for widget inspection
4. **Logs**: Check console output for error messages

---

## 📚 Best Practices

### 1. Code Organization
- Keep files under 500 lines
- Use meaningful file and folder names
- Group related functionality together
- Separate UI, business logic, and data layers

### 2. Performance
- Use `const` constructors where possible
- Implement proper list views with `ListView.builder`
- Avoid unnecessary rebuilds
- Use `RepaintBoundary` for complex widgets

### 3. Accessibility
- Add semantic labels to widgets
- Use proper contrast ratios
- Support screen readers
- Test with accessibility tools

### 4. Error Handling
- Always handle async operations with try-catch
- Provide meaningful error messages
- Implement proper loading states
- Use error boundaries where appropriate

### 5. State Management
- Keep state as local as possible
- Use providers for shared state
- Avoid prop drilling
- Implement proper state updates

### 6. Testing
- Write tests for critical functionality
- Test edge cases and error scenarios
- Maintain good test coverage
- Use meaningful test names

### 7. Documentation
- Document complex business logic
- Add comments for non-obvious code
- Keep README files updated
- Document API endpoints and data models

---

## 🔗 Useful Resources

### Flutter Documentation
- [Flutter Official Docs](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets)

### State Management
- [Riverpod Documentation](https://riverpod.dev/)
- [Provider Pattern](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple)

### UI/UX
- [Material Design](https://material.io/design)
- [Flutter Material Components](https://flutter.dev/docs/development/ui/widgets/material)

### Testing
- [Flutter Testing](https://flutter.dev/docs/testing)
- [Widget Testing](https://flutter.dev/docs/cookbook/testing/widget/introduction)

### Deployment
- [Flutter Deployment](https://flutter.dev/docs/deployment)
- [Firebase Hosting](https://firebase.google.com/docs/hosting)

---

## 📞 Support

For questions or issues:
1. Check the troubleshooting section above
2. Review Flutter documentation
3. Search existing issues in the repository
4. Create a new issue with detailed information

---

**Happy Coding! 🚀**

This developer guide should help any new developer quickly understand the project structure and start contributing effectively. Remember to keep this guide updated as the project evolves. 