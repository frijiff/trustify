import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart';
import '../controllers/user_controller.dart';
import '../constants/color.dart';

class SubmitReviewScreen extends StatefulWidget {
  @override
  _SubmitReviewScreenState createState() => _SubmitReviewScreenState();
}

class _SubmitReviewScreenState extends State<SubmitReviewScreen> {
  final Client client = Client()
      .setEndpoint('https://your-appwrite-endpoint.com/v1')
      .setProject('your-project-id');
  final Databases databases = Databases(Client());
  final Storage storage = Storage(Client());

  final TextEditingController linkController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  int rating = 1;
  List<String> imageIds = [];

  void submitReview() async {
    try {
      await databases.createDocument(
        databaseId: 'reviews_db',
        collectionId: 'reviews',
        documentId: ID.unique(),
        data: {
          'link': linkController.text,
          'review_text': textController.text,
          'rating': rating,
          'user_id': Get.find<UserController>().user.value!.id,
          'images': imageIds,
        },
      );
      Get.back();
      // Show success message
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Review'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: linkController,
              decoration: InputDecoration(labelText: 'Business Link'),
            ),
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Review Text'),
              maxLines: 3,
            ),
            Row(
              children: List.generate(5, (index) => IconButton(
                icon: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: AppColors.accentOrange,
                ),
                onPressed: () => setState(() => rating = index + 1),
              )),
            ),
            // Placeholder for image picker
            ElevatedButton(
              onPressed: () {}, // Implement image picker
              child: Text('Add Images'),
            ),
            ElevatedButton(
              onPressed: submitReview,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
