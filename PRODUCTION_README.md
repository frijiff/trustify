# Trustify - Community-Driven Business Review Platform

A modern Flutter application that allows users to discover honest reviews about businesses and submit their own experiences. Built with GetX, Appwrite, and Material Design 3.

## 🎯 Features

- **User Authentication**: Secure email/password authentication with Appwrite
- **Review Discovery**: Search and browse business reviews by link
- **Submit Reviews**: Share detailed reviews with ratings and images
- **Coin System**: Earn coins through community engagement
- **User Profiles**: Track your reviews and manage your account
- **Multi-language Support**: English, French, and Arabic
- **Modern UI**: Material Design 3 with smooth animations
- **Responsive Design**: Works seamlessly on all device sizes

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.9.2+
- **State Management**: GetX
- **Backend**: Appwrite (Authentication, Database, Storage)
- **Localization**: Flutter Localizations + Intl
- **Architecture**: MVC with GetX controllers

## 📦 Dependencies

```yaml
flutter:
  sdk: flutter
cupertino_icons: ^1.0.8
get: ^4.7.3
flutter_localizations:
  sdk: flutter
intl: ^0.20.2
shared_preferences: ^2.2.2
appwrite: ^21.3.0
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart 3.3.0+
- Appwrite Server (self-hosted or cloud)
- Android SDK / Xcode (for mobile development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/trustify.git
   cd trustify
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Appwrite**
   - Update `lib/config/config.dart` with your Appwrite credentials:
     ```dart
     static const String APPWRITE_ENDPOINT = 'https://your-appwrite-endpoint.com/v1';
     static const String APPWRITE_PROJECT_ID = 'your-project-id';
     ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── config/
│   └── config.dart              # Configuration constants
├── constants/
│   └── color.dart               # App color palette
├── controllers/
│   └── user_controller.dart     # User state management
├── models/
│   └── user_model.dart          # Data models
├── screens/
│   ├── splash_screen.dart
│   ├── language_selection_screen.dart
│   ├── auth_screen.dart
│   ├── onboarding_screen.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   └── submit_review_screen.dart
├── services/
│   └── appwrite_service.dart    # Appwrite API wrapper
├── widgets/
│   └── review_list.dart         # Reusable components
└── main.dart                    # App entry point
```

## 📱 Screen Overview

### Splash Screen
- Checks user authentication status
- Handles language preference loading
- Routes to appropriate next screen

### Language Selection
- Choose between English, French, and Arabic
- Persists selection to SharedPreferences

### Authentication
- Login and signup with email/password
- Form validation
- Error handling with user feedback

### Onboarding
- 4-slide introduction to app features
- Skip option available
- Smooth page transitions

### Home Screen
- Search reviews by business link
- Paginated review list (16 items per page)
- Quick access to submit review
- Display user coins balance

### Profile Screen
- View user information
- Display coin balance
- Track submitted reviews
- Review history

### Submit Review Screen
- Form with business link input
- Star rating system (1-5)
- Review text input (up to 1000 characters)
- Image upload (up to 5 images)
- Submit to Appwrite database

## 🔐 Security & Production Checklist

- [ ] Update Appwrite endpoint and project ID
- [ ] Configure proper CORS settings in Appwrite
- [ ] Enable email verification
- [ ] Set up production database indexes
- [ ] Configure Firebase/AdMob for ads
- [ ] Enable app signing for Play Store
- [ ] Set up error tracking (Sentry/Crashlytics)
- [ ] Configure rate limiting in Appwrite
- [ ] Set up backup strategy
- [ ] Test all authentication flows
- [ ] Validate image upload security
- [ ] Test coin system thoroughly
- [ ] Configure push notifications
- [ ] Set up analytics tracking

## 🎨 Customization

### Colors
Edit `lib/constants/color.dart`:
```dart
class AppColors {
  static const Color primaryGreen = Color(0xFF2ECC71);
  static const Color accentOrange = Color(0xFFE67E22);
  static const Color backgroundWhite = Color(0xFFFAFAFA);
  // ...
}
```

### Configuration
Edit `lib/config/config.dart`:
```dart
class Config {
  static const int SEARCH_COIN_COST = 2;
  static const int INITIAL_COINS = 10;
  static const int PAGE_SIZE = 16;
  // ...
}
```

## 🧪 Testing

Run unit tests:
```bash
flutter test
```

Run widget tests:
```bash
flutter test test/widget_test.dart
```

## 📈 Performance Optimization

- **Lazy Loading**: Reviews loaded in pages of 16 items
- **Image Optimization**: Compress images before upload
- **Caching**: SharedPreferences for local user data
- **State Management**: GetX for efficient rebuilds
- **Code Splitting**: Modular architecture for better load times

## 🔄 API Integration

### Authentication
```dart
// Signup
await appwrite.signup(
  email: 'user@example.com',
  password: 'password',
  name: 'John Doe',
);

// Login
await appwrite.login(
  email: 'user@example.com',
  password: 'password',
);

// Logout
await appwrite.logout();
```

### Reviews
```dart
// Get reviews with pagination
final reviews = await appwrite.getReviews(
  queries: [Query.equal('link', 'https://business.com')],
  limit: 16,
);

// Create review
await appwrite.createReview(
  link: 'https://business.com',
  reviewText: 'Great service!',
  rating: 5.0,
  userId: userId,
  imageIds: ['image1', 'image2'],
);
```

## 🐛 Troubleshooting

### Build Issues
- Run `flutter clean && flutter pub get`
- Delete corrupted NDK: `rm -rf $ANDROID_HOME/ndk/`
- Rebuild: `flutter run`

### Appwrite Connection Issues
- Verify endpoint URL is correct
- Check project ID matches
- Ensure CORS is enabled in Appwrite console
- Verify network connectivity

### Image Upload Fails
- Check storage bucket exists
- Verify bucket permissions
- Ensure file size is within limits

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Appwrite Documentation](https://appwrite.io/docs)
- [Material Design 3](https://m3.material.io/)

## 📝 License

This project is licensed under the MIT License - see LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📧 Support

For support, email support@trustify.app or open an issue on GitHub.

## 🎯 Roadmap

- [ ] Push notifications
- [ ] Advanced filtering and sorting
- [ ] Review editing and deletion
- [ ] User messaging system
- [ ] Business verification badges
- [ ] Review moderation dashboard
- [ ] Analytics dashboard
- [ ] Mobile app monetization (ads/premium)
- [ ] Web platform
- [ ] API for third-party integrations

---

**Built with ❤️ for honest reviews**
