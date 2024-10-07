import 'package:flutter/material.dart';
import 'package:ferreteria/presentation/pages/order_detail_page.dart';
import 'package:ferreteria/controller/controller.dart';
import 'package:ferreteria/models/order.dart';
import 'package:provider/provider.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {

  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    _ordersFuture = controller.getUserOrders();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Compras'),
      ),
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay órdenes disponibles.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                return ListTile(
                  title: Text('Orden #${order.id}'),
                  subtitle: Text('${order.user.id} - ${order.date}'),
                  trailing: Text('\$${order.totalAmount.toStringAsFixed(2)}'),
                  
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderDetailPage(orderId: order.id),
                    ));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:ferreteria/controller/controller.dart';
// import 'package:ferreteria/models/order.dart';
// import 'package:ferreteria/models/order_item.dart';
// import 'package:provider/provider.dart';

// class OrderHistoryPage extends StatefulWidget {
//   const OrderHistoryPage({super.key});

//   @override
//   State<OrderHistoryPage> createState() => _OrderHistoryPageState();
// }

// class _OrderHistoryPageState extends State<OrderHistoryPage> {
//   late Future<List<dynamic>> _ordersFuture;
//   late Future<bool> _isAdminFuture;

//   @override
//   void initState() {
//     super.initState();
//     final controller = Provider.of<Controller>(context, listen: false);
//     _isAdminFuture = controller.isAdmin();
//     _ordersFuture = _isAdminFuture.then((isAdmin) {
//       return isAdmin ? controller.getProductOrders() : controller.getUserOrders();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Historial de Compras'),
//       ),
//       body: FutureBuilder<List<dynamic>>(
//         future: _ordersFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No hay órdenes disponibles.'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final item = snapshot.data![index];
//                 if (item is Order) {
//                   return ListTile(
//                     title: Text('Orden #${item.id}'),
//                     subtitle: Text('Fecha: ${item.date}'),
//                     trailing: Text('Cliente: ${item.user.id}'),
//                   );
//                 } else if (item is OrderItem) {
//                   return ListTile(
//                     title: Text('Orden #${item.orderId}'),
//                     subtitle: Text('Producto: ${item.product.name} - Cantidad: ${item.quantity}'),
//                     trailing: Text('\$${item.purchaseUnitPrice.toStringAsFixed(2)}'),
//                   );
//                 } else {
//                   return const SizedBox.shrink();
//                 }
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }