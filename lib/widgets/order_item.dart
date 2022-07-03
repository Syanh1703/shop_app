import 'package:flutter/material.dart';
import '../providers/order_providers.dart';
import 'package:intl/intl.dart';
import 'dart:math';


class OrderData extends StatefulWidget {
  final OrderItem orderData;

  OrderData(this.orderData);

  @override
  State<OrderData> createState() => _OrderDataState();
}

class _OrderDataState extends State<OrderData> {

  var _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              '\$${widget.orderData.totalAmount}'
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy H:m').format(widget.orderData.orderedDate),
            ),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less :Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          //21_06: Add more element in the List Tile
          if(_isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15
              ),
              child: SizedBox(
                height: min(widget.orderData.listOfCart.length*20.0 + 100.0, 60),
                child: ListView(
                  children: widget.orderData.listOfCart
                      .map(
                        (prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(prod.name, style: const TextStyle(
                              fontSize: 18,
                            ),
                            ),
                            Text('${prod.quantity}x \$${prod.pricePerProduct}', style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),)
                          ],
                        ),
                        ).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
