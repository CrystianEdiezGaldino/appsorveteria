import 'package:flutter/material.dart';
import '../../app/web/product_model.dart';

class AppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  PaymentMethod initialPaymentMethod = PaymentMethod.creditCard;
  bool showpage = false;
  List<Product> cartProducts = [];
  List<Product> products = [
    Product(
      image: 'svt01.jpg',
      description: 'Descrição do produto 1',
      value: 10.0,
    ),
    Product(
      image: 'svt02.jpg',
      description: 'Descrição do produto 2',
      value: 20.0,
    ),
    // Adicione mais produtos conforme necessário
  ];

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

  void showPage() {
    showpage = !showpage;
    notifyListeners();
  }

  // Métodos para atualizar os valores dos campos de entrada por ID
  void setNome(String userId, String value) {
    getFormValues(userId).nome = value;
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
