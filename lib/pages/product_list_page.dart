
import 'package:dhumketu_ecommerce_user/customwidgets/main_drawer.dart';
import 'package:dhumketu_ecommerce_user/customwidgets/product_item.dart';
import 'package:dhumketu_ecommerce_user/pages/cart_page.dart';
import 'package:dhumketu_ecommerce_user/providers/cart_provider.dart';
import 'package:dhumketu_ecommerce_user/providers/order_provider.dart';
import 'package:dhumketu_ecommerce_user/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = '/productList';

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late ProductProvider _productProvider;
  late CartProvider _cartProvider;
  late OrderProvider orderProvider;


  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    _cartProvider = Provider.of<CartProvider>(context);
    orderProvider = Provider.of<OrderProvider>(context);
    _productProvider.getAllProducts();
    _cartProvider.getALLCartItems();
    orderProvider.getOrderConstants();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(title: Text('Product List'),
      actions: [
        IconButton(
            onPressed: ()=>Navigator.pushNamed(context, CartPage.routeName),
            icon: Icon(Icons.shopping_cart),
        )],
      ),

      body: GridView.count(
          crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 0.75, // 1/2 width jodi 1 hoy height hobe tar double
        children: _productProvider.productList.map((e) => ProductItem(e)).toList(),

      )
    );
  }
}
