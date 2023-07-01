import 'package:flutter/material.dart';

import '../../app/web/product_model.dart';

class AppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  bool showpage = false;
  List<Product> cartProducts = [];

  // Mapa para armazenar os valores dos campos de entrada por ID
  Map<String, FormValues> formValues = {};

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void showPage() {
    showpage = !showpage;
    notifyListeners();
  }

  // Métodos para atualizar os valores dos campos de entrada por ID
  void setNome(String userId, String value) {
    _getFormValues(userId).nome = value;
    notifyListeners();
  }

  void setEndereco(String userId, String value) {
    _getFormValues(userId).endereco = value;
    notifyListeners();
  }

  void setNumero(String userId, String value) {
    _getFormValues(userId).numero = value;
    notifyListeners();
  }

  void setComplemento(String userId, String value) {
    _getFormValues(userId).complemento = value;
    notifyListeners();
  }

  void setCelular(String userId, String value) {
    _getFormValues(userId).celular = value;
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

  FormValues _getFormValues(String userId) {
    if (!formValues.containsKey(userId)) {
      formValues[userId] = FormValues();
    }
    print(formValues[userId]);
    notifyListeners();
    return formValues[userId]!;
  }
}

class FormValues {
  String nome = '';
  String endereco = '';
  String numero = '';
  String complemento = '';
  String celular = '';
}
