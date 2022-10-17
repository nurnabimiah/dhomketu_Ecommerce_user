
import 'package:dhumketu_ecommerce_user/auth/auth_services.dart';
import 'package:dhumketu_ecommerce_user/db/db_helper.dart';
import 'package:dhumketu_ecommerce_user/models/product_model.dart';
import 'package:flutter/material.dart';

import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartList = [];

  void addToCart(ProductModel productModel) {
    final cartModel = CartModel(productId: productModel.id!,
        productName: productModel.name!,
        price: productModel.price!);
    DBHelper.addToCart(AuthServices.currentUser!.uid, cartModel);
  }

  void getALLCartItems() {
    DBHelper.fetchALlCartItem(AuthServices.currentUser!.uid).listen((event) {
      cartList = List.generate(event.docs.length, (index) =>
          CartModel.fromMap(event.docs[index].data()));
    });
  }

  bool isInCart(String id) {
    bool tag = false;
    for (var cart in cartList) {
      if (cart.productId == id) {
        tag = true;
        break;
      }
    }
    return tag;
  }
  void removeFromCart(String id) {
   // cartModel.qty = 0;
    DBHelper.removeFromCart(AuthServices.currentUser!.uid, id);
  }
  void removeFromCart2(CartModel cartModel) {
     //cartModel.qty = 0;
    DBHelper.removeFromCart(AuthServices.currentUser!.uid, cartModel.productId);
  }

  // total itemCountInCart
  int get totalItemInCart => cartList.length;


  void increaseQty(CartModel cartModel) {
    cartModel.qty += 1;

    DBHelper.updateCartQuantity(AuthServices.currentUser!.uid, cartModel);
    notifyListeners();
  }

  void decreaseQty(CartModel cartModel) {
    if (cartModel.qty > 1) {
      cartModel.qty -= 1;
      DBHelper.updateCartQuantity(AuthServices.currentUser!.uid, cartModel);
      notifyListeners();
    }
  }


/*
1.j cart model er + - button a click krbo sei cartmodel  pass kre dewa hobe
2. carttotal ber korar jonno
     cartList jeita ase er modde ekta loop chalabo protita cartmodel er quantity sathe price ta
     multipule kore add kore dibo
**/

num get cartItemsTotalPrice{
  num total = 0;
  //element mane holo ek ekta cartModel
  cartList.forEach((element) {
    total += element.qty * element.price;
  });
  return total;
}

// clearCart

void clearCart(){
  DBHelper.removeAllItemsFromCart(AuthServices.currentUser!.uid, cartList);
  notifyListeners();
}

}