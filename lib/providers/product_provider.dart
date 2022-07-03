import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http; //Set the prefix to use only http
import 'dart:convert';
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier{//Mixin
  //14_06: Define the list of products
  List<Product> _productsProviderList = [
    // Product(
    //   productId: '1',
    //   productName: 'Red Shirt',
    //   productDes: 'A red shirt - it is pretty red!',
    //   productPrice: 29.99,
    //   productImgUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   productId: '2',
    //   productName: 'Trousers',
    //   productDes: 'A nice pair of trousers.',
    //   productPrice: 59.99,
    //   productImgUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   productId: '3',
    //   productName: 'Yellow Scarf',
    //   productDes: 'Warm and cozy - exactly what you need for the winter.',
    //   productPrice: 19.99,
    //   productImgUrl:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   productId: '4',
    //   productName: 'A Pan',
    //   productDes: 'Prepare any meal you want.',
    //   productPrice: 49.99,
    //   productImgUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];


  List<Product> get item{
    //make sure all the changes happen in this class and change correctly
    return [..._productsProviderList];
  }

  List<Product> get favItems{
    return _productsProviderList.where((productItem) => productItem.isFavourite).toList();
  }

  Product findById(String id){
    return _productsProviderList.firstWhere((prod) => prod.productId == id);
  }

  //28_06: Fetching the product
  Future<void> fetchAndSetProduct() async {
    final url = Uri.parse('https://shopapp-375a7-default-rtdb.firebaseio.com/products.json'); /// Remove json will cause error
    try{
      final response = await http.get(url);
      //28_06: Extract fetched data
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> finalProductList = [];
      if(extractedData==null){
        return;
      }
      extractedData.forEach((prodId, prodVal) {
          finalProductList.add(Product(
              productId: prodId,
              productName: prodVal['title'],
              productDes: prodVal['des'],
              productPrice: prodVal['price'],
              productImgUrl: prodVal['imageUrl'],
              isFavourite: prodVal['isFav'],
            ),
          );
      });
      _productsProviderList = finalProductList;
      notifyListeners();
    }catch(error){
      rethrow;
    }
  }
  Future<void> addProducts(Product product) async {
    //27_06: Send HTTP request to send the data to Firebase
    final url = Uri.parse('https://shopapp-375a7-default-rtdb.firebaseio.com/products.json'); /// Remove json will cause error
    try {
        final response = await http.post(url,
            body: //Use JSON
            json.encode({
              'title': product.productName,
              'des' : product.productDes,
              'imageUrl': product.productImgUrl,
              'price': product.productPrice,
              'isFav': product.isFavourite,
            })
        );
        //27_06: Execute the code when the upper part is done
        final newProd = Product(
            productId: json.decode(response.body)['name'],
            productName: product.productName,
            productDes: product.productDes,
            productPrice: product.productPrice,
            productImgUrl: product.productImgUrl,
        );
        _productsProviderList.add(newProd);
        notifyListeners();
    } catch (error)
    {
        print(error);
        throw error;
    }
    }

  Future<void> updateProducts(Product product, String id) async {
    //28_06: Store the update product on the data server
     final prodIndex = _productsProviderList.indexWhere((element) => element.productId == id);
     if(prodIndex>=0){
       final url = Uri.parse('https://shopapp-375a7-default-rtdb.firebaseio.com/products/$id.json');
       try{
         await http.patch(url,
             body: json.encode(
                 {
                   'title': product.productName,
                   'des': product.productDes,
                   'imageUrl': product.productImgUrl,
                   'price': product.productPrice,
                   'isFav': product.isFavourite
                 }
             )
         );
         _productsProviderList[prodIndex] = product;
         notifyListeners();
       }catch(error){
         throw(error);
       }
       _productsProviderList[prodIndex] = product;
       notifyListeners();
     }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('https://shopapp-375a7-default-rtdb.firebaseio.com/products/$id.json');
    //28_06: Utilize optimistic updating process => remove from the list, not in the memory
    final existingProductIndex = _productsProviderList.indexWhere((element) => element.productId == id);
    var existingProduct = _productsProviderList[existingProductIndex];//store the reference
    _productsProviderList.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
      if(response.statusCode > 400){
          _productsProviderList.insert(existingProductIndex, existingProduct); /// Re-add the product if the deleting task fails
          notifyListeners();
          throw HttpException('Could not delete product');
      }
  }
}