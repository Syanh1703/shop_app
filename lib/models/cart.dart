import 'package:flutter/material.dart';

class CartItems{
  //Define how cart should look like
  final String cartId;
  final String name;
  final int quantity;
  final double pricePerProduct;

  CartItems({
    required this.cartId,
    required this.name,
    required this.quantity,
    required this.pricePerProduct});
}

class Cart with ChangeNotifier{
  //Key is the product id
  Map<String, CartItems> _cartItems = {};

  Map<String, CartItems> get cartItems{
    return {..._cartItems};
}

int get numberOfProducts{
    return _cartItems == null ? 0 : _cartItems.length;
}

double get totalMoney{
    var total = 0.0;
    _cartItems.forEach((key, cartItem) {
      total += cartItem.pricePerProduct * cartItem.quantity;
    });
    return total;
}

  void addItemToCart(String productId, double price, String title){
    //18_06: Check if item is available
    if(_cartItems.containsKey(productId)){
      //change quantity because the product is already in the list
      _cartItems.update(productId, (existingItem) => CartItems(
          cartId: existingItem.cartId,
          name: existingItem.name,
          quantity: existingItem.quantity + 1,
          pricePerProduct: existingItem.pricePerProduct));
    }
    else{
      //Add the item for the first time
      _cartItems.putIfAbsent(productId, () => CartItems(
          cartId: DateTime.now().toString(),
          name: title,
          quantity: 1,
          pricePerProduct: price),);
    }
    notifyListeners();
  }

  void removeItem(String id){
      _cartItems.remove(id);
      notifyListeners();
  }

  void clearProducts(){
    //20_06: Clear the products in cart when they move to order
    _cartItems = {};
    notifyListeners();
  }

  void removeSingleItem(String productId){
    if(!_cartItems.containsKey(productId)){
      return;
    }
    if(_cartItems[productId]!.quantity>1){
        _cartItems.update(productId.toString(), (existing) => CartItems(cartId: existing.cartId,
            name: existing.name, quantity: existing.quantity,
            pricePerProduct: existing.pricePerProduct - 1)
        );
    }
    else
      {
        _cartItems.remove(productId);
      }
    notifyListeners();
  }
}
