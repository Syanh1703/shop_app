import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/custom_route.dart';
import '../providers/auth_providers.dart';
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
              'App Menu',
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
              //Navigator.of(context).pushReplacementNamed(OrderScreen.orderScreenRouteName);
              Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx)=>OrderScreen(),));
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out', style: TextStyle(
              fontSize: 20,
            ),
            ),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context,listen: false).logOut();
            },
          )
        ],
      ),
    );
  }
}
