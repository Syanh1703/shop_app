import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_providers.dart';

enum AuthMode {SignUp, Login}//Different modes for different buttons label

class AuthScreen extends StatelessWidget {
  static const authScreenRouteName = "/auth";

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(//Widget on top of each other in 3D
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0,1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 94.0,
                      vertical: 8.0
                    ),
                    margin: const EdgeInsets.only(bottom: 20.0),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0), //02_07: Transform how the Container should be presented
                    ///Rotation Z: Z axis is from the eyes to the device
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.deepOrange.shade900,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0,2)
                        )
                      ],
                    ),
                    child: Text('Shopping', style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge!.color,
                      fontSize: 50,
                      fontFamily: 'Anton',
                      fontWeight: FontWeight.normal,
                    ),
                    ),
                  ),
                  Flexible(
                      child: AuthCard(),
                      flex: deviceSize.width>600 ? 2 : 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _submit() async {
    if(!_formKey.currentState!.validate()){
      //Invalid
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if(_authMode == AuthMode.Login){
      //Log User in

    }
    else
      {
        //Sign User up
        await Provider.of<AuthProvider>(context, listen: false).signUp(_authData['email'].toString(), _authData['password'].toString());
      }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode(){
    if(_authMode == AuthMode.Login){
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    }
    else
      {
        _authMode = AuthMode.Login;
      }
  }

  @override
  Widget build(BuildContext context) {

    final deviceSize = MediaQuery.of(context).size;
    final RegExp emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final RegExp passValid = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.SignUp ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.SignUp ? 320 : 280
        ),
        width: deviceSize.width*0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value!.isEmpty || !emailValid.hasMatch(value)){
                        return 'Invalid Email';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText:'Password'),
                  controller: _passwordController,
                  obscureText: true, ///Make sure the input is not shown to the user
                  validator: (value){
                    if(value!.isEmpty || value.length < 7){
                      return 'Password is too short';
                    }
                    else if(!passValid.hasMatch(value)){
                      return 'At least one upper case letter, one digit, and special character';
                    }
                  },
                  onSaved: (value){
                    _authData['password'] = value!;
                  },
                ),
                if(_authMode == AuthMode.SignUp)
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp,
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.SignUp ? (value){
                      if(value != _passwordController.text){
                        return 'Password does not match';
                      }
                    } : null,
                  ),
                const SizedBox(
                  height: 10.0,
                ),
                if(_isLoading)
                  const CircularProgressIndicator()
                else
                  Container(
                    decoration: ShapeDecoration(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      child: ElevatedButton(
                        child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                        onPressed: _submit,
                        ),
                    ),
                  ),
                Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6.0
                    ),
                    child: Theme(
                      data: ThemeData.from(colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)),
                      child: TextButton(onPressed: _switchAuthMode,
                          child: Text(_authMode == AuthMode.Login ? 'SIGN UP' : 'LOGIN'),
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

