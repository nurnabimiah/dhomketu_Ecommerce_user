import 'package:dhumketu_ecommerce_user/db/db_helper.dart';
import 'package:dhumketu_ecommerce_user/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{

  Future<void> addUser(UserModel userModel) {
    return DBHelper.addNewUser(userModel);
  }

 Future <UserModel?> getCurrentUser(String userId) async{
   final snapshot =   await DBHelper.fetchUserDetails(userId);
   if(!snapshot.exists){
     return null;
   }
   return UserModel.fromMap(snapshot.data()!);

}
 Future<void> updateDeliveryAddress(String userId, String address)=>
     DBHelper.updateDeliveryAddress(address, userId);



}