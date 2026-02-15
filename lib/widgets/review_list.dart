import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

class ReviewList extends StatefulWidget {
  final String? searchLink;

  ReviewList({this.searchLink});

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  late final Client client;
  late final Databases databases;

  List<Map<String, dynamic>> reviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    client = Client()
        .setEndpoint('https://your-appwrite-endpoint.com/v1')
        .setProject('your-project-id');
    databases = Databases(client);
    fetchReviews();
  }

  @override
  void didUpdateWidget(covariant ReviewList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchLink != oldWidget.searchLink) {
      fetchReviews();
    }
  }

  void fetchReviews() async {
    setState(() => isLoading = true);
    try {
      var response = await databases.listDocuments(
        databaseId: 'reviews_db',
        collectionId: 'reviews',
        queries: [
          if (widget.searchLink != null) Query.equal('link', widget.searchLink),
          Query.limit(16), // Page size set to 16
        ],
      );
      setState(() {
        reviews = response.documents.map((doc) => doc.data).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(review['review_text'] ?? ''),
            subtitle: Text('Rating: ${review['rating'] ?? 0} stars\nDate: ${review['\$createdAt'] ?? ''}'),
            // Add image display if available
          ),
        );
      },
    );
  }
}
