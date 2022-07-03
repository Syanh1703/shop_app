import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/authentication_screen.dart';
import '../screens/upload_product_screen.dart';
import '../screens/order_screen.dart';
import '../providers/order_providers.dart';
import '../screens/cart_screen.dart';
import 'screens/product_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import './providers/product_provider.dart';
import './models/cart.dart';
import './screens/create_product_screen.dart';
import './providers/auth_providers.dart';

void main() {
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget {

  // This widget is the root of your application.
  String appName = 'Shop App';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
        ChangeNotifierProvider(//15_06: Only work with object based on classes that user ChangeNotifier mixin
        create:(ctx)=>ProductsProvider(),
        ),
          //All child widgets can now listen to this Provider
          //value on used when the provider does not depend on the context
        ChangeNotifierProvider(create: (ctx) => Cart(),
        ),
      ChangeNotifierProvider(create: (ctx) => OrdersProvider()),

      //03_07: Auth Providers
      ChangeNotifierProvider(create: (ctx) => AuthProvider()),
    ],
        //18_06: Child receives all providers
        child: MaterialApp(
          title: appName,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: AuthScreen(),
          routes: {
            ProductOverviewScreen.prodOverviewRouteName : (ctx) => ProductOverviewScreen(),
            ProductDetailsScreen.productDetailRoute: (ctx) => ProductDetailsScreen(),
            CartScreen.cartScreenRoute: (ctx) => CartScreen(),
            OrderScreen.orderScreenRouteName:(ctx) => OrderScreen(),
            UploadProductScreen.uploadProductRouteName:(ctx) => UploadProductScreen(),
            CreateProductScreen.createProductRouteName:(ctx) => CreateProductScreen(),
          },
      ),
    );
  }
}
