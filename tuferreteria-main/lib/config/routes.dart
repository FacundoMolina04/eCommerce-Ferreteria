import 'package:flutter/material.dart';
import 'package:ferreteria/presentation/pages/login_page.dart';
import 'package:ferreteria/presentation/pages/register_page.dart';
import 'package:ferreteria/presentation/pages/product_list_page.dart';
import 'package:ferreteria/presentation/pages/product_detail_page.dart';
import 'package:ferreteria/presentation/pages/cart_page.dart';
import 'package:ferreteria/presentation/pages/order_history_page.dart';
import 'package:ferreteria/presentation/pages/new_product_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/products':
        return MaterialPageRoute(builder: (_) => const ProductListPage());
      case '/product_detail':
        final int productId = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => ProductDetailPage(productId: productId, isAdmin: false,));
      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartPage());
      case '/order_history':
        return MaterialPageRoute(builder: (_) => const OrderHistoryPage());
      case '/new_product':
        return MaterialPageRoute(builder: (_) => const NewProductPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}