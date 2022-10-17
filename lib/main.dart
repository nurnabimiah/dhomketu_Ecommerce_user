

import 'package:dhumketu_ecommerce_user/pages/cart_page.dart';
import 'package:dhumketu_ecommerce_user/pages/cheackout_page.dart';
import 'package:dhumketu_ecommerce_user/pages/launcher_page.dart';
import 'package:dhumketu_ecommerce_user/pages/login_page.dart';
import 'package:dhumketu_ecommerce_user/pages/order_details_page.dart';
import 'package:dhumketu_ecommerce_user/pages/order_sucessful_page.dart';
import 'package:dhumketu_ecommerce_user/pages/product_details_page.dart';
import 'package:dhumketu_ecommerce_user/pages/product_list_page.dart';
import 'package:dhumketu_ecommerce_user/pages/user_order_list_page.dart';
import 'package:dhumketu_ecommerce_user/providers/cart_provider.dart';
import 'package:dhumketu_ecommerce_user/providers/order_provider.dart';
import 'package:dhumketu_ecommerce_user/providers/product_provider.dart';
import 'package:dhumketu_ecommerce_user/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      home: LauncherPage(),
      routes: {
        LoginPage.routeName:(context)=>LoginPage(),
        ProductListPage.routeName:(context) => ProductListPage(),
        CartPage.routeName:(context) => CartPage(),
        ProductDetailsPage.routeName:(context) => ProductDetailsPage(),
        LauncherPage.routeName:(context) => LauncherPage(),
        CheackOutPage.routeName:(context) => CheackOutPage(),
        OrderSuccessfulPage.routeName:(context) => OrderSuccessfulPage(),
        UserOrderListPage.routeName:(context) => UserOrderListPage(),
        OrderDetailsPage.routeName:(context) => OrderDetailsPage(),

      },

    );
  }
}

