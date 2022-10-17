
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhumketu_ecommerce_user/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

class ProductDetailsPage extends StatefulWidget {
 static const String routeName = '/product_details';

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductProvider _productProvider;
  String? _productId;
  String? _productName;


  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    _productId = argList[0];
    _productName = argList[1];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_productName!),),

      body: Center(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _productProvider.getProductByProductId(_productId!),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              final product = ProductModel.fromMap(snapshot.data!.data()!);
              return Stack(
                children: [
                  ListView(
                    children: [
                      product.imageDownloadUrl == null ?
                      Image.asset('images/imagenotavailable.png', width: double.infinity, height: 250, fit: BoxFit.cover,) :
                      FadeInImage.assetNetwork(
                        image: product.imageDownloadUrl!,
                        placeholder: 'images/imagenotavailable.png',
                        width: double.infinity,
                        fadeInDuration: const Duration(seconds: 3),
                        fadeInCurve: Curves.bounceInOut,
                        height: 250,
                        fit: BoxFit.cover,
                      ),

                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey, width: 2)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sale Price'),
                            Text('BDT ${product.price}', style: TextStyle(fontSize: 20),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            if(snapshot.hasError) {
              return const Text('Failed to fetch data');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),

    );
  }
}
/*
1. amra j Producter list send krlam sei ta amra receive krlam
2. amra j productId ta pelam sei productId diye database thekhe sodo matro products collection thekhe
ekta document ei tole niye aste hobe jar product id amra jani. database er product id tai hosse document id

* */