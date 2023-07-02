import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorveteria/src/app/web/pages/paymentPage.dart';

import '../../../core/controllers/app_controller.dart';
import '../../widgets/btappbar_widget.dart';


class ProductListPage extends StatelessWidget {
  final String idPedido;

  const ProductListPage({super.key, required this.idPedido});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, appController, _) {
        final formValues = appController.getFormValues(
            idPedido); // Obtém os valores do formulário do AppController com base no ID do pedido
        final nome = formValues.nome; // Obtém o nome do formulário

        return Scaffold(
          appBar: AppBar(
            title: Center(
                child: Text(
                    nome)), // Exibe o nome do formulário no centro da AppBar
          ),
          body: ListView.builder(
            itemCount: appController.products.length,
            itemBuilder: (context, index) {
              final product = appController.products[index];
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
                    child: const Text('+'),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: CustomBottomAppBar(
            onAdvance: () {
              // Lógica para avançar
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentPage(idPedido: idPedido)),
              );
            },
          ),
        );
      },
    );
  }
}
