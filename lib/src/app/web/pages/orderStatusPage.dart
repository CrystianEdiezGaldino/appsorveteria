import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorveteria/src/app/web/pages/formIn_page.dart';


import '../../../core/controllers/app_controller.dart';

class StatusPedidoPage extends StatefulWidget {
final String idPedido;

const StatusPedidoPage({Key? key, required this.idPedido}) : super(key: key);

@override
_StatusPedidoPageState createState() => _StatusPedidoPageState();
}

class _StatusPedidoPageState extends State<StatusPedidoPage> {
@override
void initState() {
super.initState();
sendOrderData(); // Envie os dados do pedido assim que a página for carregada
}

Future<void> sendOrderData() async {
final appController = Provider.of<AppController>(context, listen: false);
final formValues = appController.getFormValues(widget.idPedido);
final cartProducts = appController.cartProducts;
final PaymentMethod paymentMethod = appController.getSelectedPaymentMethod();
final String changeAmount = appController.changeAmount;
try {
  await FirebaseFirestore.instance
  .collection('pedidos')
  .doc("doc_id")
  .collection('messages')
  .doc("msg_id")
  .set({
    'nome': formValues.nome,
    'endereco': formValues.endereco,
    'numero': formValues.numero,
    'complemento': formValues.complemento,
    'celular': formValues.celular,
    'produtos': cartProducts.map((product) => {
      'descricao': product.description,
      'valor': product.value,
    }).toList(),
    'formaPagamento': paymentMethod.toString().split('.').last,
    'troco': changeAmount,
  });

  print('Dados do pedido enviados com sucesso!');
} catch (error) {
  print('Erro ao enviar os dados do pedido: $error');
}
}

@override
Widget build(BuildContext context) {
return Consumer<AppController>(
builder: (context, appController, _) {
final formValues = appController.getFormValues(widget.idPedido);
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
            FutureBuilder(
              future: Future.delayed(Duration(seconds: 4)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ElevatedButton(
                    onPressed: null,
                    child: Text('Pedido Recebido'),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FormInPage()),
                      );
                    },
                    child: Text('Pedido Recebido'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  },
);
}
}