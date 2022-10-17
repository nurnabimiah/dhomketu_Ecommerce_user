
import 'package:dhumketu_ecommerce_user/auth/auth_services.dart';
import 'package:dhumketu_ecommerce_user/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';
import 'cheackout_page.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart_page';

  //const CartPage({Key? key}) : super(key: key);


  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  late CartProvider _cartProvider;
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context,listen: true);
    _productProvider = Provider.of<ProductProvider>(context,listen: true);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                primary: Colors.white
            ),
            child: Text('CLEAR'),
            onPressed: () {
              _cartProvider.clearCart();
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartProvider.cartList.length,
              itemBuilder: (context, index) {
                final model = _cartProvider.cartList[index];
                return ListTile(
                  title: Text(model.productName),
                  subtitle: Text('$takaSymbol${model.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          _cartProvider.decreaseQty(model);
                        },
                      ),
                      Text('${model.qty}'),
                      IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: () {

                          _cartProvider.increaseQty(model);
                        },
                      ),
                      
                      IconButton(
                          onPressed:(){
                            _cartProvider.removeFromCart2(model);
                          },
                          icon: Icon(Icons.delete))
                      
                    ],
                  ),
                );
              },
            ),
          ),
          Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total: $takaSymbol${_cartProvider.cartItemsTotalPrice}', style: TextStyle(fontSize: 18),),
                  TextButton(
                    child: const Text('Checkout'),
                    onPressed: _cartProvider.totalItemInCart == 0 ? null
                        : () {
                      Navigator.pushNamed(context, CheackOutPage.routeName);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/*
* 1.cartList er size ta jodi zero thake tahole cheackout ta disiable thakbe
* 2.cart er item jodi zero hoy tahole amra null pass krbo na hoy n method call kore amra cheackOut page jabo
* */

/*
void showEmailVerficationAlert() {
  showDialog(context: context, builder: (context) => AlertDialog(
    title: const Text('Unverified User!'),
    content: const Text('Your email is not verified yet. Please click the SEND button below to receive a verification mail'),
    actions: [
      TextButton(
        child: const Text('CLOSE'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      TextButton(
        child: const Text('SEND'),
        onPressed: () {
          Navigator.pop(context);
          AuthService.sendVerificationMail().then((value) {
            //showMsg(context, 'Mail sent. Pleae check your inbox');
            print('Mail Sent');
          }).catchError((error) {
            throw error;
          });
        },
      ),

    ],
  ));
}
}
*/


/*
* 1.amra j discount ta disi ta kinto total amount er opor disi, onek ecommerce app a dekhben product er opor discount
 dibe.
 * jodi product a discount thake card a jokhon add krbo tokhon discount price tai add hobe baki sob kiso ager mothon cholte thakbe
 * product er opor discount thakle aita kinto admin ei set krbe
 * amader ja kora ochid products j collection ta jar vitore product golo admin add kre
  aikhane r ekta item rakha ochid discount ja admin thekhe add krte hobe. aita hobe product er indivisul discount.
  2. amra j discount ta disi ta kinto overall er opor discount
  3.Normally dekha jai j order er amount besi hoy tokhon jeye apni discount dite paren
  4. cart total er amount jodi 2k er besi hoy tahole discount ta applicable hobe amonta kinto krte pari
   kinto product er discount jodi thake cart a add houar time ei kinto asbe
  *

  *
 *
*
*
*
* */