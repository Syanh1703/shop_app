import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier{
  String _token = ''; //Can be expired in some point of time
  DateTime? _expiredTime;
  String _userId = '';
  Timer? _authTimer;
  final String keyInPrefs = 'userData';

  ///When log out, all of these fields would be clear
  bool get isAuth{

      return token.isNotEmpty;
  }

  String get token{
    if(_expiredTime != null && _expiredTime!.isAfter(DateTime.now()) && _token.isNotEmpty){
      return _token;
    }
    return '';
  }

  String get userId{
    return _userId;
  }


  Future<void> _authenticate(String email, String pass, String urlSegment) async{
    final firebaseUrl = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBPJ_hImjFc3PlTzLcQzdkWtGyFLZJnpWM');
    try{
      final response = await http.post(firebaseUrl, body:
      json.encode(
          {
            'email': email,
            'password' : pass,
            'returnSecureToken': true
          }
      )
      );
      final extractedData = json.decode(response.body);
      if(extractedData['error'] != null){
        //Have a problem
        throw HttpException(extractedData['error']['message']);
      }
      //No error, assign values to provided variables
      _token = extractedData['idToken'];
      _userId = extractedData['localId'];
      _expiredTime = DateTime.now().add(
          Duration(seconds: int.parse(extractedData['expiresIn']))
      );
      _autoLogOut();
      notifyListeners();

      ///06_07: Store the data in the device
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiredDate':_expiredTime!.toIso8601String()
      });
      prefs.setString(keyInPrefs, userData);//Set = write data to the device storage
    }catch(error){
      throw error;
    }
  }

  Future<void> signUp(String email, String pass) async{
    // final firebaseUrl = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBPJ_hImjFc3PlTzLcQzdkWtGyFLZJnpWM');
    // final response = await http.post(firebaseUrl, body:
    //     json.encode(
    //       {
    //         'email': email,
    //         'password' : pass,
    //         'returnSecureToken': true
    //       }
    //     )
    // );
    // print( 'The signUp result is: ${json.decode(response.body)}');

    return _authenticate(email, pass, 'signUp');
  }
  
  Future<void> logIn(String email, String pass) async{
    return _authenticate(email, pass, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey(keyInPrefs)){
      return false;
    }
    final extractedUserData = json.decode(prefs.getString(keyInPrefs)!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiredDate']);
    if(expiryDate.isBefore(DateTime.now())){ //Check is the user Data expired
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiredTime = expiryDate;
    notifyListeners();
    _autoLogOut();
    return true;
  }

  Future<void> logOut() async {
    ///06_07: Reset the token and the userid
    _token = '';
    _userId = '';
    _expiredTime = null;
    if(_authTimer != null){
      _authTimer!.cancel();//Cancel the existing Timer if available
      _authTimer = null;
    }

    //Clear all data in the Shared Preferences
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(keyInPrefs);
  }

  void _autoLogOut(){
    ///06_07: Set a timer for auto log out
    if(_authTimer != null){
      _authTimer!.cancel();//Cancel the existing Timer if available
    }
    final timeToExpire = _expiredTime!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logOut);
  }
}