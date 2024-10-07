// import 'package:ferreteria/controller/controller.dart';
// import 'package:ferreteria/models/cart_item.dart';
// import 'package:ferreteria/models/order.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class OrderDetailPage extends StatelessWidget {
//   final Order order;
//   OrderDetailPage({super.key, required this.order});

//   // Mock data for the order


//   @override
//   Widget build(BuildContext context) {
    
//     final controller = Provider.of<Controller>(context);
//     int totalProducts = order.products.length;
//     double totalAmount = order.products.fold(0, (sum, product) => sum + (product.quantity * product.product.price));

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('Orden #${order.id}'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           Text(
//             '$totalProducts Productos',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Fecha: ${order.date}',
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 24),
//           ...order.products.map<Widget>((product) => _buildProductItem(product)),
//           const SizedBox(height: 24),
//           const Divider(thickness: 1),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Total',
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 '\$${totalAmount.toStringAsFixed(2)}',
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductItem(CartItem product) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: Colors.blue[50],
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(Icons.image, size: 40, color: Colors.blue[200]),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   product.product.name,
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
              
//                 const SizedBox(height: 4),
//                 Text(
//                   '${product.quantity} x \$${product.product.price.toStringAsFixed(2)}',
//                   style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             '\$${(product.quantity * product.product.price).toStringAsFixed(2)}',
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:ferreteria/controller/controller.dart';
import 'package:ferreteria/helpers/image_converter.dart';
import 'package:ferreteria/models/cart_item.dart';
import 'package:ferreteria/models/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatelessWidget {
  final int orderId;
  OrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Orden #$orderId'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<Order?>(
        future: controller.getOrderDetails(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No se encontraron detalles de la orden.'));
          } else {
            final order = snapshot.data!;
            int? totalProducts = order.items?.length;
            double totalAmount = order.items!.fold(0, (sum, product) => sum + (product.quantity * product.product.price));

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '$totalProducts Productos',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fecha: ${order.date}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),

                Text(
                  'Cliente: ${order.user.name} ID: ${order.user.id}', 
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ...order.items!.map<Widget>((product) => _buildProductItem(product)),
                const SizedBox(height: 24),
                const Divider(thickness: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildProductItem(CartItem product) {
      var decodedImg = dataFromBase64String(product.product.image);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
                              child: product.product.image.isNotEmpty 
                    ? Image.memory(
                        decodedImg, 
                        fit: BoxFit.cover, 
                        width: double.infinity, 
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: 50, color: Colors.grey[400]);
                        },
                      )
                    : Icon(Icons.image, size: 50, color: Colors.grey[400]),
                
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.quantity} x \$${product.product.price.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            '\$${(product.quantity * product.product.price).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}