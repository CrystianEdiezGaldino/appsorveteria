// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/controllers/app_controller.dart';

import 'formIn_page.dart';
import 'orderStatus_Page.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appController = Provider.of<AppController>(context);
    String idPedido = '';
    final formValues = appController.getFormValues(appController.idPedido);
    return Consumer<AppController>(
      builder: (context, appController, _) {
        final formValues = appController.getFormValues(appController.idPedido);
        final cartProducts = appController.cartProducts;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Pagamento'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormInPage(),
                SizedBox(
                  height: 25.0,
                ),
                const Text(
                  'Dados do Pedido',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nome: ${formValues.nome}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Endereço: ${formValues.endereco}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Número: ${formValues.numero}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Complemento: ${formValues.complemento}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Celular: ${formValues.celular}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Produtos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = cartProducts[index];
                      final descricao =
                          product.descricao ?? 'Descrição não disponível';
                      final valor = product.valor ?? 'Valor não disponível';
                      final imagem = product.image; // URL da imagem

                      return FutureBuilder(
                        future: Future.delayed(Duration(
                            seconds: 2)), // Simulando tempo de carregamento
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Indicador de progresso circular enquanto aguarda o carregamento
                            return ListTile(
                              leading: CircularProgressIndicator(),
                              title: Text(descricao),
                              subtitle: Text('Price: \$${valor}'),
                            );
                          } else if (snapshot.hasError) {
                            // Tratamento de erro em caso de falha no carregamento
                            return ListTile(
                              title: Text('Erro ao carregar o item'),
                            );
                          } else {
                            // Conteúdo do ListTile após o carregamento
                            return ListTile(
                              leading: imagem != null
                                  ? Image.network(
                                      imagem,
                                      width: 50,
                                      height: 50,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return CircularProgressIndicator();
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons
                                            .error); // Ícone de erro em caso de falha ao carregar a imagem
                                      },
                                    )
                                  : Icon(Icons
                                      .image), // Ícone padrão caso a imagem não esteja disponível
                              title: Text(descricao),
                              subtitle: Text('Price: \$${valor}'),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Forma de Pagamento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Cartão de Crédito'),
                  leading: Radio(
                    value: PaymentMethod.creditCard,
                    groupValue: appController.getSelectedPaymentMethod(),
                    onChanged: (value) {
                      appController.setPaymentMethod(PaymentMethod.creditCard);
                    },
                    activeColor: Colors.blue,
                  ),
                ),
                ListTile(
                  title: const Text('Cartão de Débito'),
                  leading: Radio(
                    value: PaymentMethod.debitCard,
                    groupValue: appController.getSelectedPaymentMethod(),
                    onChanged: (value) {
                      appController.setPaymentMethod(PaymentMethod.debitCard);
                    },
                    activeColor: Colors.blue,
                  ),
                ),
                ListTile(
                  title: const Text('Dinheiro'),
                  leading: Radio(
                    value: PaymentMethod.cash,
                    groupValue: appController.getSelectedPaymentMethod(),
                    onChanged: (value) {
                      appController.setPaymentMethod(PaymentMethod.cash);
                    },
                    activeColor: Colors.blue,
                  ),
                ),
                if (appController.getSelectedPaymentMethod() ==
                    PaymentMethod.cash)
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Valor do Troco'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      appController.setChangeAmount(value);
                    },
                  ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para finalizar o pedido
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StatusPedidoPage(
                                idPedido: appController.idPedido,
                              )),
                    );
                  },
                  child: const Text('Finalizar Pedido'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
