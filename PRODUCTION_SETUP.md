## Production Setup Guide

This guide covers all steps needed to deploy Trustify to production.

### 1. Appwrite Backend Setup

#### Create Database and Collections

```bash
# Initialize Appwrite CLI if not done
appwrite init

# Create reviews database
appwrite databases create --id reviews_db

# Create reviews collection
appwrite databases create-collection \
  --database-id reviews_db \
  --collection-id reviews \
  --name "Reviews"

# Create reviews attributes
appwrite databases create-string-attribute \
  --database-id reviews_db \
  --collection-id reviews \
  --key link \
  --required true

appwrite databases create-string-attribute \
  --database-id reviews_db \
  --collection-id reviews \
  --key review_text \
  --required true \
  --size 1000

appwrite databases create-float-attribute \
  --database-id reviews_db \
  --collection-id reviews \
  --key rating \
  --required true

appwrite databases create-string-attribute \
  --database-id reviews_db \
  --collection-id reviews \
  --key user_id \
  --required true

appwrite databases create-string-attribute \
  --database-id reviews_db \
  --collection-id reviews \
  --key images \
  --array true \
  --required false

appwrite databases create-integer-attribute \
  --database-id reviews_db \
  --collection-id reviews \
  --key helpful_count \
  --default 0 \
  --required false

# Create users collection
appwrite databases create-collection \
  --database-id reviews_db \
  --collection-id users \
  --name "Users"

# Create users attributes
appwrite databases create-string-attribute \
  --database-id reviews_db \
  --collection-id users \
  --key name \
  --required true

appwrite databases create-string-attribute \
  --database-id reviews_db \
  --collection-id users \
  --key email \
  --required true

appwrite databases create-integer-attribute \
  --database-id reviews_db \
  --collection-id users \
  --key coins \
  --default 10 \
  --required false

appwrite databases create-integer-attribute \
  --database-id reviews_db \
  --collection-id users \
  --key total_reviews \
  --default 0 \
  --required false
```

#### Create Storage Bucket

```bash
# Create images bucket
appwrite storage create-bucket \
  --bucket-id review_images \
  --name "Review Images"
```

### 2. Android Configuration

#### App Signing

1. **Generate keystore:**
```bash
keytool -genkey -v -keystore ~/trustify-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias trustify-key
```

2. **Configure signing in `android/app/build.gradle.kts`:**
```kotlin
android {
    signingConfigs {
        create("release") {
            storeFile = file("/path/to/trustify-keystore.jks")
            storePassword = System.getenv("KEYSTORE_PASSWORD")
            keyAlias = System.getenv("KEY_ALIAS")
            keyPassword = System.getenv("KEY_PASSWORD")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

3. **Build release APK:**
```bash
flutter build apk --release
```

### 3. iOS Configuration

#### App Store Setup

1. Create App ID in Apple Developer Console
2. Configure bundle identifier in `ios/Runner.xcodeproj`
3. Set provisioning profile

#### Build and Deploy

```bash
flutter build ios --release
```

### 4. Environment Configuration

Create `.env` file (not committed to version control):

```
APPWRITE_ENDPOINT=https://your-appwrite-domain.com/v1
APPWRITE_PROJECT_ID=your_project_id
APPWRITE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_firebase_project
ADMOB_APP_ID=your_admob_app_id
SENTRY_DSN=your_sentry_dsn
```

Update `lib/config/config.dart` to read from environment:

```dart
class Config {
  static const String APPWRITE_ENDPOINT = 'https://your-appwrite-endpoint.com/v1';
  static const String APPWRITE_PROJECT_ID = 'YOUR_PROJECT_ID';
  // ...
}
```

### 5. Security Hardening

#### Appwrite Security Settings

1. **Enable HTTPS only**
2. **Configure CORS:**
   - Add your domain to allowed origins
   - Restrict headers and methods

3. **Set up database permissions:**
   - Reviews: Public read, authenticated write
   - Users: Private, self-access only
   - Images: Public read, authenticated write

4. **Enable rate limiting:**
   ```bash
   # Limit requests to 100 per minute
   appwrite configure --rate-limit=100 --rate-limit-window=60
   ```

#### App Security

1. **Obfuscate code:**
   ```bash
   flutter build apk --obfuscate --split-debug-info=build/app/outputs
   ```

2. **Enable ProGuard for Android:**
   Update `android/app/build.gradle.kts`:
   ```kotlin
   buildTypes {
       release {
           minifyEnabled true
           proguardFiles getDefaultProguardFile('proguard-android-optimize.txt')
       }
   }
   ```

3. **Implement certificate pinning** for production Appwrite

### 6. Error Tracking & Analytics

#### Sentry Setup

```bash
flutter pub add sentry_flutter
```

Initialize in `main.dart`:

```dart
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'YOUR_SENTRY_DSN';
      options.environment = 'production';
    },
    appRunner: () => runApp(const MyApp()),
  );
}
```

#### Google Analytics

```bash
flutter pub add firebase_analytics
```

### 7. Monitoring & Maintenance

#### Database Backups

```bash
# Regular backups of Appwrite data
appwrite databases export --database-id reviews_db
```

#### Performance Monitoring

- Monitor API response times
- Track image upload performance
- Monitor coin system transactions
- Track user session duration

#### Logs

- Enable logging in Appwrite console
- Review error logs regularly
- Monitor authentication attempts

### 8. Deployment Checklist

- [ ] Update configuration with production endpoints
- [ ] Enable email verification
- [ ] Configure CORS properly
- [ ] Set up database indexes for reviews (on `link`, `user_id`, `$createdAt`)
- [ ] Enable HTTPS
- [ ] Set up SSL certificate
- [ ] Configure CDN for images
- [ ] Enable database backups
- [ ] Set up monitoring/alerts
- [ ] Configure error tracking (Sentry)
- [ ] Enable analytics
- [ ] Test all payment flows
- [ ] Test email notifications
- [ ] Load test database
- [ ] Security audit
- [ ] Create disaster recovery plan

### 9. Post-Deployment

#### Health Checks

```bash
# Monitor API health
curl -X GET https://your-appwrite-domain.com/v1/health

# Check database status
curl -X GET https://your-appwrite-domain.com/v1/databases/reviews_db
```

#### Performance Tuning

1. Enable caching headers
2. Optimize image serving with CDN
3. Set up database query indexes
4. Monitor and optimize slow queries

#### User Feedback

- Monitor app ratings
- Collect crash reports
- Track feature usage
- Gather user feedback

### 10. Scaling Considerations

As user base grows:

1. **Database Optimization**
   - Add indexes strategically
   - Archive old reviews
   - Implement caching layer (Redis)

2. **Storage**
   - Implement image resizing
   - Use CDN for images
   - Archive old user data

3. **API**
   - Implement rate limiting per user
   - Cache frequently accessed data
   - Load balance API requests

4. **Infrastructure**
   - Multi-region deployment
   - Database replication
   - Backup redundancy

---

## Support & Resources

- [Appwrite Documentation](https://appwrite.io/docs)
- [Flutter Deployment Guide](https://flutter.dev/docs/deployment)
- [Google Play Store Publishing](https://play.google.com/console)
- [Apple App Store Publishing](https://developer.apple.com/app-store/)
