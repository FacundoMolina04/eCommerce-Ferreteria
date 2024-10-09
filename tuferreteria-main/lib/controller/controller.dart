import 'dart:convert';

import 'package:ferreteria/models/login_response.dart';
import 'package:ferreteria/models/order_item.dart';
import 'package:ferreteria/models/product.dart';
import 'package:ferreteria/models/order.dart';
import 'package:ferreteria/models/cart_item.dart';
import 'package:ferreteria/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:http/http.dart' as http;

class Controller with ChangeNotifier {
  bool admin = false;
  User loggedUser = User(id: 0, email: '', name: '');
  String? token;
  List<Product> productos = [];
  String baseUrl = 'http://localhost:8889/api/v1';

  Future<bool> isAdmin() async {
    return admin;
  }

  Future<List<Product>> getProducts() async {
    try {
      //var url = Uri.parse('$baseUrl/products');

      var url = Uri.http("localhost:8889", 'api/v1/products');

      print("url $url");

      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      print("response $response");

      if (response.statusCode == 200) {
        var data =
            jsonDecode(response.body) as List;
            print("data $data");
        productos = data
            .map((item) => Product.fromJson(item))
            .toList(); 
        return productos;
      } else {
        print('Error fetching products: ${response.statusCode}');
        return [];
        
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }




  

  Future<Product?> getProduct(int id) async {
    try {
      var url = Uri.parse('$baseUrl/products/$id');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        print('Error fetching product: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      var url = Uri.parse('$baseUrl/products');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 200) {
        productos.add(Product.fromJson(jsonDecode(response.body)));
        print("Product added successfully");
        notifyListeners();
      } else {
        print('Error adding product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      var url = Uri.parse('$baseUrl/products');
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 200) {
        print("Product updated successfully");
        final index = productos.indexWhere((element) => element.id == product.id);
        productos[index] = product;
        notifyListeners();
      } else {
        print('Error updating product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      var url = Uri.parse('$baseUrl/products/$id');
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        print("Product deleted successfully");
        productos.removeWhere((element) => element.id == id);
        notifyListeners();
      } else {
        print('Error deleting product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }


  Future<List<Order>> getUserOrders() async {
    try {

      var payload = await FlutterSessionJwt.getPayload();
      var userId = payload["user_id"];

      var url = Uri.parse('$baseUrl/order/user/$userId');
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Order.fromJson(item)).toList();
      } else {
        print('Error fetching orders: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  Future<List<OrderItem>> getProductOrders(int id) async {
    try {
      var url = Uri.parse('$baseUrl/order/product/$id');
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        print("data $data");
        return data.map((item) => OrderItem.fromJson(item)).toList();
      } else {
        print('Error fetching product orders: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching product orders: $e');
      return [];
    }
  }

  Future<Order?> getOrderDetails(int orderId) async {
    try {
      var url = Uri.parse('$baseUrl/order/$orderId');
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        return Order.fromJson(jsonDecode(response.body));
      } else {
        print('Error fetching order details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching order details: $e');
      return null;
    }
  }


  Future<List<CartItem>> getCartItems() async {
    try {

      var payload = await FlutterSessionJwt.getPayload();
      var userId = payload["user_id"];
      var url = Uri.parse('$baseUrl/cart/$userId');
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => CartItem.fromJson(item)).toList();
      } else {
        print('Error fetching cart items: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching cart items: $e');
      return [];
    }
  }

  Future<void> addToCart(CartItem item) async {
    try {
  
      var payload = await FlutterSessionJwt.getPayload();
      var userId = payload["user_id"];
          var url = Uri.parse('$baseUrl/cart/$userId');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
    "productId": item.product.id,
    "quantity": item.quantity
}),
      );
      if (response.statusCode == 200) {
        print("Item added to cart");
        notifyListeners();
      } else {
        print('Error adding item to cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  Future<void> updateCartItem(CartItem item) async {
    try {
      var url = Uri.parse('$baseUrl/cart/${item.id}/${item.quantity}');
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(item.toJson()),
      );
      if (response.statusCode == 200) {
        print("Cart item updated");
        notifyListeners();
      } else {
        print('Error updating cart item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating cart item: $e');
    }
  }

  Future<void> removeFromCart(CartItem item) async {
    try {
      var url = Uri.parse('$baseUrl/cart/${item.product.id}/remove');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({"quantity": item.quantity}),
      );
      if (response.statusCode == 200) {
        print("Item removed from cart");
        notifyListeners();
      } else {
        print('Error removing item from cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }


  Future<void> register(String name, String email, String password) async {
    try {
      var url = Uri.parse('$baseUrl/register');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 201) {
        print("User registered successfully");
      } else {
        print('Error registering user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    try {
  
      var url = Uri.http("localhost:8889", 'api/v1/auth');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': "*"
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        String tokenRes = jsonDecode(response.body)["token"];
        await FlutterSessionJwt.saveToken(tokenRes);
      
        var payload = await FlutterSessionJwt.getPayload();
        admin = (payload["user_role"] == "ADMIN");
        print("admin $admin");
        token = tokenRes;
		productos = await getProducts();
    print("productos $productos");
        return LoginResponse(logged: true, token: tokenRes, isAdmin: admin);
      } else {
        return LoginResponse(logged: false, token: "", isAdmin: false);
      }
    } catch (e) {
      print('Error logging in: $e');
      return LoginResponse(logged: false, token: "", isAdmin: false);
    }
  }

  Future<void> buyCart() async { 

    var payload = await FlutterSessionJwt.getPayload();
    var userId = payload["user_id"];
    try {
      var url = Uri.parse('$baseUrl/order/$userId');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        print("Cart bought successfully");
        notifyListeners();
      } else {
        print('Error buying cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Error buying cart: $e');
    }

  }
}
