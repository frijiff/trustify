/// Production configuration constants
class Config {
  // Appwrite Configuration
  static const String appwriteProjectId = '6990e81f00023e2464a9';
  static const String appwriteProjectName = 'Trustify';
  static const String appwritePublicEndpoint = 'https://fra.cloud.appwrite.io/v1';
  
  // Database Configuration
  static const String DATABASE_ID = 'reviews_db';
  static const String REVIEWS_COLLECTION = 'reviews';
  static const String USERS_COLLECTION = 'users';
  
  // Storage Configuration
  static const String IMAGES_BUCKET = 'review_images';
  
  // Feature Flags
  static const bool ENABLE_ANALYTICS = true;
  static const bool ENABLE_CRASH_REPORTING = true;
  
  // Coin Configuration
  static const int SEARCH_COIN_COST = 2;
  static const int INITIAL_COINS = 10;
  static const int COINS_PER_HELPFUL_REVIEW = 1;
  
  // Pagination
  static const int PAGE_SIZE = 16;
  
  // API Timeouts (in seconds)
  static const int REQUEST_TIMEOUT = 30;
  
  // Feature Limits
  static const int MAX_IMAGES_PER_REVIEW = 5;
  static const int MAX_REVIEW_LENGTH = 1000;
}
