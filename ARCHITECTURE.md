# Field Service CRM - Architecture Documentation

## 🏗️ System Architecture Overview

The Field Service CRM follows a **Feature-Based Architecture** with **Clean Architecture** principles, designed for scalability, maintainability, and testability.

## 📐 Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │   Screens   │ │   Widgets   │ │ Navigation  │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Business Layer                          │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │  Providers  │ │  Services   │ │   Models    │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │   Local     │ │   Remote    │ │   Cache     │           │
│  │  Storage    │ │    API      │ │             │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 Design Patterns

### 1. Feature-Based Organization
Each feature is self-contained with its own screens, models, and business logic:

```
screens/
├── jobs/                    # Job Management Feature
│   ├── job_list_screen.dart
│   ├── job_detail_screen.dart
│   └── create_job_screen.dart
├── customers/               # Customer Management Feature
│   └── customer_management_screen.dart
├── inventory/               # Inventory Management Feature
│   └── inventory_screen.dart
└── ...
```

### 2. Widget Composition Pattern
Complex UIs are broken down into smaller, reusable components:

```dart
class JobListScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterSection(),
          _buildJobList(),
        ],
      ),
    );
  }

  Widget _buildAppBar() { /* Implementation */ }
  Widget _buildSearchBar() { /* Implementation */ }
  Widget _buildFilterSection() { /* Implementation */ }
  Widget _buildJobList() { /* Implementation */ }
}
```

### 3. Service Layer Pattern
Business logic is separated into service classes:

```dart
abstract class JobService {
  Future<List<Job>> getJobs();
  Future<Job> createJob(Job job);
  Future<Job> updateJob(Job job);
  Future<void> deleteJob(String id);
}

class JobServiceImpl implements JobService {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  JobServiceImpl(this._apiClient, this._localStorage);

  @override
  Future<List<Job>> getJobs() async {
    // Implementation with caching logic
  }
}
```

### 4. Provider Pattern (Riverpod)
State management using Riverpod for reactive programming:

```dart
// Provider definitions
final jobServiceProvider = Provider<JobService>((ref) {
  return JobServiceImpl(ref.read(apiClientProvider), ref.read(storageProvider));
});

final jobsProvider = StateNotifierProvider<JobsNotifier, AsyncValue<List<Job>>>((ref) {
  return JobsNotifier(ref.read(jobServiceProvider));
});

// State notifier
class JobsNotifier extends StateNotifier<AsyncValue<List<Job>>> {
  final JobService _jobService;

  JobsNotifier(this._jobService) : super(const AsyncValue.loading()) {
    loadJobs();
  }

  Future<void> loadJobs() async {
    state = const AsyncValue.loading();
    try {
      final jobs = await _jobService.getJobs();
      state = AsyncValue.data(jobs);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
```

## 🔄 Data Flow Architecture

### 1. Unidirectional Data Flow
```
User Action → Provider → Service → Repository → Data Source
     ↑                                                    ↓
     └─────────────── UI Update ←────────────────────────┘
```

### 2. State Management Flow
```dart
// 1. User triggers action
ElevatedButton(
  onPressed: () => ref.read(jobsNotifierProvider.notifier).createJob(newJob),
  child: Text('Create Job'),
)

// 2. Provider updates state
class JobsNotifier extends StateNotifier<AsyncValue<List<Job>>> {
  Future<void> createJob(Job job) async {
    state = const AsyncValue.loading();
    try {
      await _jobService.createJob(job);
      await loadJobs(); // Refresh the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// 3. UI automatically rebuilds
Consumer(
  builder: (context, ref, child) {
    final jobsAsync = ref.watch(jobsProvider);
    return jobsAsync.when(
      data: (jobs) => JobList(jobs: jobs),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  },
)
```

## 🗂️ File Organization Strategy

### 1. Feature-First Organization
```
lib/
├── features/
│   ├── jobs/
│   │   ├── screens/
│   │   ├── widgets/
│   │   ├── models/
│   │   ├── services/
│   │   └── providers/
│   ├── customers/
│   │   ├── screens/
│   │   ├── widgets/
│   │   ├── models/
│   │   ├── services/
│   │   └── providers/
│   └── ...
├── shared/
│   ├── widgets/
│   ├── services/
│   ├── utils/
│   └── constants/
└── main.dart
```

### 2. Shared Components
Common widgets and utilities are placed in shared directories:

```dart
// lib/shared/widgets/loading_widget.dart
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

// Usage across features
LoadingWidget(message: 'Loading jobs...')
```

## 🔌 Dependency Injection

### 1. Provider-Based DI
Riverpod provides dependency injection capabilities:

```dart
// Core dependencies
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: 'https://api.fieldservice.com',
    timeout: const Duration(seconds: 30),
  );
});

final storageProvider = Provider<LocalStorage>((ref) {
  return HiveStorage();
});

// Feature-specific dependencies
final jobRepositoryProvider = Provider<JobRepository>((ref) {
  return JobRepositoryImpl(
    ref.read(apiClientProvider),
    ref.read(storageProvider),
  );
});

final jobServiceProvider = Provider<JobService>((ref) {
  return JobServiceImpl(ref.read(jobRepositoryProvider));
});
```

### 2. Environment Configuration
```dart
enum Environment { development, staging, production }

final environmentProvider = Provider<Environment>((ref) {
  return Environment.development; // Configure based on build
});

final configProvider = Provider<AppConfig>((ref) {
  final env = ref.read(environmentProvider);
  return AppConfig.fromEnvironment(env);
});
```

## 🗄️ Data Layer Architecture

