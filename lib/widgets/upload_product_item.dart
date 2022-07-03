import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/create_product_screen.dart';
import '../providers/product_provider.dart';

class UploadProductItem extends StatelessWidget {

  final String id;
  final String title;
  final String des;
  final String image;
  final double price;

  UploadProductItem({
    required this.id,
    required this.title,
    required this.des,
    required this.image,
    required this.price,
});

  @override
  Widget build(BuildContext context) {
    final scaffoldContext = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(image),
      ),
      trailing: SizedBox(
        width: 100,
        height: 50,
        child: Row(
          children: <Widget>[
            IconButton(onPressed: (){
              //25_06: Edit the product by forwarding the id
              Navigator.of(context).pushNamed(CreateProductScreen.createProductRouteName,
              arguments: id);
              print(id);
            },
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.secondary,),
            IconButton(onPressed: () async {
                //clear the product
              try{
                  await Provider.of<ProductsProvider>(context, listen: false).deleteProduct(id);
              }catch(error){
                  scaffoldContext.showSnackBar(const SnackBar(content: Text('Deleting failed', textAlign: TextAlign.center,),));
              }
            },
                icon: const Icon(Icons.delete),
                  color: Theme.of(context).errorColor),
          ],
        ),
      ),
      title: SizedBox(
        width: 100,
        height: 50,
        child: Column(
          children: <Widget>[
            Text(title, style: const TextStyle(
              fontSize: 20,
            ),
            ),
            Text('\$$price', style: const TextStyle(
              fontSize: 20,
            ),)
          ],
        ),
      ),
    );
  }
}
