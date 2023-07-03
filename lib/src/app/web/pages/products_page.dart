// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorveteria/src/app/web/pages/payment_Page.dart';

import '../../../core/controllers/app_controller.dart';
import '../../widgets/btappbar_widget.dart';
import '../product_model.dart';

class ProductListPage extends StatefulWidget {
  final String idPedido;

  const ProductListPage({Key? key, required this.idPedido}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
    
    final appController = Provider.of<AppController>(context, listen: false);
    appController.initProductService((List<Product> productList) {
      setState(() {
        appController.productService.products = productList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appController = Provider.of<AppController>(context);
    final formValues = appController.getFormValues(widget.idPedido);
    final nome = formValues.nome;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(nome)),
      ),
      body: Consumer<AppController>(
        builder: (context, appController, _) {
          // Verificar se a lista de produtos já foi carregada
          if (appController.productService.products.isEmpty) {
            // Exibir um indicador de carregamento enquanto os produtos estão sendo buscados
            return const Center(child: CircularProgressIndicator());
          } else {
            // A lista de produtos está pronta, exibir os produtos
            return ListView.builder(
              itemCount: appController.productService.products.length,
              itemBuilder: (context, index) {
                final product = appController.productService.products[index];
                return Card(
                  child: ListTile(
                    leading: Image.asset(
                      product.image!,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(product.descricao!),
                    subtitle: Text('\$${product.valor}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        appController.addToCart(product);
                      },
                      child: const Text('+'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomAppBar(
        onAdvance: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PaymentPage(idPedido: widget.idPedido)),
          );
        },
      ),
    );
  }
}