### 1. Repository Pattern
```dart
abstract class JobRepository {
  Future<List<Job>> getJobs();
  Future<Job> getJob(String id);
  Future<Job> createJob(Job job);
  Future<Job> updateJob(Job job);
  Future<void> deleteJob(String id);
}

class JobRepositoryImpl implements JobRepository {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  JobRepositoryImpl(this._apiClient, this._localStorage);

  @override
  Future<List<Job>> getJobs() async {
    try {
      // Try to get from cache first
      final cachedJobs = await _localStorage.getJobs();
      if (cachedJobs.isNotEmpty) {
        return cachedJobs;
      }

      // Fetch from API
      final jobs = await _apiClient.getJobs();
      
      // Cache the results
      await _localStorage.saveJobs(jobs);
      
      return jobs;
    } catch (e) {
      // Fallback to cached data
      return await _localStorage.getJobs();
    }
  }
}
```

### 2. Caching Strategy
```dart
class CacheManager {
  static const Duration defaultTtl = Duration(minutes: 15);
  
  Future<T?> getCached<T>(String key) async {
    final cached = await _storage.get(key);
    if (cached != null && !_isExpired(cached)) {
      return cached.data as T;
    }
    return null;
  }
  
  Future<void> setCached<T>(String key, T data, {Duration? ttl}) async {
    final cacheEntry = CacheEntry(
      data: data,
      timestamp: DateTime.now(),
      ttl: ttl ?? defaultTtl,
    );
    await _storage.set(key, cacheEntry);
  }
}
```

## 🔐 Security Architecture

### 1. Authentication Flow
```dart
class AuthService {
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _apiClient.login(email, password);
      await _storage.saveToken(response.token);
      await _storage.saveUser(response.user);
      return AuthResult.success(response.user);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }
  
  Future<void> logout() async {
    await _storage.clearToken();
    await _storage.clearUser();
  }
}
```

### 2. Token Management
```dart
class TokenInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
  
  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _tokenStorage.clearToken();
      // Navigate to login
    }
    handler.next(err);
  }
}
```

## 📱 Platform-Specific Architecture

### 1. Platform Channels
```dart
class NativeService {
  static const platform = MethodChannel('com.fieldservice/native');
  
  static Future<String> getDeviceId() async {
    try {
      final result = await platform.invokeMethod('getDeviceId');
      return result;
    } catch (e) {
      return 'unknown';
    }
  }
}
```

### 2. Platform-Specific UI
```dart
class PlatformAwareWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton(
        onPressed: () {},
        child: Text('iOS Style'),
      );
    } else {
      return ElevatedButton(
        onPressed: () {},
        child: Text('Material Style'),
      );
    }
  }
}
```

## 🧪 Testing Architecture

### 1. Unit Testing
```dart
void main() {
  group('JobService', () {
    late JobService jobService;
    late MockJobRepository mockRepository;
    
    setUp(() {
      mockRepository = MockJobRepository();
      jobService = JobServiceImpl(mockRepository);
    });
    
    test('should return jobs from repository', () async {
      // Arrange
      final expectedJobs = [Job(id: '1', title: 'Test Job')];
      when(mockRepository.getJobs()).thenAnswer((_) async => expectedJobs);
      
      // Act
      final result = await jobService.getJobs();
      
      // Assert
      expect(result, equals(expectedJobs));
      verify(mockRepository.getJobs()).called(1);
    });
  });
}
```

### 2. Widget Testing
```dart
void main() {
  group('JobListScreen', () {
    testWidgets('displays jobs when loaded', (WidgetTester tester) async {
      // Arrange
      final mockJobs = [Job(id: '1', title: 'Test Job')];
      
      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            jobsProvider.overrideWith((ref) => AsyncValue.data(mockJobs)),
          ],
          child: MaterialApp(home: JobListScreen()),
        ),
      );
      
      // Assert
      expect(find.text('Test Job'), findsOneWidget);
    });
  });
}
```

## 📊 Performance Architecture

### 1. Lazy Loading
```dart
class LazyJobList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        // Only build visible items
        return JobCard(job: jobs[index]);
      },
    );
  }
}
```

### 2. Image Caching
```dart
class CachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      memCacheWidth: 300, // Optimize memory usage
    );
  }
}
```

## 🔄 State Synchronization

### 1. Offline-First Architecture
```dart
class OfflineFirstRepository<T> {
  Future<List<T>> getData() async {
    // Always try local first
    final localData = await _localStorage.getData<T>();
    
    // Sync with server in background
    _syncWithServer();
    
    return localData;
  }
  
  Future<void> _syncWithServer() async {
    try {
      final serverData = await _apiClient.getData();
      await _localStorage.saveData(serverData);
    } catch (e) {
      // Handle sync errors gracefully
      _logSyncError(e);
    }
  }
}
```

### 2. Conflict Resolution
```dart
class ConflictResolver<T> {
  Future<T> resolveConflict(T local, T remote) async {
    // Implement conflict resolution logic
    if (remote.lastModified.isAfter(local.lastModified)) {
      return remote;
    }
    return local;
  }
}
```

## 🚀 Scalability Considerations

### 1. Modular Architecture
- Each feature is independent and can be developed separately
- Shared components are properly abstracted
- Dependencies are clearly defined and minimal

### 2. Performance Optimization
- Lazy loading for large lists
- Image caching and optimization
- Efficient state management
- Background processing for heavy operations

### 3. Maintainability
- Clear separation of concerns
- Consistent coding patterns
- Comprehensive documentation
- Automated testing

This architecture provides a solid foundation for building a scalable, maintainable, and performant Field Service CRM application. 