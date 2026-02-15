import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../widgets/review_list.dart';
import '../constants/color.dart';
import '../services/appwrite_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController userController = Get.find<UserController>();
  final TextEditingController searchController = TextEditingController();
  final appwrite = AppwriteService();
  
  String searchLink = '';

  Future<void> performSearch() async {
    final link = searchController.text.trim();
    if (link.isEmpty) {
      Get.snackbar('Error', 'Please enter a business link');
      return;
    }

    if (!userController.canSearch()) {
      Get.snackbar('Insufficient Coins', 'You need 2 coins to search');
      return;
    }

    try {
      await userController.performSearch(link);
      setState(() {
        searchLink = link;
      });
      Get.snackbar('Success', 'Search updated');
    } catch (e) {
      Get.snackbar('Error', 'Search failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        title: Text(
          'Trustify',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(() => Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: userController.user.value != null
                  ? Row(
                      children: [
                        Icon(Icons.attach_money, color: Colors.white, size: 20),
                        SizedBox(width: 4),
                        Text(
                          '${userController.user.value!.coins}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ),
          )),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () => Get.toNamed('/profile'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryGreen, AppColors.backgroundWhite],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find Honest Reviews',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Enter business link...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: AppColors.primaryGreen,
                          ),
                          onPressed: performSearch,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ReviewList(searchLink: searchLink.isNotEmpty ? searchLink : null),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Send a ping button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => client.ping(),
                        icon: const Icon(Icons.bolt),
                        label: const Text('Send a ping'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => Get.toNamed('/submit_review'),
                      icon: Icon(Icons.add),
                      label: Text('Submit Review'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentOrange,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
