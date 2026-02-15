import 'package:appwrite/appwrite.dart';
import '../config/config.dart';

final Client client = Client()
    .setProject(Config.appwriteProjectId)
    .setEndpoint(Config.appwritePublicEndpoint);

class AppwriteService {
  static final AppwriteService _instance = AppwriteService._internal();

  late Client _client;
  late Account _account;
  late Databases _databases;
  late Storage _storage;

  factory AppwriteService() {
    return _instance;
  }

  AppwriteService._internal();

  Future<void> initialize() async {
    print('Initializing Appwrite client...');
    _client = client;
    print('Client set: $_client');
    _account = Account(_client);
    print('Account initialized');
    _databases = Databases(_client);
    print('Databases initialized');
    _storage = Storage(_client);
    print('Storage initialized');
    print('Appwrite initialization complete');
  }

  Client get client => _client;
  Account get account => _account;
  Databases get databases => _databases;
  Storage get storage => _storage;

  // Auth methods
  Future<dynamic> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (e) {
      return null;
    }
  }

  // Database methods
  Future<dynamic> getReviews({
    List<String> queries = const [],
    int limit = 16,
  }) async {
    try {
      return await _databases.listDocuments(
        databaseId: 'reviews_db',
        collectionId: 'reviews',
        queries: [
          ...queries,
          Query.limit(limit),
          Query.orderDesc('\$createdAt'),
        ],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createReview({
    required String link,
    required String reviewText,
    required double rating,
    required String userId,
    List<String>? imageIds,
  }) async {
    try {
      return await _databases.createDocument(
        databaseId: 'reviews_db',
        collectionId: 'reviews',
        documentId: ID.unique(),
        data: {
          'link': link,
          'review_text': reviewText,
          'rating': rating,
          'user_id': userId,
          'images': imageIds ?? [],
          'helpful_count': 0,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getUser(String userId) async {
    try {
      return await _databases.getDocument(
        databaseId: 'reviews_db',
        collectionId: 'users',
        documentId: userId,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateUserCoins({
    required String userId,
    required int coins,
  }) async {
    try {
      return await _databases.updateDocument(
        databaseId: 'reviews_db',
        collectionId: 'users',
        documentId: userId,
        data: {'coins': coins},
      );
    } catch (e) {
      rethrow;
    }
  }

  // Storage methods
  Future<dynamic> uploadImage({
    required String filePath,
    required String bucketId,
  }) async {
    try {
      return await _storage.createFile(
        bucketId: bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: filePath),
      );
    } catch (e) {
      rethrow;
    }
  }

  String getImageUrl({
    required String bucketId,
    required String fileId,
  }) {
    return '${"https://cloud.appwrite.io/v1"}/storage/buckets/$bucketId/files/$fileId/view?project=YOUR_PROJECT_ID';
  }
}
