import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorveteria/src/app/web/pages/payment_Page.dart';

import '../../../core/controllers/app_controller.dart';
import '../../widgets/btappbar_widget.dart';
import '../product_model.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sorveteria"),
        centerTitle: true,
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
                final descricao = product.descricao ?? 'Descrição não disponível';
                final valor = product.valor ?? 'Valor não disponível';
                final imagem = product.image; // URL da imagem

                return Card(
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      child: imagem != null
                          ? Image.network(
                              imagem,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return const Icon(Icons.error);
                              },
                            )
                          : Icon(Icons.image, size: 50), // Ícone padrão caso a imagem não esteja disponível
                    ),
                    title: Text(descricao, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('\$${valor}', style: TextStyle(color: Colors.grey)),
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
            MaterialPageRoute(builder: (context) => const PaymentPage()),
          );
        },
      ),
    );
  }
}
