import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/controllers/app_controller.dart';
import '../../widgets/btappbar_widget.dart';
import '../product_model.dart';
import 'nextpagetest.dart';

class ProductListPage extends StatelessWidget {
  final List<Product> products = [
    Product(
      image: 'path_to_image_1',
      description: 'Descrição do produto 1',
      value: 10.0,
    ),
    Product(
      image: 'path_to_image_2',
      description: 'Descrição do produto 2',
      value: 20.0,
    ),
    // Adicione mais produtos conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, appController, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Lista de Produtos'),
          ),
          body: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                child: ListTile(
                  leading: Image.asset(
                    product.image,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(product.description),
                  subtitle: Text('\$${product.value.toStringAsFixed(2)}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      appController.addToCart(product);
                    },
                    child: Text('+'),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: CustomBottomAppBar(
            cartItemCount: appController.cartProducts.length,
            onAdvance: () {
              // Lógica para avançar
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NextPage()),
              );
            },
          ),
        );
      },
    );
  }
}
