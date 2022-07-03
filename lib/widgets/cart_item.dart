import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity
  });

  @override
  Widget build(BuildContext context) {
    final cartItemOptions = Provider.of<Cart>(context, listen: false);
    return Dismissible(//19_06: Support swipe to dismiss action
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(Icons.delete, color: Colors.white,),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
      ),
      direction: DismissDirection.endToStart, //19_06: Allow only right (end) to left (start) direction
      confirmDismiss: (direction) {
          //22_06: Show an alert dialog
        return showDialog( //Cause showDialog returns the future, the same type of confirmDismiss
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to remove the product?'),
              actions: <Widget> [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                        Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes'))
              ],
            ));
      },
      onDismissed: (direction){
        //19_06: check direction
        cartItemOptions.removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                    child: Text('\$$price')),
              ),
            ),
            title: Text('$title'),
            subtitle: Text('Total is: \$${price*quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
