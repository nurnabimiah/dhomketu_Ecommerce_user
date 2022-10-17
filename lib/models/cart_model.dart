
class CartModel {
  String productId;
  String productName;
  num price;
  int qty;

  CartModel({
    required this.productId,
    required this.productName,
    required this.price,
    this.qty = 1});

  Map<String,dynamic> toMap() {
    var map = <String,dynamic>{
      'productId' : productId,
      'productName' : productName,
      'price' : price,
      'qty' : qty,
    };
    return map;
  }

  factory CartModel.fromMap(Map<String,dynamic> map) => CartModel(
    productId: map['productId'],
    productName: map['productName'],
    price: map['price'],
    qty: map['qty'],
  );
}

/*
1. cart a amra ekta product er ki ki information rakhbo
2. amra jokhon add button a click krbo amr kaj hosse sei product er id ,
sei product er nam tar price and defalut quantity niye amra ekta cart model er object create krbo
tarpor data base er cart collection er modde add kore dibo
* */