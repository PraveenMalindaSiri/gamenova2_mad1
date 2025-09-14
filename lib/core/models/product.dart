class Product {
  final int id;
  final String title;
  final String type;
  final String genre;
  final String platform;
  final double price;
  final String company;
  final String? releasedAt;
  final String size;
  final String duration;
  final String ageRating;
  final String description;
  final String imageUrl;
  final int sellerId;
  final String createdAt;
  final String? deletedAt;
  final bool featured;

  Product({
    required this.id,
    required this.title,
    required this.type,
    required this.genre,
    required this.platform,
    required this.price,
    required this.company,
    this.releasedAt,
    required this.size,
    required this.duration,
    required this.ageRating,
    required this.description,
    required this.imageUrl,
    required this.sellerId,
    required this.createdAt,
    this.deletedAt,
    required this.featured,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      genre: json['genre'] as String,
      platform: json['platform'] as String,
      price: (json['price'] as num).toDouble(),
      company: json['company'] as String,
      releasedAt: json['released_at'],
      size: json['size'] as String,
      duration: json['duration'] as String,
      ageRating: json['age_rating'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      sellerId: json['seller_id'] as int,
      createdAt: json['created_at'] as String,
      deletedAt: json['deleted_at'],
      featured: json['featured'] == 1 || json['featured'] == true,
    );
  }
}
