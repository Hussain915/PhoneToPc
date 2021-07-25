import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/folders_screen.dart';
import 'package:shop/widgets/button.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 150,
            backgroundColor: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/imagWtext.png'),
              ],
            ),
          ),
          SizedBox(
            height: 45,
          ),

          // SingleChildScrollView(
          //   child: Container(
          //     height: deviceSize.height,
          //     width: deviceSize.width,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: <Widget>[
          //         Flexible(
          //           child: Container(
          //             child:
          //           ),
          //         ),
          //         // Flexible(
          //         //   flex: deviceSize.width > 600 ? 2 : 1,
          //         //   child: AuthCard(),
          //         // ),
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Button(
              title: 'Login/Sign Up',
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AuthCard())),
            ),
          ),
          SizedBox(
            height: 27,
          ),
          // Button(
          //   title: 'Sign Up',
          //   onPressed: () => Navigator.pushReplacement(
          //       context, MaterialPageRoute(builder: (context) => AuthCard())),
          // ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  // Animations
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("An error occured"),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Ok"))
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    print("User  loged in");
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This Email is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      final errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
              ),
              Text(
                _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: 80),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                height: _authMode == AuthMode.Signup ? 320 : 260,
                // height: _heightAnimation.value.height,
                constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 320 : 260),
                width: deviceSize.width * 0.75,
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'E-Mail'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Invalid email!';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _authData['email'] = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value.isEmpty || value.length < 5) {
                              return 'Password is too short!';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _authData['password'] = value;
                          },
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          constraints: BoxConstraints(
                              minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                              maxHeight:
                                  _authMode == AuthMode.Signup ? 120 : 0),
                          curve: Curves.easeIn,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: TextFormField(
                                enabled: _authMode == AuthMode.Signup,
                                decoration: InputDecoration(
                                    labelText: 'Confirm Password'),
                                obscureText: true,
                                validator: _authMode == AuthMode.Signup
                                    ? (value) {
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match!';
                                        }
                                        return null;
                                      }
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (_isLoading)
                          CircularProgressIndicator()
                        else
                          Button(
                            title: _authMode == AuthMode.Login
                                ? 'LOGIN'
                                : 'SIGN UP',
                            onPressed: _submit,
                          ),
                        // RaisedButton(
                        //   child:
                        //       Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                        //   onPressed: _submit,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(30),
                        //   ),
                        //   padding:
                        //       EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                        //   color: Theme.of(context).primaryColor,
                        //   textColor: Theme.of(context).primaryTextTheme.button.color,
                        // ),
                        FlatButton(
                          child: Text(
                              " ${_authMode == AuthMode.Login ? "Don't have an account?" : 'Already have an account'}  ${_authMode == AuthMode.Login ? 'Create' : 'LOGIN'} Now"),
                          onPressed: _switchAuthMode,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 4),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          textColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
