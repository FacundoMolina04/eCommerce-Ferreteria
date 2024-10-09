

import 'package:ferreteria/models/cart_item.dart';
import 'package:ferreteria/models/user.dart';

class Order {
  final int id;
  final User user;
  final DateTime date;
  final int quantity;
  final double totalAmount;
  final List<CartItem>? items;

  Order({
    required this.id,
    required this.user,
    required this.date,
    required this.quantity,
    required this.totalAmount,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      user: User.fromJson(json['user']),
      date: DateTime(
        json['date'][0],
        json['date'][1],
        json['date'][2],
        json['date'][3],
        json['date'][4],
        json['date'][5],
        json['date'][6] ~/ 1000000, 
      ),
      quantity: json['quantity'] ?? 0,
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartItem.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'date': [
        date.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
        date.second,
        date.microsecond * 1000, 
      ],
      'quantity': quantity,
      'totalAmount': totalAmount,
      'items': items?.map((item) => item.toJson()).toList(),
    };
  }
}