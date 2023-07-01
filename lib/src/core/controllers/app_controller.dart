import 'package:flutter/material.dart';

import '../../app/web/pages/products_page.dart';
import '../../app/web/product_model.dart';

class AppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  bool showpage = false;
  List<Product> cartProducts = [];

  // Propriedades para armazenar os valores dos campos de entrada
  String nome = '';
  String endereco = '';
  String numero = '';
  String complemento = '';
  String celular = '';

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void showPage() {
    showpage = !showpage;
    notifyListeners();
  }

  // Métodos para atualizar os valores dos campos de entrada
  void setNome(String value) {
    nome = value;
    notifyListeners();
  }

  void setEndereco(String value) {
    endereco = value;
    notifyListeners();
  }

  void setNumero(String value) {
    numero = value;
    notifyListeners();
  }

  void setComplemento(String value) {
    complemento = value;
    notifyListeners();
  }

  void setCelular(String value) {
    celular = value;
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
}
