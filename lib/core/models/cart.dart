import 'product.dart';

class CartItem {
  final int id;
  final int userId;
  final int productId;
  final int quantity;
  final Product product;
  final String? createdAt;
  final String? updatedAt;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.product,
    this.createdAt,
    this.updatedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      product: Product.fromJson(json['product']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
