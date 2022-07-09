import 'package:flutter/material.dart';
import '../providers/order_providers.dart';
import 'package:intl/intl.dart';
import 'dart:math';


class OrderData extends StatefulWidget{
  final OrderItem orderData;

  OrderData(this.orderData);

  @override
  State<OrderData> createState() => _OrderDataState();
}

class _OrderDataState extends State<OrderData> with SingleTickerProviderStateMixin{
  final int _durationLength = 200;


  var _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: _durationLength),
      curve: Curves.easeInBack,
      height: _isExpanded ?  min(widget.orderData.listOfCart.length * 20.0 + 110, 250) : 105,
      child: Card(
        margin: EdgeInsets.all(10),
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
                ),
                child: AnimatedContainer(
                      duration: Duration(milliseconds: _durationLength),
                      height: _isExpanded ? min(widget.orderData.listOfCart.length*20.0 + 10 , 50) : 0,
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
        ),
    );
  }
}
