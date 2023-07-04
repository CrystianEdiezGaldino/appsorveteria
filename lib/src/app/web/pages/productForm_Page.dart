import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sorveteria/src/app/web/product_model.dart';

import '../../../core/responsive.dart';

class ProductFormPage extends StatefulWidget {
  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _imagemController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _productController.dispose();
    _imagemController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<String> getLastProductId() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('produtos_pedido')
        .orderBy('idProduto', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final lastProduct = snapshot.docs.first;
      final lastProductId = lastProduct.data()['idProduto'] as String;
      final newProductId = (int.parse(lastProductId) + 2).toString();
      return newProductId;
    }

    return '1'; // Caso não haja produtos cadastrados ainda
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String product = _productController.text;
      final String imagemLink = _imagemController.text;
      final String description = _descriptionController.text;
      final String value = _valueController.text;

      final newProductId = await getLastProductId();

      final newProduct = Product(
        idProduto: newProductId,
        image: imagemLink,
        descricao: description,
        valor: value,
        tituloproduto: product,
      );

      try {
        await FirebaseFirestore.instance
            .collection('produtos_pedido')
            .add(newProduct.toMap());

        setState(() {});

        _productController.clear();
        _descriptionController.clear();
        _valueController.clear();
        _imagemController.clear();
      } catch (error) {
        print('Erro ao cadastrar o produto: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Produto'),
      ),
      body: Responsive(
        mobile: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _productController,
                        decoration: const InputDecoration(labelText: 'Produto'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome do produto';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Descrição'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a descrição do produto';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _valueController,
                        decoration: const InputDecoration(labelText: 'Valor'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o valor do produto';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _imagemController,
                        decoration: const InputDecoration(
                          labelText: 'Link da Imagem',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o Link da Imagem';
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Salvar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('produtos_pedido')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Erro ao buscar os produtos');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final products = snapshot.data!.docs
                      .map((doc) =>
                          Product.fromMap(doc.data() as Map<String, dynamic>))
                      .toList();

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final title =
                          product.tituloproduto ?? "Sem título cadastrado";
                      final description =
                          product.descricao ?? "Sem descrição cadastrada";
                      final value = product.valor ?? "Sem valor cadastrado";

                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            product.image!,
                            width: 50,
                            height: 50,
                          ),
                          title: Text(title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(description),
                              Text('Valor: $value'),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              try {
                                // Remove o produto do Firebase
                                await FirebaseFirestore.instance
                                    .collection('produtos_pedido')
                                    .doc(product.idProduto)
                                    .delete();
                              } catch (error) {
                                print('Erro ao remover o produto: $error');
                              }
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _productController,
                        decoration: const InputDecoration(labelText: 'Produto'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome do produto';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Descrição'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a descrição do produto';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _valueController,
                        decoration: const InputDecoration(labelText: 'Valor'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o valor do produto';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _imagemController,
                        decoration:
                            const InputDecoration(labelText: 'Link da Imagem'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o Link da Imagem';
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Salvar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('produtos_pedido')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Erro ao buscar os produtos');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final products = snapshot.data!.docs
                      .map((doc) =>
                          Product.fromMap(doc.data() as Map<String, dynamic>))
                      .toList();

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final title =
                          product.tituloproduto ?? "Sem título cadastrado";
                      final description =
                          product.descricao ?? "Sem descrição cadastrada";
                      final value = product.valor ?? "Sem valor cadastrado";

                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            product.image!,
                            width: 50,
                            height: 50,
                          ),
                          title: Text(title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(description),
                              Text('Valor: $value'),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              try {
                                // Remove o produto do Firebase
                                await FirebaseFirestore.instance
                                    .collection('produtos_pedido')
                                    .doc(product.idProduto)
                                    .delete();
                              } catch (error) {
                                print('Erro ao remover o produto: $error');
                              }
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
