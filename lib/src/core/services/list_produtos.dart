// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../app/web/product_model.dart';

class ProductService extends ChangeNotifier {
  List<Product> products = [];

  Future<List<Product>> fetchProductsFromFirebase() async {
    try {
      // Obtenha a referência para a coleção 'produtos_pedido' no Firebase
      CollectionReference productsRef = FirebaseFirestore.instance.collection('produtos_pedido');

      // Faça a consulta para obter todos os documentos da coleção
      QuerySnapshot productDocs = await productsRef.get();

      // Verifique se existem documentos na coleção
      if (productDocs.size > 0) {
        // Limpe a lista de produtos existente
        products.clear();

        // Itere sobre os documentos e obtenha os dados de cada um
        for (var productDoc in productDocs.docs) {
          // Obtém os dados do documento
          Map<String, dynamic> data = productDoc.data() as Map<String, dynamic>;

          // Crie uma instância de Product com os dados obtidos
          Product product = Product(
            image: data['image'] ?? 'Sem imagem',
            descricao: data['descricao'] ?? 'sem descrição',
            valor: data['valor'] ?? 'sem valor',
            idProduto: data['id_produto'] ?? 'sem id cadastrado', 
            tituloproduto: data['titulo_produto'] ?? 'sem titulo cadastrado', 
          );

          // Adicione o produto à lista
          products.add(product);
        }

        // Notifique os ouvintes de que a lista de produtos foi atualizada
        notifyListeners();
      }

      // Retorne a lista de produtos atualizada
      return products;
    } catch (error) {
      // Trate qualquer erro que ocorrer durante a busca dos produtos
      print('Erro ao buscar os produtos: $error');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }
}
