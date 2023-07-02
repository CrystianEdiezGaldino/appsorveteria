// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/controllers/app_controller.dart';

import 'orderStatusPage.dart';

class PaymentPage extends StatelessWidget {
  final String idPedido;

  const PaymentPage({Key? key, required this.idPedido}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, appController, _) {
        final formValues = appController.getFormValues(idPedido);
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
                      return ListTile(
                        title: Text(product.description),
                        subtitle: Text('Price: \$${product.value}'),
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
                if (appController.getSelectedPaymentMethod() == PaymentMethod.cash)
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Valor do Troco'),
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
                      MaterialPageRoute(builder: (context) => StatusPedidoPage(idPedido: idPedido,)),
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
