import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier{
  String _token = ''; //Can be expired in some point of time
  DateTime _expiredTime = DateTime.now();
  String _userId = '';

  ///When log out, all of these fields would be clear


  Future<void> signUp(String email, String pass) async{
    final firebaseUrl = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBPJ_hImjFc3PlTzLcQzdkWtGyFLZJnpWM');
    final response = await http.post(firebaseUrl, body:
        json.encode(
          {
            'email': email,
            'password' : pass,
            'returnSecureToken': true
          }
        )
    );
    print( 'The result is: ${json.decode(response.body)}');
  }
}