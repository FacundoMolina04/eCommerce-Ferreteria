import 'package:ferreteria/controller/controller.dart';
import 'package:ferreteria/models/product.dart';
import 'package:ferreteria/presentation/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:ferreteria/presentation/widgets/product_card.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:provider/provider.dart'; 

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<bool> _isAdminFuture;
  late Future<List<Product>> products;
  @override
  void initState() {
    super.initState();
    _isAdminFuture = Provider.of<Controller>(context, listen: false).isAdmin(); 
    products = Provider.of<Controller>(context, listen: false).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Ferretería'),
        actions: [
          FutureBuilder<bool>(
            future: _isAdminFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData && !snapshot.data!) {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/order_history');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/cart');
                      },
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink(); 
              }
            },
          ),

            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FlutterSessionJwt.saveToken(''); 
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              },
            )

        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: controller.productos.isEmpty
                ? const Center(child: Text('No hay productos disponibles.'))
                : FutureBuilder<bool>(
                    future: _isAdminFuture, 
                    builder: (context, adminSnapshot) {
                      if (adminSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (adminSnapshot.hasError) {
                        return const Center(child: Text('Error al verificar permisos de administrador.'));
                      } else if (adminSnapshot.hasData) {
                        final isAdmin = adminSnapshot.data!; 
                        return GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: controller.productos.length, 
                          itemBuilder: (context, index) {
                            final product = controller.productos[index]; 
                            return ProductCard(
                              name: product.name ,
                              price: product.price,
                              image: product.image,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(
                                    productId: product.id,
                                    isAdmin: isAdmin, 
                                  ),
                                ));
                              },
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('Error al cargar la información de administrador.'));
                      }
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FutureBuilder<bool>(
        future: _isAdminFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink(); 
          } else if (snapshot.hasData && snapshot.data!) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('/new_product');
              },
            );
          } else {
            return const SizedBox.shrink(); 
          }
        },
      ),
    );
  }
}
