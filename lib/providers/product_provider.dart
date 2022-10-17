
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhumketu_ecommerce_user/db/db_helper.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier{

  List<ProductModel> productList = [];

  void getAllProducts(){

    DBHelper.fetchAllProducts().listen((event) {
      productList = List.generate(event.docs.length,
              (index) =>ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
      
    });


  }


  void getAllProductsByCategory(String category) {
    DBHelper.fetchAllProductsByCategory(category).listen((event) {
      productList = List.generate(event.docs.length, (index) => ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }


  // ekta matro documents se tole niye asbe
  //sora sori stream hisabe return kore dissi kothao store koire rakhtasi na

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProductByProductId(String productId) {
    return DBHelper.fetchProductByProductId(productId);
  }

}