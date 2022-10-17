import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhumketu_ecommerce_user/auth/auth_services.dart';
import 'package:dhumketu_ecommerce_user/models/order_model.dart';
import 'package:dhumketu_ecommerce_user/models/user_model.dart';
import 'package:dhumketu_ecommerce_user/pages/product_list_page.dart';
import 'package:dhumketu_ecommerce_user/providers/order_provider.dart';
import 'package:dhumketu_ecommerce_user/providers/user_provider.dart';
import 'package:dhumketu_ecommerce_user/utils/constants.dart';
import 'package:dhumketu_ecommerce_user/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'order_sucessful_page.dart';

class CheackOutPage extends StatefulWidget {
  static const String routeName = '/cheackout';

  @override
  State<CheackOutPage> createState() => _CheackOutPageState();
}

class _CheackOutPageState extends State<CheackOutPage> {
  late CartProvider _cartProvider;
  late OrderProvider _orderProvider;
  late UserProvider _userProvider;
  String radioGroupValue = Payment.cod;
  final _addressController = TextEditingController();
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if(_isInit){
      _cartProvider = Provider.of<CartProvider>(context);
      _orderProvider = Provider.of<OrderProvider>(context);
      _userProvider = Provider.of<UserProvider>(context);
      _orderProvider.getOrderConstants();
      _userProvider.getCurrentUser(AuthServices.currentUser!.uid).then((user) => {
        if(user != null){
          if(user.deliveryAddress != null){
            setState((){
              _addressController.text = user.deliveryAddress!;
            })
          }
        }

      });

      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CheackOut'),),
      body: Column(
       crossAxisAlignment: CrossAxisAlignment.stretch,
       children: [
         Expanded(
           child: ListView(
             padding: EdgeInsets.all(10),
             children: [
               const Text('Your Items',style: TextStyle(fontSize: 20),),
               const Divider(height: 5,color: Colors.red,),
               Column(
                 mainAxisSize: MainAxisSize.min,
                 children:_cartProvider.cartList.map((cartModel) => ListTile(
                   title: Text(cartModel.productName),
                   trailing: Text('${cartModel.qty} X ${cartModel.price}'),
                 )).toList()
               ),
               Text('Order Summery', style: TextStyle(fontSize: 20),),
               const Divider(height: 5,color: Colors.red,),
               Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Cart Total'),
                       Text('$takaSymbol ${_cartProvider.cartItemsTotalPrice}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),),
                     ],
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Delivery Charge'),
                       Text('$takaSymbol ${_orderProvider.orderConstantsModel.deliveryCharge}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),),
                     ],
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Discount(${_orderProvider.orderConstantsModel.discount}%)'),
                       Text('-$takaSymbol${_orderProvider.getDiscountAmount(_cartProvider.cartItemsTotalPrice)}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)


                     ],
                   ),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Vat(${_orderProvider.orderConstantsModel.vat}%)'),
                       Text('$takaSymbol${_orderProvider.getTotalVatAmout(_cartProvider.cartItemsTotalPrice)}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                     ],
                   ),

                   const Divider(height: 5,color: Colors.red,),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Grand Total',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                       Text('$takaSymbol${_orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice)}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                     ],
                   ),

                   const SizedBox(height: 20,),
                   const Text('Set Delivery Address', style: TextStyle(fontSize: 20),),
                   const Divider(height: 1, color: Colors.black,),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: TextField(
                       controller: _addressController,
                       decoration: const InputDecoration(
                           border: OutlineInputBorder()
                       ),
                     ),
                   ),


                   const Text('Select Payment Method', style: TextStyle(fontSize: 20),),
                   const Divider(height: 1, color: Colors.black,),
                   Row(
                     children: [
                       Radio<String>(
                         groupValue: radioGroupValue,
                         value: Payment.cod,
                         onChanged: (value) {
                           setState(() {
                             radioGroupValue = value!;
                           });
                         },
                       ),
                       Text(Payment.cod)
                     ],
                   ),
                   Row(
                     children: [
                       Radio<String>(
                         groupValue: radioGroupValue,
                         value: Payment.online,
                         onChanged: (value) {
                           setState(() {
                             radioGroupValue = value!;
                           });
                         },
                       ),
                       const Text(Payment.online)
                     ],
                   ),




                 ],
               )


             ],
           ),
         ),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 8.0),
           child: ElevatedButton(
             child: const Text('PLACE ORDER'),
             onPressed: _saveOrder,
           ),
         )
       ],

        


      ),
    );
  }

  void _saveOrder() {
    if(_addressController.text.isEmpty) {
      showMsg(context, 'Please provide a delivery address');
      return;
    }
    _userProvider.updateDeliveryAddress(AuthServices.currentUser!.uid, _addressController.text);
     final orderModel = OrderModel(
      userId: AuthServices.currentUser!.uid,
      timestamp: Timestamp.now(),
      orderStatus: OrderStatus.pending,
      paymentMethod: radioGroupValue,
      discount: _orderProvider.orderConstantsModel.discount,
      deliveryCharge: _orderProvider.orderConstantsModel.deliveryCharge,
      vat: _orderProvider.orderConstantsModel.vat,
      deliveryAddress: _addressController.text,
      grandTotal: _orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice),
    );

    _orderProvider.addNewOrder(orderModel, _cartProvider.cartList).then((value) {
      _cartProvider.clearCart();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OrderSuccessfulPage()),
          ModalRoute.withName(ProductListPage.routeName));
      // kon page na pawa porjonto push korte thakbe seita
    });


  }

}
/*
1.cart er total er sathe  5% discount korar por ja asbe tar opor vat bosbe and tar sathe delivertcharge ta add hobe
grandTotal = cartTotal er sathe 5% discount

* */
/*
................delivery address er khetre


1. new user jokhon registration kore tokhon kinto amra new user er ekta object o database a patai dei
2. database er dike kheal korle dekhte parben seikhane delivery address o ase
3. amra jokhon reg krsi tokhon sodo email and user id niye database a rakhsi baki information kinto kisoi rakha hoy nai
4. kono kiso korar agei jodi se profile ta update kore rakhto tahole kinto ami r delivery address er aikhane
 kono kiso lekhtam na automically delivery address ta bose jeto
 5. ami delivery address k empty rakhbo ki rakhbo na ta depend krtase user er delivery address kon obostai ase tar opor

6.ekbar order complete hoye gele user cart list ta kinto empty kore dite hobe


* */