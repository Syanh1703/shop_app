
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../models/cart.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import '../providers/product_provider.dart';

enum FilterOptions{
  AllProducts,
  Favourites
}

class ProductOverviewScreen extends StatefulWidget {

  static const prodOverviewRouteName = '/product_overview';

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  final String appName = 'My Shop App';
  var _showFavProducts = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    //28_06: Does not work in function requires the context
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //18_06: Set listener for Cart

    return Scaffold(
      appBar: AppBar(
        title: Text(appName, style:
          const TextStyle(
            fontSize: 20,
          ),
        ),
        actions: <Widget>[
          //18_06: Use Badge to display the number
          Consumer<Cart>(
            builder: (BuildContext _, cartData, consumerChild) =>
              Badge(child: consumerChild!,
                  value: cartData.numberOfProducts.toString()
              ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.cartScreenRoute);
              },
            ),
          ),
          PopupMenuButton(itemBuilder: (_) => [
            //List of Widgets
            const PopupMenuItem(child: Text('Favourites', style:  TextStyle(fontSize: 18),), value: FilterOptions.Favourites,),
            const PopupMenuItem(child: Text('All products', style: TextStyle(fontSize: 18),), value: FilterOptions.AllProducts,)
          ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if(selectedValue == FilterOptions.Favourites){
                  //17_06: Show only the products in the list
                  _showFavProducts = true;
                }
                else{
                  //17_06: Show all the products
                  _showFavProducts = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading ? const Center(
          child: CircularProgressIndicator(),
      ) : ProductGridBuilder(
          _showFavProducts
      ),
    );
  }
}

