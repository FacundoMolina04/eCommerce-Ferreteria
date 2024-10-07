import 'package:ferreteria/models/product.dart';

class OrderItem {
  int id;
  int orderId;
  Product product;
  int quantity;
  double purchaseUnitPrice;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.product,
    required this.quantity,
    required this.purchaseUnitPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['orderId'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      purchaseUnitPrice: json['purchaseUnitPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'product': product.toJson(),
      'quantity': quantity,
      'purchaseUnitPrice': purchaseUnitPrice,
    };
  }
}