import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
            Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 1],
        )),
      ),
      SingleChildScrollView(
        child: Container(
          width: deviceSize.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: deviceSize.width > 600 ? 2 : 1,
                  child: AuthCard(),
                ),
              ]),
        ),
      ),
    ]));
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _lastNameFocusNode = FocusNode();
  final _userNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  var _passwordController = TextEditingController();
  var _isLoading = false;

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'username': '',
    'firstName': '',
    'lastName': '',
  };

  AnimationController _slideController;
  AnimationController _opacityController;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 150,
      ),
    );

    _opacityController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 100,
      ),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0.0, -1.5), end: Offset(0.0, 0.0)).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _opacityController, curve: Curves.fastOutSlowIn));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  void _authModeSwitch() {
    if (_authMode == AuthMode.SignUp) {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _slideController.reverse();
      _opacityController.reverse();
    } else {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _slideController.forward();
      _opacityController.forward();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return null;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
          email: _authData['email'],
          password: _authData['password'],
          firstName: _authData['firstName'],
          lastName: _authData['lastName'],
          username: _authData['username'],
        );
      }
    } catch (error) {
      print(error);
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      } else {
        errorMessage = 'Could not Authenticate you.';
      }
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.SignUp ? 500 : 260),
        width: deviceSize.width * 0.75,
        height: _authMode == AuthMode.SignUp ? 320 : 260,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AnimatedContainer(
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                      maxHeight: _authMode == AuthMode.SignUp ? 120 : 0),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'First Name'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_lastNameFocusNode);
                        },
                        onSaved: (value) {
                          _authData['firstName'] = value;
                        },
                        obscureText: false,
                        enabled: _authMode == AuthMode.SignUp,
                        validator: _authMode == AuthMode.SignUp
                            ? (value) {
                                if (value == null) {
                                  return "Name is Empty!";
                                } else
                                  return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                      maxHeight: _authMode == AuthMode.SignUp ? 120 : 0),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Last Name'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_userNameFocusNode);
                        },
                        onSaved: (value) {
                          _authData['lastName'] = value;
                        },
                        focusNode: _lastNameFocusNode,
                        enabled: _authMode == AuthMode.SignUp,
                        validator: _authMode == AuthMode.SignUp
                            ? (value) {
                                if (value == null) {
                                  return 'Last name could not be empty';
                                } else
                                  return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                      maxHeight: _authMode == AuthMode.SignUp ? 120 : 0),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Username'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                        onSaved: (value) {
                          _authData['username'] = value;
                        },
                        focusNode: _userNameFocusNode,
                        enabled: _authMode == AuthMode.SignUp,
                        validator: _authMode == AuthMode.SignUp
                            ? (value) {
                                if (value == null || value.length <= 4) {
                                  return 'username is too short';
                                } else
                                  return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  focusNode: _emailFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  focusNode: _passwordFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(_confirmPasswordFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                AnimatedContainer(
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                      maxHeight: _authMode == AuthMode.SignUp ? 120 : 0),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        textInputAction: TextInputAction.next,
                        focusNode: _confirmPasswordFocusNode,
                        obscureText: true,
                        onSaved: (_) {},
                        enabled: _authMode == AuthMode.SignUp,
                        validator: _authMode == AuthMode.SignUp
                            ? (value) {
                                if (value != _passwordController.value.text) {
                                  return 'errorText';
                                } else
                                  return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  Container(
                    width: 115,
                    child: RaisedButton(
                      child: Text(
                          _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _authModeSwitch,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
