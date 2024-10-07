import 'package:ferreteria/models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  int id;

  CartItem({
    required this.product,
    required this.quantity,
    required this.id,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'id': id,
    };
  }
}