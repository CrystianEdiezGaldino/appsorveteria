import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/controllers/app_controller.dart';

class CartModal extends StatelessWidget {
  const CartModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appController = Provider.of<AppController>(context);
    final cartProducts = appController.cartProducts;
    final cartItemCount = cartProducts.length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // Adicione a lógica para mostrar os itens do carrinho aqui
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Itens do Carrinho',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Adicione a lógica para fechar o modal do carrinho aqui
                  },
                  icon: Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cartItemCount,
              itemBuilder: (context, index) {
                final product = cartProducts[index];

                final descricao =
                    product.descricao ?? 'Descrição não disponível';
                final valor = product.valor ?? 'Valor não disponível';

                return ListTile(
                  leading: product.image != null
                      ? FutureBuilder(
                          future: Future.delayed(Duration(
                              seconds:
                                  1)), // Simulação de tempo de carregamento
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.image!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }
                          },
                        )
                      : Icon(
                          Icons.image,
                          size: 50,
                        ),
                  title: Text(
                    descricao,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'R\$ $valor',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      appController.removeFromCart(product);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
