import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';

class ProductDetailsScreen extends StatelessWidget {

  static const  productDetailRoute = '/product_detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(
        context,
        listen: false //15_06: Run whenever the object change => Not set up as an active listener
    ).findById(productId);
    //All the method in the provider should be in the provider file

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     loadedProduct.productName, style: const TextStyle(
      //     fontSize: 20,
      //   ),
      //   ),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              //08_07: Replace the App Bar in Scaffold
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.productName, style: const TextStyle(
                fontSize: 20,
              ),
              ),
              background:  Hero(
                tag: loadedProduct.productId,
                child: Image.network(loadedProduct.productImgUrl,
                  fit: BoxFit.contain,),
              ),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate(
             [ const SizedBox(height: 10,),
               Text('\$${loadedProduct.productPrice}', style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
                 textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(loadedProduct.productDes, style: const TextStyle(
                    fontSize: 20,
                  ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
             ],
          ),
          ),
        ],
      ),
    );
  }
}
