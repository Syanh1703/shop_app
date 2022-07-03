import 'package:flutter/material.dart';
import '../screens/upload_product_screen.dart';
import '../screens/order_screen.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text(
              'Hello',
            ),
            automaticallyImplyLeading: false, //21_06: Never add a back button
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop',style: TextStyle(
              fontSize: 20,
            ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders', style: TextStyle(
              fontSize: 20,
            ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.orderScreenRouteName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Upload Product', style: TextStyle(
              fontSize: 20,
            ),
            ),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(UploadProductScreen.uploadProductRouteName);
            },
          ),
        ],
      ),
    );
  }
}
