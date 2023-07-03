import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sorveteria/src/app/web/product_model.dart';

class ProductFormPage extends StatefulWidget {
  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _productController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String product = _productController.text;
      final String description = _descriptionController.text;
      final String value = _valueController.text;

      // Crie uma instância do modelo de produto com os dados do formulário
      final newProduct = Product(
        idProduto: '1', // Defina o ID do produto como desejar
        image: 'nome_da_imagem', // Defina o nome da imagem como desejar
        descricao: description,
        valor: value,
      );

      try {
        // Adicione o novo produto ao Firebase
        await FirebaseFirestore.instance
            .collection('produtos_pedido')
            .add(newProduct.toMap());

        // Atualize a lista de produtos
        setState(() {});

        // Limpe os campos do formulário
        _productController.clear();
        _descriptionController.clear();
        _valueController.clear();
      } catch (error) {
        // Trate qualquer erro que ocorrer durante o envio dos dados
        print('Erro ao cadastrar o produto: $error');
      }
    }
  }

  void _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Produto'),
      ),
      body: Row(
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
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Salvar'),
                    ),
                    IconButton(
                      onPressed: _selectImage,
                      icon: Icon(Icons.image),
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
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          product.image!,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(product.descricao!),
                        subtitle: Text(product.valor!),
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
    );
  }
}
