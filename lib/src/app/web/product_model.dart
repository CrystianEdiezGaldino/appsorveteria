class Product {
  String? image;

  String? idProduto;
  String? tituloproduto;
  String? descricao;
  String? valor;

  Product(
      {required this.idProduto,
      required this.image,
      required this.tituloproduto,
         required this.descricao,
      required this.valor});
  Product.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    valor = json['valor'];
    idProduto = json['id_produto'];
    descricao = json['descricao'];
    descricao = json['titulo_produto'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['valor'] = valor;
    data['id_produto'] = idProduto;
    data['descricao'] = descricao;
    data['titulo_produto'] = tituloproduto;

    return data;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      image: map['image'],
      valor: map['valor'],
      idProduto: map['id_produto'],
      descricao: map['descricao'],
      tituloproduto: map['titulo_produto'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'valor': valor,
      'id_produto': idProduto,
      'descricao': descricao,
      'titulo_produto': tituloproduto,
    };
  }
}
