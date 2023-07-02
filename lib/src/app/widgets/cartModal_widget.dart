// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/controllers/app_controller.dart';

class CartModal extends StatelessWidget {
  const CartModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, appController, _) {
        final cartItemCount = appController.cartProducts.length;

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Itens do Carrinho',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: cartItemCount,
                itemBuilder: (context, index) {
                  final product = appController.cartProducts[index];
                  return ListTile(
                    leading: Image.asset(
                      product.image,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(product.description),
                    subtitle: Text('\$${product.value.toStringAsFixed(2)}'),
                    trailing: GestureDetector(
                      onTap: () {
                        appController.removeFromCart(product);
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
