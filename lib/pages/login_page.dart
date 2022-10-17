import 'dart:ffi';

import 'package:dhumketu_ecommerce_user/auth/auth_services.dart';
import 'package:dhumketu_ecommerce_user/models/user_model.dart';
import 'package:dhumketu_ecommerce_user/pages/product_list_page.dart';
import 'package:dhumketu_ecommerce_user/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
 static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final _emailContoller = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  String _errMsg = '';
  bool isLogin = true;

  @override
  void dispose() {
    _emailContoller.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formkey,
          child: ListView(
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _emailContoller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),

                ),
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'This filed must not be empty';
                  }
                  return null;
                },


              ),

              SizedBox(height: 10,),


              TextFormField(
                obscureText: _obscureText,
                controller: _passwordController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText; //true hole visibilityt off thakbe and click korle on hobe toggle hoye jabe
                        });
                      },
                    ),
                    hintText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),

                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'This filed must not be empty';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20,),

              ElevatedButton(
                  onPressed:(){
                     isLogin = true;
                     _loginUser();
                  },
                  child: Text('Login')),

              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New User ?'),
                  TextButton(
                      onPressed: (){
                        isLogin = false;
                        _loginUser();
                      },
                      child: Text('Register',style: TextStyle(fontSize: 18),)),
                ],
              ),
              Text(_errMsg),

            ],


          ),

        ),
      ),

    );
  }

  void _loginUser() async {

    if(_formkey.currentState!.validate()){
      //er dara bujasse jodi empty na thake,user kiso type krse kina
      try{
        User? user;
        //er dara bujasse user login button a press krse
        if(isLogin){
          //login krok or regester korok user er modde kiso ekta akhon dokbe
        user = await  AuthServices.loginUser(_emailContoller.text, _passwordController.text);
        }
        else{
          user = await AuthServices.registerUser(_emailContoller.text, _passwordController.text);

        }
        // user er modde akhon kiso na kiso dokse, tobe jawar age user er information golo niye database a save kore rakhbo
        if(user != null) {
          //todo create user and insert to db
          if(!isLogin) {
            final userModel = UserModel(
              userId: user.uid,
              email: user.email!,
              userCreationTime: user.metadata.creationTime!.microsecondsSinceEpoch,

              //userCreationTime: user.metadata.creationTime!.millisecondsSinceEpoch,
            );
            Provider.of<UserProvider>(context, listen: false)
                .addUser(userModel).then((value) {
              Navigator.pushReplacementNamed(context, ProductListPage.routeName);
            });
          } else {
            Navigator.pushReplacementNamed(context, ProductListPage.routeName);
          }
        }

      } on FirebaseAuthException catch (error) {
        setState(() {
          _errMsg = error.message!;
        });
      }

    }


  }
}


  /*
  1.login button and registration button er jonno amra ektai method rakhsi
  2.Login button a click korleo login user call hobe register button a click korleo same mehtod call hobe
  3. kon method call korle ki hobe seitar jonno amra ekta boolen value rakhsi
  4.isLogin name a amra ekta bool value rakhsi jar initial value hosse true
  5.jokhn user login button a click krbe isLogin er value ta true ei thakbe and login method ta call hobe
  6. R jokhon register button a click korbe islogin er value ra amra false kore dibo and loginuser method  ta call krbo

  7.loginUsr  method a asar por amra cheak kortasi filed gola empty kina,user kiso type krse kina ?
  8. islogin jodi true hoy tahole user login button a click krse false hole register button a clik krse
  9.user ta jokhon not= null hobe tar mane kiso na kiso dokse , ai document golo k niye akhon ami database a jabo
  tobe ai information golo ami always save rakhbo na , sodo matro register er khetre safe rakhbo

*/
