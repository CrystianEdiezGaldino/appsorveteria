import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorveteria/src/app/web/pages/products_page.dart';

import '../../../core/controllers/app_controller.dart';

class FormInPage extends StatelessWidget {
  const FormInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Consumer<AppController>(
                builder: (context, appController, _) {
                  return TextField(
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                    ),
                    onChanged: (value) {
                      appController.setNome(value);
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              Consumer<AppController>(
                builder: (context, appController, _) {
                  return TextField(
                    decoration: const InputDecoration(
                      labelText: 'Endereço',
                    ),
                    onChanged: (value) {
                      appController.setEndereco(value);
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              Consumer<AppController>(
                builder: (context, appController, _) {
                  return TextField(
                    decoration: const InputDecoration(
                      labelText: 'Número',
                    ),
                    onChanged: (value) {
                      appController.setNumero(value);
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              Consumer<AppController>(
                builder: (context, appController, _) {
                  return TextField(
                    decoration: const InputDecoration(
                      labelText: 'Complemento',
                    ),
                    onChanged: (value) {
                      appController.setComplemento(value);
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              Consumer<AppController>(
                builder: (context, appController, _) {
                  return TextField(
                    decoration: InputDecoration(
                      labelText: 'Celular',
                    ),
                    onChanged: (value) {
                      appController.setCelular(value);
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductListPage()),
                  );
                },
                child: Text('Iniciar Pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
