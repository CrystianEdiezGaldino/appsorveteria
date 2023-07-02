import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/controllers/app_controller.dart';

import 'cartModal_widget.dart';

class CustomBottomAppBar extends StatelessWidget {
  final VoidCallback onAdvance;

  const CustomBottomAppBar({super.key, 
    required this.onAdvance,
  });

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
                  return Text('Itens no Carrinho: ${appController.cartProducts.length}');
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
