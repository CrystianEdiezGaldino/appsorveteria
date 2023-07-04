import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sorveteria/src/app/web/pages/products_page.dart';

import '../../../core/controllers/app_controller.dart';

class FormInPage extends StatefulWidget {
  const FormInPage({Key? key}) : super(key: key);

  @override
  _FormInPageState createState() => _FormInPageState();
}

class _FormInPageState extends State<FormInPage> {
  int formCounter = 1;

  final nomeController = TextEditingController();
  final enderecoController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();
  final celularController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    enderecoController.dispose();
    numeroController.dispose();
    complementoController.dispose();
    celularController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userId = 'P${formCounter.toString().padLeft(6, '0')}';

    return Consumer<AppController>(
      builder: (context, appController, _) {
        return SingleChildScrollView(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                  onChanged: (value) {
                    appController.setNome(userId, value);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: enderecoController,
                  decoration: const InputDecoration(
                    labelText: 'Endereço',
                  ),
                  onChanged: (value) {
                    appController.setEndereco(userId, value);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: numeroController,
                  decoration: const InputDecoration(
                    labelText: 'Número',
                  ),
                  onChanged: (value) {
                    appController.setNumero(userId, value);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: complementoController,
                  decoration: const InputDecoration(
                    labelText: 'Complemento',
                  ),
                  onChanged: (value) {
                    appController.setComplemento(userId, value);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: celularController,
                  decoration: const InputDecoration(
                    labelText: 'Celular',
                  ),
                  onChanged: (value) {
                    appController.setCelular(userId, value);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String userId =
                        'P${formCounter.toString().padLeft(6, '0')}';
                    final now = DateTime.now();
                    final formattedDate =
                        DateFormat('yyyyMMdd-HHmm').format(now);
                    final celular = celularController.text;
                    userId = '$celular-$formattedDate-$userId';

                    final appController =
                        Provider.of<AppController>(context, listen: false);

                    appController.setNome(userId, nomeController.text);
                    appController.setEndereco(
                        userId, enderecoController.text);
                    appController.setNumero(userId, numeroController.text);
                    appController.setComplemento(
                        userId, complementoController.text);
                    appController.setCelular(userId, celularController.text);
                     appController.setIdPeido(userId);
                    formCounter++;
                

                   
                  },
                  child: const Text('Confirmar dados para Entrega'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
