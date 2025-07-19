# Field Service CRM

A comprehensive Flutter-based field service management application designed for service businesses to manage jobs, inventory, team communication, and customer relationships.

## 🚀 Features

### Core Functionality
- **Dashboard** - Real-time overview with metrics, calendar, and quick actions
- **Job Management** - Create, track, and manage service jobs with full lifecycle
- **Inventory System** - Track stock levels, barcode scanning, and restock alerts
- **Team Communication** - Real-time chat, voice calls, and emergency alerts
- **Location Services** - GPS tracking, route optimization, and location sharing
- **Invoicing & Payments** - Create invoices, track payments, and financial reports
- **Reports & Analytics** - Comprehensive KPIs, performance metrics, and insights

### User Management
- **Multi-Role Support** - Technician, Supervisor, Manager, Dispatcher, Administrator
- **Profile Management** - Complete user profiles with preferences and settings
- **Activity History** - Detailed timeline of user actions and system events
- **Notification Center** - Granular notification controls and preferences

### Advanced Features
- **Offline Support** - Hive database for offline data synchronization
- **Real-time Updates** - Live data synchronization across devices
- **Emergency Alerts** - Critical situation handling and rapid response
- **Mobile-First Design** - Optimized for field technicians on mobile devices

## 📱 Screenshots

*[Screenshots will be added here]*

## 🛠 Tech Stack

- **Framework**: Flutter 3.5.4+
- **Language**: Dart
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Local Database**: Hive
- **UI Components**: Material 3 Design System
- **Charts**: FL Chart
- **Maps**: Google Maps Flutter
- **Camera**: Image Picker, Mobile Scanner
- **Notifications**: Flutter Local Notifications

## 📋 Prerequisites

- Flutter SDK 3.5.4 or higher
- Dart SDK 3.5.4 or higher
- iOS 12.0+ / Android 5.0+ (API level 21)
- Xcode 14+ (for iOS development)
- Android Studio / VS Code

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/field-service-crm.git
cd field-service-crm
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Environment
Create a `.env` file in the root directory:
```env
# API Configuration
API_BASE_URL=your_api_base_url
API_KEY=your_api_key

# Google Maps
GOOGLE_MAPS_API_KEY=your_google_maps_api_key

# Push Notifications
FCM_SERVER_KEY=your_fcm_server_key
```

### 4. Run the App
```bash
# For iOS
flutter run -d "iPhone 16 Plus"

# For Android
flutter run -d "Android Device"

# For Web
flutter run -d chrome
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/                  # UI screens
│   ├── auth/                # Authentication screens
│   ├── dashboard/           # Dashboard and overview
│   ├── jobs/               # Job management
│   ├── inventory/          # Inventory system
│   ├── chat/              # Team communication
│   ├── maps/              # Location services
│   ├── invoicing/         # Billing and payments
│   ├── reports/           # Analytics and reports
│   ├── profile/           # User profile management
│   └── settings/          # App settings
├── models/                # Data models
├── providers/             # State management
├── services/              # Business logic
├── utils/                 # Utilities and helpers
└── widgets/               # Reusable UI components
```

## 🔧 Configuration

### iOS Configuration
1. Open `ios/Runner.xcworkspace` in Xcode
2. Configure signing and capabilities
3. Add required permissions in `Info.plist`

### Android Configuration
1. Update `android/app/build.gradle` with your package name
2. Configure signing in `android/app/build.gradle`
3. Add permissions in `android/app/src/main/AndroidManifest.xml`

## 📊 Features by Role

### Technician
- View assigned jobs and schedules
- Update job status and progress
- Access inventory and equipment
- Communicate with team and clients
- Track time and location
- Generate job reports

### Supervisor
- Manage team assignments
- Monitor job progress
- Review performance metrics
- Handle escalations
- Generate team reports

### Manager
- Strategic planning and analytics
- Financial reporting
- Resource allocation
- Performance management
- Business insights

### Dispatcher
- Job assignment and scheduling
- Real-time team tracking
- Emergency response coordination
- Route optimization
- Communication management

## 🔐 Security Features

- Secure authentication and authorization
- Role-based access control
- Data encryption in transit and at rest
- Privacy controls for location sharing
- Audit logging for compliance

## 📈 Performance

- Optimized for mobile networks
- Efficient data synchronization
- Minimal battery consumption
- Fast app startup and navigation
- Responsive UI design

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 📦 Building for Production

### iOS
```bash
flutter build ios --release
```

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:
- Create an issue in the GitHub repository
- Contact: support@fieldservicecrm.com
- Documentation: [docs.fieldservicecrm.com](https://docs.fieldservicecrm.com)

## 🗺 Roadmap

### Phase 1 (Current)
- ✅ Core job management
- ✅ Inventory tracking
- ✅ Team communication
- ✅ Basic reporting

### Phase 2 (Next)
- 🔄 Advanced analytics
- 🔄 AI-powered insights
- 🔄 Integration APIs
- 🔄 Mobile app store release

### Phase 3 (Future)
- 📋 Multi-tenant support
- 📋 Advanced automation
- 📋 IoT device integration
- 📋 White-label solutions

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
- All contributors and beta testers
- Field service professionals for domain expertise

---

**Built with ❤️ for field service professionals**
