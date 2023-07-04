import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/web/product_model.dart';
import '../services/list_produtos.dart';

class AppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   ProductService productService = ProductService();
   

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  PaymentMethod initialPaymentMethod = PaymentMethod.creditCard;
  bool showpage = false;
  List<Product> cartProducts = [];
  String idPedido ='';
  

  // Mapa para armazenar os valores dos campos de entrada por ID
  Map<String, FormValues> formValues = {};

  // Dados de pagamento
  PaymentMethod paymentMethod = PaymentMethod.creditCard;
  String changeAmount = '';

  // Dados do progresso do pedido
  List<String> orderStatus = [
    'Pedido Aceito',
    'Preparando seu Pedido',
    'Saiu para Entrega',
    'Pedido Finalizado',
  ];
  int currentStep = 0;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
void initProductService(Function(List<Product>) callback) {
  productService.fetchProductsFromFirebase();
  productService.addListener(() {
    callback(productService.products);
    notifyListeners();
  });
}

  void showPage() {
    showpage = !showpage;
    notifyListeners();
  }
  Future<void> fetchProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('produtos_pedido')
          .get();

      productService.products = snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (error) {
      print('Erro ao buscar os produtos: $error');
    }
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
      final newProductId = (int.parse(lastProductId) + 1).toString();
      return newProductId;
    }

    return '1'; // Caso não haja produtos cadastrados ainda
  }

  Future<void> createProduct(
      String product, String imagemLink, String description, String value) async {
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

      await fetchProducts(); // Atualiza a lista de produtos após a criação

      notifyListeners();
    } catch (error) {
      print('Erro ao cadastrar o produto: $error');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('produtos_pedido')
          .doc(productId)
          .delete();

      await fetchProducts(); // Atualiza a lista de produtos após a exclusão

      notifyListeners();
    } catch (error) {
      print('Erro ao remover o produto: $error');
    }
  }


  // Métodos para atualizar os valores dos campos de entrada por ID
  void setNome(String userId, String value) {
    getFormValues(userId).nome = value;
    notifyListeners();
  }
   void setIdPeido(String idpeido) {
    idPedido = idpeido;
    notifyListeners();
  }


  void setEndereco(String userId, String value) {
    getFormValues(userId).endereco = value;
    notifyListeners();
  }

  void setNumero(String userId, String value) {
    getFormValues(userId).numero = value;
    notifyListeners();
  }

  void setComplemento(String userId, String value) {
    getFormValues(userId).complemento = value;
    notifyListeners();
  }

  void setCelular(String userId, String value) {
    getFormValues(userId).celular = value;
    notifyListeners();
  }

  // Métodos para manipular o carrinho
  void addToCart(Product product) {
    cartProducts.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    cartProducts.remove(product);
    notifyListeners();
  }

  FormValues getFormValues(String userId) {
    if (!formValues.containsKey(userId)) {
      formValues[userId] = FormValues();
    }
    notifyListeners();
    return formValues[userId]!;
  }

  // Métodos para manipular os dados de pagamento
  void setPaymentMethod(PaymentMethod method) {
    paymentMethod = method;
    notifyListeners();
  }

  void setChangeAmount(String amount) {
    changeAmount = amount;
    notifyListeners();
  }
  int getCartItemCount(Product product) {
  final appController = Provider.of<AppController>(context as BuildContext, listen: false);
  return appController.cartProducts.where((item) => item == product).length;
}

  // Novo método para obter a forma de pagamento selecionada
  PaymentMethod getSelectedPaymentMethod() {
    return paymentMethod;
  }

  // Métodos para manipular o progresso do pedido
  void nextStep() {
    if (currentStep < orderStatus.length - 1) {
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void setCurrentStep(int step) {
    if (step >= 0 && step < orderStatus.length) {
      currentStep = step;
      notifyListeners();
    }
  }

  // Novo método para confirmar o recebimento do pedido
  void confirmRecebimentoPedido() {
    // Lógica para confirmar o recebimento do pedido
  }
}

class FormValues {
  String nome = '';
  String endereco = '';
  String numero = '';
  String complemento = '';
  String celular = '';
}

enum PaymentMethod {
  creditCard,
  debitCard,
  cash,
}
