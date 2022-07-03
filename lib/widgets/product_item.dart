import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    return Consumer<Product>(
      builder: (ctx, product, child) =>  GridTile(child:
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.productDetailRoute,
              arguments: product.productId,
            );
          },
          child: Image.network(product.productImgUrl, fit: BoxFit.cover,),
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(product.isFavourite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              product.toggleFavBtn();
            },
            color: Colors.red,
          ),
          backgroundColor: Colors.black87,
          title: Text(product.productName, style: const TextStyle(
            fontSize: 15,
          ),
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              cart.addItemToCart(product.productId, product.productPrice, product.productName);
              //22_06: Info Popup to confirm from the use
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Add the item to cart successfully'),
                  duration: const Duration(seconds: 3),
                action: SnackBarAction(label: 'UNDO', onPressed: () {
                  cart.removeSingleItem(product.productId);
                },
                ),
              )
              );
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
