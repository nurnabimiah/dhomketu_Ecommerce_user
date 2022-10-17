


import 'package:dhumketu_ecommerce_user/auth/auth_services.dart';
import 'package:dhumketu_ecommerce_user/db/db_helper.dart';
import 'package:dhumketu_ecommerce_user/models/order_constant_model.dart';
import 'package:dhumketu_ecommerce_user/models/order_model.dart';
import 'package:flutter/material.dart';

import '../models/cart_model.dart';

class OrderProvider extends ChangeNotifier{

  OrderConstantsModel orderConstantsModel = OrderConstantsModel();
  List<OrderModel> userOrderList = [];
  List<CartModel> orderDetailsList =[];


  void getOrderConstants() async {
    DBHelper.fetchOrderConstants().listen((snapshot) {
      if(snapshot.exists) {
        orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
     // print(".........................${orderConstantsModel}");
    });
  }

  num getDiscountAmount(num total) {
    return ((total * orderConstantsModel.discount) / 100);
    notifyListeners();
  }

  num getTotalVatAmout(num total){
    final totalAfterDiscount = total - getDiscountAmount(total);
    return ((totalAfterDiscount * orderConstantsModel.vat) / 100);
  }

  num getGrandTotal(num total){

    return (total -getDiscountAmount(total)) + getTotalVatAmout(total)+ orderConstantsModel.deliveryCharge;
  }

  // ekbar order complete hoye gele user er cart list ta kinto empty kore dite hobe
   Future <void> addNewOrder(OrderModel orderModel, List<CartModel> cartModels){
    return DBHelper.addNewOrder(orderModel, cartModels);
   }

   //user ja ja order krse tai sodo tole niye asbe
  void getUserOrders(String userId) async {
    DBHelper.fetchAllOrdersByUser(userId).listen((snapshot) {
      userOrderList = List.generate(snapshot.docs.length, (index) => OrderModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  // amra j order ta krsi tar full details amra tole niye asbo
  void getOrderDetails(String orderId) async {
    DBHelper.fetchAllOrderDetails(orderId).listen((snapshot) {
      orderDetailsList = List.generate(snapshot.docs.length, (index) => CartModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
}