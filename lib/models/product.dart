
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String productId;
  final String productName;
  final String productDes;
  final double productPrice;
  final String productImgUrl;
  bool isFavourite;

  Product({
    required this.productId,
    required this.productName,
    required this.productDes,
    required this.productPrice,
    required this.productImgUrl,
    this.isFavourite = false,
  });

  void _setNewFav(bool newValue){
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavBtn(String token, String userId) async {
    final bool oldStatus = isFavourite;
    //invert the value of isFavourite
    isFavourite = !isFavourite;

    //29_06: Patch request to update the Firebase
    final url = Uri.parse('https://shopapp-375a7-default-rtdb.firebaseio.com/userFav/$userId/$productId.json?auth=$token');
    try{
      final response = await http.put(url, body: json.encode(isFavourite),);
      if(response.statusCode >= 400){
        _setNewFav(oldStatus);
      }
    }catch(error){
      _setNewFav(oldStatus);
    }
    notifyListeners();
}
}
