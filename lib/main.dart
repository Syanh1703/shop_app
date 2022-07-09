import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/splash_screen.dart';
import '../screens/authentication_screen.dart';
import '../screens/upload_product_screen.dart';
import '../screens/order_screen.dart';
import '../providers/order_providers.dart';
import '../screens/cart_screen.dart';
import '../screens/product_overview_screen.dart';
import '../screens/product_detail_screen.dart';
import './providers/product_provider.dart';
import './models/cart.dart';
import './screens/create_product_screen.dart';
import './providers/auth_providers.dart';
import './helpers/custom_route.dart';

void main() {
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget {

  // This widget is the root of your application.
  String appName = 'Shop App';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      //03_07: Auth Providers
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(//15_06: Only work with object based on classes that user ChangeNotifier mixin
          update:(ctx,auth, previousProducts) => ProductsProvider(auth.token, auth.userId ,previousProducts == null ? [] : previousProducts.item),
          create: (ctx) => ProductsProvider('','',[]),
        ),
          //All child widgets can now listen to this Provider
          //value on used when the provider does not depend on the context

        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
            update: (_,auth,previousOrders) => OrdersProvider(auth.token, previousOrders == null ? [] : previousOrders.orders, auth.userId),
            create: (ctx) => OrdersProvider('',[], '')
        ),
        ChangeNotifierProvider(create: (ctx) => Cart(),
        ),
    ],
        //18_06: Child receives all providers
        child: Consumer<AuthProvider>(
          builder: (ctx, authData, _) => MaterialApp(
            title: appName,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  ///It is a map for applying multiple transitions
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                }
              )
            ),
            home: authData.isAuth ? ProductOverviewScreen() : FutureBuilder(
                builder: (ctx, logInStatus) => logInStatus.connectionState == ConnectionState.waiting ? const SplashScreen() :AuthScreen(),
                future: authData.tryAutoLogin(),
            ),
            routes: {
              ProductDetailsScreen.productDetailRoute: (ctx) => ProductDetailsScreen(),
              CartScreen.cartScreenRoute: (ctx) => CartScreen(),
              OrderScreen.orderScreenRouteName:(ctx) => OrderScreen(),
              UploadProductScreen.uploadProductRouteName:(ctx) => UploadProductScreen(),
              CreateProductScreen.createProductRouteName:(ctx) => CreateProductScreen(),
            },
          ),
        ),
    );
  }
}
