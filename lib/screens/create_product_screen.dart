
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';

class CreateProductScreen extends StatefulWidget {
  static const String createProductRouteName = '/create_product';

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _priceFocusNode = FocusNode();
  final _desFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _imgUrlFocusNode = FocusNode();
  final _formGlobalKey = GlobalKey<FormState>();//Allow users to interact with the state in the Form Widget
  var _editedProduct = Product(
      productId: '',
      productName: '',
      productDes: '',
      productPrice: 0/0,
      productImgUrl: '');

  var _isInit = true;
  var _initValues = {
    'title': '',
    'des': '',
    'price': '',
    'imageUrl': '',
  };

  var _isLoading = false;

  /**
   * Use dispose method when working with Focus Node
   * Clear up the memory to prevent memory leak
   */

  @override
  void initState() {
    _imgUrlFocusNode.addListener(() {
      _updateImageUrl();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //25_06: Extract the value from the upload product screen
    if(_isInit == true){
        final String productId = ModalRoute.of(context)?.settings.arguments == null ? '' : ModalRoute.of(context)!.settings.arguments as String;
        //25_06: Check having the product
        if(productId != ''){
          final newProd = Provider.of<ProductsProvider>(context, listen: false).findById(productId); //Update the edit product
          _editedProduct = newProd;
          _initValues = {
            'title': _editedProduct.productName,
            'des': _editedProduct.productDes,
            'price': _editedProduct.productPrice.toString(),
            'imageUrl': '',
        };
          _imgUrlController.text = _editedProduct.productImgUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl(){
      if(!_imgUrlFocusNode.hasFocus){
        //Update the UI
        setState(() {
            if((!_imgUrlController.text.startsWith('http') &&
                !_imgUrlController.text.startsWith('https')) ||
                (!_imgUrlController.text.endsWith('.jpg') &&
                !_imgUrlController.text.endsWith('.png') &&
                !_imgUrlController.text.endsWith('.jpeg'))){
              return;
            }
        });
      }
  }

  @override
  void dispose() {
    _imgUrlFocusNode.removeListener(() {
      _updateImageUrl();
    });
   _priceFocusNode.dispose();
   _desFocusNode.dispose();
   _imgUrlController.dispose();
    _imgUrlFocusNode.dispose();
   super.dispose();
  }


  void _saveForm() async {
    //24_6: Use global key to access the Widget
   final isValid =  _formGlobalKey.currentState!.validate();//Trigger all the validators used in the form
   if(!isValid){
     return;
   }
    _formGlobalKey.currentState!.save();
   setState(() {
     _isLoading = true;
   });
   if(_editedProduct.productId != ''){
      //The product is existed
      await Provider.of<ProductsProvider>(context, listen: false).updateProducts(_editedProduct, _editedProduct.productId);
   }
   else{
     try{
       await Provider.of<ProductsProvider>(context, listen: false).addProducts(_editedProduct);
     } catch(error){
       await showDialog(context: context,
         builder: (context) => AlertDialog(
           title: const Text('Error in creating new product'),
           content: const Text('Something wen wrong'),
           actions: <Widget>[
             TextButton(onPressed: (){
               Navigator.of(context).pop();
                }, child: const Text('OK'))
           ],
         ),
       );
     }
     // finally{
     //   //28_06: Run this whether the upper code success or fail
     //     setState(() {
     //       _isLoading = true;
     //     });
     //     Navigator.of(context).pop();
     //   }
     }
     setState(() {
       _isLoading = true;
     });
     Navigator.of(context).pop();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: const Text('Create a Product', style: TextStyle(
           fontSize: 20,
         ),
         ),
         actions: <Widget>[
           IconButton(onPressed: _saveForm,
               icon: const Icon(Icons.save),
           )
         ],
       ),
      body: _isLoading ? const Center(
          child: CircularProgressIndicator(),
      ) : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          //24_06: Establish the connection to the global key
          key: _formGlobalKey,
          //24_06: Invisible = Does not render anything on the screen
          child: ListView(
            children: <Widget>[
              //Add inputs
              TextFormField(
                initialValue: _initValues['title'],
                //22_06: Auto connect with Form behind the scene
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_desFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(productName: value.toString(),
                      productId: _editedProduct.productId, productDes: _editedProduct.productDes,
                      productPrice: _editedProduct.productPrice,
                      productImgUrl: _editedProduct.productImgUrl,
                      isFavourite: _editedProduct.isFavourite);
                },
                validator: (value) {
                  if(value!.isEmpty){
                    return 'This filed must not be empty';
                  }
                  else if(value.length<=3){
                    return 'The name must be more than 3 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['des'],
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _desFocusNode,
                onFieldSubmitted: (_){
                  //Move the focus node to the next input
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(productName: _editedProduct.productName,
                      productId: _editedProduct.productId, productDes: value.toString(),
                      productPrice: _editedProduct.productPrice,
                      productImgUrl: _editedProduct.productImgUrl,
                      isFavourite: _editedProduct.isFavourite);
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'This field must not be empty';
                  }
                  else if(value.length<=20){
                    return 'The description must be at least 20 characters long';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: '\$23',
                  hintStyle: TextStyle(fontSize: 15),
                ),
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onSaved: (value){
                  _editedProduct = Product(productName: _editedProduct.productName,
                      productId: _editedProduct.productId, productDes: _editedProduct.productDes,
                      productPrice: double.parse(value!),
                      productImgUrl: _editedProduct.productImgUrl,
                      isFavourite: _editedProduct.isFavourite);
                },
                validator: (value){
                  if(double.parse(value!).isNegative){
                    return 'The price cannot be negative';
                  }
                  else if(double.parse(value)==0.0){
                    return 'The price must be larger than 0';
                  }
                  else if(value.isEmpty){
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              ///The user needs to enter the URL for the image

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      )
                    ),
                    child: _imgUrlController.text.isEmpty ? const Text('Enter the URL please!!', style: TextStyle(fontSize: 14),): FittedBox(
                      child: Image.network(_imgUrlController.text),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imgUrlFocusNode, //When it looses the focus, it can load the image
                      controller: _imgUrlController,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value){
                        _editedProduct = Product(productName: _editedProduct.productName,
                            productId: _editedProduct.productId, productDes: _editedProduct.productDes,
                            productPrice: _editedProduct.productPrice,
                            productImgUrl: value as String,
                            isFavourite: _editedProduct.isFavourite);
                      },
                      validator: (value){
                        if(value!.isEmpty){
                          return 'This field must not be empty';
                        }
                        else if(!value.startsWith('http') && !value.startsWith('https')){
                          return 'Enter the valid URL';
                        }
                        else if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')){
                          return 'This link is not the image URL';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
