import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int cartItemCount;
  final VoidCallback onAdvance;

  const CustomBottomAppBar({
    required this.cartItemCount,
    required this.onAdvance,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Itens no Carrinho: $cartItemCount'),
            ElevatedButton(
              onPressed: onAdvance,
              child: Text('Avançar'),
            ),
          ],
        ),
      ),
    );
  }
}
