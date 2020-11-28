import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tugas_notifikasi_fcm/pages/home_screen.dart';
import 'package:tugas_notifikasi_fcm/pages/register_screen.dart';
import 'package:tugas_notifikasi_fcm/service/shared_preference_service.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_notifikasi_fcm/constant.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = false;
  bool isLoading = false;

  SharedPreferenceService preferenceService = SharedPreferenceService();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void cekIsLogin() async {
    await preferenceService.initPref();
    final result = await preferenceService.isLogin();
    setState(() {
      isLogin = result;
    });
  }

  void login() async {
    var form = _formKey.currentState;

    if (form.validate()) {
      setState(() {
        isLoading = true;
      });
      cekDataLogin();
    }
  }

  void cekDataLogin() async {
    try {
      http.Response response = await http.post("$baseUrl/login-mobile", body: {
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      });
      final result = jsonDecode(response.body);
      print(result);

      if (result['value'] == 1) {
        preferenceService.savePref(key: 'isLogin', value: true);
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else if (result['value'] == 0) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              result['msg'],
            ),
            duration: Duration(
              seconds: 3,
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    cekIsLogin();
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? HomeScreen()
        : Scaffold(
            key: _scaffoldKey,
            body: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(20.0),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login Page',
                      style: TextStyle(
                        fontSize: 30,
                        letterSpacing: 3.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextFormField(
                                controller: _emailController,
                                validator: (value) =>
                                    value.isEmpty ? 'Email required' : null,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                  ),
                                  labelText: 'Email',
                                ),
                              ),
                              TextFormField(
                                controller: _passwordController,
                                validator: (value) =>
                                    value.isEmpty ? 'Password required' : null,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                  ),
                                  labelText: 'Password',
                                ),
                              ),
                              SizedBox(height: 20.0),
                              isLoading
                                  ? SpinKitThreeBounce(
                                      color: Colors.blueGrey,
                                      size: 50,
                                    )
                                  : Container(
                                      width: double.infinity,
                                      child: RaisedButton.icon(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        onPressed: () {
                                          login();
                                        },
                                        icon: Icon(Icons.login),
                                        label: Text('Sign In'),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account ? "),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RegisterScreen.routeName,
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
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
