class UserModel {
  String id;
  String name;
  String email;
  int coins;
  int totalReviews;

  UserModel({
    required this.id,
    this.name = 'User',
    this.email = '',
    this.coins = 0,
    this.totalReviews = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['\$id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'User',
      email: json['email'] ?? '',
      coins: json['coins'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'coins': coins,
    'total_reviews': totalReviews,
  };
}
