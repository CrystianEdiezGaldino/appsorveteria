// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/controllers/app_controller.dart';


class StatusPedidoPage extends StatelessWidget {
  final String idPedido;

  const StatusPedidoPage({Key? key, required this.idPedido}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, appController, _) {
        final formValues = appController.getFormValues(idPedido);
        final cartProducts = appController.cartProducts;
        final PaymentMethod paymentMethod = appController.getSelectedPaymentMethod();
        final String changeAmount = appController.changeAmount;

        return Scaffold(
          appBar: AppBar(
            title: Text('Status do Pedido'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stepper(
                  currentStep: appController.currentStep,
                  onStepContinue: () {
                    appController.nextStep();
                  },
                  onStepCancel: () {
                    appController.previousStep();
                  },
                  steps: appController.orderStatus.map((status) {
                    return Step(
                      title: Text(status),
                      isActive: appController.orderStatus.indexOf(status) <= appController.currentStep,
                      state: appController.orderStatus.indexOf(status) < appController.currentStep
                          ? StepState.complete
                          : StepState.indexed,
                      content: SizedBox.shrink(),
                    );
                  }).toList(),
                ),
                SizedBox(height: 24),
                Text(
                  'Dados do Pedido',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Nome: ${formValues.nome}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Endereço: ${formValues.endereco}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Número: ${formValues.numero}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Complemento: ${formValues.complemento}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Celular: ${formValues.celular}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                Text(
                  'Produtos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
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
                SizedBox(height: 24),
                Text(
                  'Forma de Pagamento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  paymentMethod.toString().split('.').last, // Exibe apenas o nome da forma de pagamento selecionada
                  style: TextStyle(fontSize: 16),
                ),
                if (paymentMethod == PaymentMethod.cash)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'Valor do Troco',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'R\$ $changeAmount',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para confirmar o recebimento do pedido
                  },
                  child: Text('Confirmar Recebimento do Pedido'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
