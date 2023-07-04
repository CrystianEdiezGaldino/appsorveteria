import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/controllers/app_controller.dart';

import 'cartModal_widget.dart';

class CustomBottomAppBar extends StatelessWidget {
  final VoidCallback onAdvance;

  const CustomBottomAppBar({Key? key, required this.onAdvance});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _showCartModal(context),
              child: Consumer<AppController>(
                builder: (context, appController, _) {
                  return Row(
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Itens no Carrinho: ${appController.cartProducts.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: onAdvance,
              child: const Text('Avançar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCartModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const CartModal();
      },
    );
  }
}
