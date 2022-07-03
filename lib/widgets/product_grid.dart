import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';

class ProductGridBuilder extends StatelessWidget {

  bool isFav = false;
  ProductGridBuilder(this.isFav);

  @override
  Widget build(BuildContext context) {
    //Data only changes when this provider is called
    final productsData = Provider.of<ProductsProvider>(context);//Only listen to ChangeNotifierProvider in main dart
    final productList = isFav ? productsData.favItems : productsData.item;
    return GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, //number of columns
      childAspectRatio: 3/2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10, //spaces between rows
    ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: productList[i] , //return a single product
        child: ProductItem(),
      ),
      itemCount: productList.length,
      padding: const EdgeInsets.all(20),);
  }
}