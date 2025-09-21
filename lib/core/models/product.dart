class Product {
  final int id;
  final String title;
  final String type;
  final String genre;
  final String platform;
  final double price;
  final String company;
  final String? releasedAt;
  final double size;
  final String duration;
  final int ageRating;
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

  bool get isTrashed => deletedAt != null;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      genre: json['genre'] as String,
      platform: json['platform'] as String,
      price: (json['price'] as num).toDouble(),
      company: json['company'] as String,
      releasedAt: json['released_date'],
      size: json['size'] as double,
      duration: json['duration'] as String,
      ageRating: json['age_rating'] as int,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      sellerId: json['seller_id'] as int,
      createdAt: json['created_at'] as String,
      deletedAt: json['deleted_at'],
      featured: json['featured'] == 1 || json['featured'] == true,
    );
  }
}

class ProductValidation {
  static String? validTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Title is required';
    if (value.trim().length > 150) {
      return 'Title may not be greater than 150 characters';
    }
    return null;
  }

  static String? validDescription(String? value) {
    if (value == null || value.trim().isEmpty) return 'Description is required';
    if (value.trim().length > 2000) {
      return 'Description may not be greater than 2000 characters';
    }
    return null;
  }

  static String? validCompany(String? value) {
    if (value == null || value.trim().isEmpty) return 'Company is required';
    if (value.trim().length > 120) {
      return 'Company may not be greater than 120 characters';
    }
    return null;
  }

  static String? validDuration(String? value) {
    if (value == null || value.trim().isEmpty) return 'Duration is required';
    final v = value.trim();
    if (v.length > 20) return 'Duration may not be greater than 20 characters';
    final re = RegExp(r'^\d{1,3}h(?:\s?\d{1,2}m)?$', caseSensitive: false);
    if (!re.hasMatch(v)) return 'Duration must look like "12h 30m" or "5h".';
    return null;
  }

  static String? validPrice(String? value) {
    if (value == null || value.trim().isEmpty) return 'Price is required';
    final v = value.trim();
    final p = double.tryParse(v);
    if (p == null) return 'Enter a valid price';
    if (p < 0) return 'Price must be at least 0';
    if (p > 999999.99) return 'Price may not be greater than 999,999.99';
    return null;
  }

  static String? validSize(String? value) {
    if (value == null || value.trim().isEmpty) return 'Size is required';
    final v = value.trim();
    final n = double.tryParse(v);
    if (n == null) return 'Enter a numeric size';
    if (n < 0) return 'Size must be at least 0';
    if (n > 100000) return 'Size may not be greater than 100000';
    return null;
  }

  static String? validAgeRating(String? value) {
    if (value == null || value.trim().isEmpty) return 'Age rating is required';
    final v = value.trim();
    final n = int.tryParse(v);
    if (n == null) return 'Enter a whole number';
    if (n < 0 || n > 100) return 'Age rating must be between 0 and 100';
    return null;
  }

  static String? validType(String? value) {
    if (value == null || value.trim().isEmpty) return 'Type is required';
    final v = value.trim().toLowerCase();
    if (v != 'physical' && v != 'digital') {
      return 'Type must be Physical or Digital';
    }
    return null;
  }

  static String? validGenre(String? value) {
    if (value == null || value.trim().isEmpty) return 'Genre is required';
    final v = value.trim().toLowerCase();
    if (v != 'rpg' && v != 'shooter' && v != 'racing') {
      return 'Genre must be one of: Shooter, RPG, Racing';
    }
    return null;
  }

  static String? validPlatform(String? value) {
    if (value == null || value.trim().isEmpty) return 'Platform is required';
    final v = value.trim().toLowerCase();
    if (v != 'xbox' && v != 'pc' && v != 'ps4' && v != 'ps5') {
      return 'Platform must be one of: PC, XBOX, PS4, PS5';
    }
    return null;
  }

  static String? validReleasedDate(String? value) {
    if (value == null || value.trim().isEmpty) return "Released Date required";
    final v = value.trim();
    final iso = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!iso.hasMatch(v)) return 'Use format YYYY-MM-DD';
    final dt = DateTime.tryParse(v);
    if (dt == null) return 'Invalid date';
    if (!dt.isBefore(DateTime.now())) {
      return 'Released Date must be before today';
    }
    return null;
  }
}
