import 'package:gamenova2_mad1/core/models/product.dart';

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double price;
  final String? digitalcode;
  final bool isDigital;
  final Product product;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    this.digitalcode,
    required this.isDigital,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      digitalcode: json['digitalcode'] as String?,
      isDigital: json['isDigital'] as bool,
      product: Product.fromJson(json['product']),
    );
  }
}
