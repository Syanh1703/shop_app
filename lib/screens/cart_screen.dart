import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_providers.dart';
import '../models/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const String cartScreenRoute = '/cart_screen';

  @override
  Widget build(BuildContext context) {

    const String totalCart = 'Total:';
    const String screenName = 'Cart Details';
    final carts = Provider.of<Cart>(context, listen: false);
    final orders = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          screenName, style:  TextStyle(
          fontSize: 20,
        ),
        ),
      ),
      body: Column(
        children:<Widget> [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget> [
                  const Text(totalCart, style: TextStyle(
                    fontSize: 25,
                  ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text('\$${carts.totalMoney.toStringAsFixed(2)}', style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  //Button to place the order
                  OrderButton(carts: carts, orders: orders),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
              child: ListView.builder(
                itemCount: carts.cartItems.length,
                itemBuilder: (ctx, index) => CartItem(id: carts.cartItems.values.toList()[index].cartId,
                    productId: carts.cartItems.keys.toList()[index],
                    title: carts.cartItems.values.toList()[index].name,
                    price: carts.cartItems.values.toList()[index].pricePerProduct,
                    quantity: carts.cartItems.values.toList()[index].quantity),
              )
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.carts,
    required this.orders,
  }) : super(key: key);

  final Cart carts;
  final OrdersProvider orders;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoadingCart = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.carts.totalMoney > 0.0 || _isLoadingCart==true) ? () async {
        setState(() {
          _isLoadingCart = true;
        });
        //20_06: Add orders to the order screen
        await widget.orders.addOrders(widget.carts.cartItems.values.toList()
            , widget.carts.totalMoney);
        setState(() {
          _isLoadingCart = false;
        });
        widget.carts.clearProducts();
      } : null, child: _isLoadingCart ? CircularProgressIndicator() : Text('ORDER', style: TextStyle(
      fontSize: 15,
    ),
    ),
    );
  }
}
