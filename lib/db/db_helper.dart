
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhumketu_ecommerce_user/models/cart_model.dart';
import 'package:dhumketu_ecommerce_user/models/order_model.dart';
import 'package:dhumketu_ecommerce_user/models/user_model.dart';

class DBHelper {

  static const _collectionUser = 'Users';
  static const _collectionProduct = 'Products';
  static const _collectionCategory = 'Categories';
  static const _collectionCart = 'Cart';
  static const _collectionOrderUtils = 'OrderUtils';
  static const _documentConstants = 'Constants';
  static const _collectionOrder = 'Order';
  static const _collectionOrderDetails = 'Order Details';



  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /*static Future<void> addNewUser(UserModel userModel){
   //document er name hobe ai user er user id ta
    return _db.collection(_collectionUser).doc(userModel.userId).set(userModel.toMap());
    // setMehtod ta return kore future void tai aitar return type future dewa ase
  }*/

  static Future<void> addNewUser(UserModel userModel) {
    return _db.collection(_collectionUser).doc(userModel.userId).set(
        userModel.toMap());
  }


  //product golo tole niye asbo
/*product golo tokhon tole niye asbo jokhon is availabe er value ta true hobe*/

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllProducts() =>
      _db.collection(_collectionProduct)
          .where('isAvailable', isEqualTo: true)
          .snapshots();

  // sodo matro ekta documents tole niye asbo
  static Stream<DocumentSnapshot<Map<String, dynamic>>> fetchProductByProductId(
      String productId) =>
      _db.collection(_collectionProduct).doc(productId).snapshots();

  //database a cart ta add korar jonno method
  static Future<void> addToCart(String userId, CartModel cartModel) {
    return _db.collection(_collectionUser)
        .doc(userId)
        .collection(_collectionCart)
        .doc(cartModel.productId)
        .set(cartModel.toMap());
  }


  static Future<void> updateCartQuantity(String userId, CartModel cartModel) {
    return _db.collection(_collectionUser).doc(userId)
        .collection(_collectionCart)
        .doc(cartModel.productId)
        .update({'qty': cartModel.qty});
  }

//cart ta k tole niye asbo
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchALlCartItem(
      String userId) =>
      _db.collection(_collectionUser)
          .doc(userId).collection(_collectionCart).snapshots();


// ekta item k remove korar jonno
  static Future<void> removeFromCart(String userId, String productId) {
    return _db.collection(_collectionUser)
        .doc(userId)
        .collection(_collectionCart)
        .doc(productId)
        .delete();
  }

  //clear cart

  static Future<void> removeAllItemsFromCart(String userId,
      List<CartModel> cartList) {
    final wb = _db.batch();
    for (var cart in cartList) {
      final cartDoc = _db.collection(_collectionUser).doc(userId)
          .collection(_collectionCart).doc(cart.productId);
      wb.delete(cartDoc);
    }
    return wb.commit();
  }


  //ekta matro constants k se tole niye asbe

  static Stream<DocumentSnapshot<Map<String, dynamic>>> fetchOrderConstants() =>
      _db.collection(_collectionOrderUtils).doc(_documentConstants).snapshots();


  //user er daliveryAddress empty ase ki na tar jonno user er all details tole niye jassi

  static Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserDetails(String userId) =>
      _db.collection(_collectionUser).doc(userId).get();
             //get mane future ja ekbar ei tole niye asbe


//.......................................update user............................

  static Future<void> updateDeliveryAddress(String address, String userId){
    return _db.collection(_collectionUser).doc(userId)
        .update({'deliveryAddress': address});
  }

 static Future<void> addNewOrder(OrderModel orderModel, List<CartModel> cartList){
    final wb = _db.batch();
    final orderDoc = _db.collection(_collectionOrder).doc();
    orderModel.orderId = orderDoc.id;
    wb.set(orderDoc,orderModel.toMap());
    for(var value in cartList ){
      final doc = orderDoc.collection(_collectionOrderDetails).doc(value.productId);
      wb.set(doc, value.toMap());
    }
  return wb.commit();
 }


  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllCategories() =>
      _db.collection(_collectionCategory).snapshots();

 // user j sob order krse ta tole anar jonno query

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllOrdersByUser(String userId) =>
      _db.collection(_collectionOrder).where('user_id', isEqualTo: userId).snapshots();

  // amra j order krsi tar details dekhanor jonno
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllOrderDetails(String orderId) =>
      _db.collection(_collectionOrder).doc(orderId).collection(_collectionOrderDetails).snapshots();


  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllProductsByCategory(String category) =>
      _db.collection(_collectionProduct)
          .where('isAvailable', isEqualTo: true)
          .where('category', isEqualTo: category)
          .snapshots();
}

