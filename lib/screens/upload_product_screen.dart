import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/create_product_screen.dart';
import '../providers/product_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/upload_product_item.dart';

class UploadProductScreen extends StatelessWidget {

  static const uploadProductRouteName = '/upload_product';
  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product', style: TextStyle(
          fontSize: 20,
        ),
        ),
        actions: <Widget>[
          IconButton(onPressed: (){
                Navigator.of(context).pushNamed(CreateProductScreen.createProductRouteName);
            }, icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _refreshPage(context),
        builder:(ctx,snapshot) => snapshot.connectionState == ConnectionState.waiting ? const Center(
          child: CircularProgressIndicator(),
        ) : RefreshIndicator(
          //28_06: Refresh the page to
          onRefresh: () => _refreshPage(context),
          child: Consumer<ProductsProvider>(
            builder: (ctx, productsData, _) => Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemBuilder: (_, index) => Column(
                children: <Widget>[
                  UploadProductItem(
                    id: productsData.item[index].productId,
                    title: productsData.item[index].productName,
                    des: productsData.item[index].productDes,
                    image: productsData.item[index].productImgUrl,
                    price: productsData.item[index].productPrice,),
                   const Divider(),
                ],
              ),
                itemCount: productsData.item.length,),
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
