import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/appwrite_service.dart';

class UserController extends GetxController {
  final appwrite = AppwriteService();

  Rx<UserModel?> user = Rx<UserModel?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final currentUser = await appwrite.getCurrentUser();
      if (currentUser != null) {
        final userData = await appwrite.getUser(currentUser.$id);
        user.value = UserModel.fromJson(userData.data);
      }
    } catch (e) {
      errorMessage.value = 'Failed to load user: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCoins(int amount) async {
    try {
      if (user.value != null) {
        final newCoins = (user.value!.coins + amount).toInt();
        await appwrite.updateUserCoins(
          userId: user.value!.id,
          coins: newCoins,
        );
        user.value!.coins = newCoins;
        user.refresh();
      }
    } catch (e) {
      errorMessage.value = 'Failed to update coins: $e';
    }
  }

  bool canSearch() => user.value == null || user.value!.coins >= 2;

  Future<void> performSearch(String link) async {
    try {
      if (canSearch()) {
        if (user.value != null) {
          await updateCoins(-2);
        }
        // Proceed with search logic
      } else {
        errorMessage.value = 'Insufficient coins for search';
      }
    } catch (e) {
      errorMessage.value = 'Search failed: $e';
    }
  }
}
