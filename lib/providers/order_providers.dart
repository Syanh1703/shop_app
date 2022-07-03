import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/product.dart';
import 'package:shop_app/widgets/cart_item.dart';

class OrderItem{
  final String id;
  final double totalAmount;
  final List<CartItems> listOfCart;
  final DateTime orderedDate;

  OrderItem({
    required this.id,
    required this.totalAmount,
    required this.listOfCart,
    required this.orderedDate
});
}

class OrdersProvider with ChangeNotifier{
  List<OrderItem> _orders = [];

  List<OrderItem> get orders{
    return[..._orders];//20_06: Can edit order outside this class
  }

  Future<void> fetchAndSetOrders() async {
    final orderUrl = Uri.parse('https://shopapp-375a7-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(orderUrl);
    final List<OrderItem> loadedOrders = [];
    final extractedOrder = json.decode(response.body) as Map<String, dynamic>;
    if(extractedOrder == null){
      return;
    }
    extractedOrder.forEach((orderId, orderVal) {
      loadedOrders.add(OrderItem(
          id: orderId,
          totalAmount: orderVal['total price'],
          listOfCart: (orderVal['list of carts'] as List<dynamic>).map((index) => CartItems(
              cartId: index['id'],
              name: index['name'],
              quantity: index['quantity'],
              pricePerProduct: index['unit price'])
          ).toList(),
          orderedDate: DateTime.parse(orderVal['date']),
      ),
      );
    });
    _orders = loadedOrders.reversed.toList();//Reversed: The latest order on top
    notifyListeners();
    print(json.decode(response.body));
  }

  Future<void> addOrders(List<CartItems> cartProduct, double total) async {
    final orderUrl = Uri.parse('https://shopapp-375a7-default-rtdb.firebaseio.com/orders.json');
    final timestamp = DateTime.now();

    try{
      final response = await http.post(orderUrl, body: json.encode({
        'total price': total,
        'list of carts': cartProduct.map((index) => {
            'id': index.cartId,
            'name': index.name,
            'quantity': index.quantity,
            'unit price': index.pricePerProduct
        }).toList(),
        'date': timestamp.toIso8601String()
      })
      );
      _orders.insert(0, OrderItem(
          id: json.decode(response.body)['name'],
          totalAmount: total,
          listOfCart: cartProduct,
          orderedDate: timestamp
      ));
    }catch(error){
        throw error;
    }
    notifyListeners();
  }
}