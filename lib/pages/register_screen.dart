import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_notifikasi_fcm/constant.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _rePasswordController = TextEditingController();

  void register() async {
    var form = _formKey.currentState;

    if (form.validate()) {
      setState(() {
        isLoading = true;
      });
      cekDataRegister();
    }
  }

  void cekDataRegister() async {
    try {
      http.Response response =
          await http.post("$baseUrl/register-mobile", body: {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      });

      final result = jsonDecode(response.body);
      if (result['value'] == 1) {
        // Tampilkan Message success
        Fluttertoast.showToast(
          msg: "Register success",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _rePasswordController.clear();
      } else if (result['value'] == 0) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              result['error'],
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
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Register Page',
                style: TextStyle(
                  fontSize: 30,
                  letterSpacing: 3.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
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
                          keyboardType: TextInputType.text,
                          controller: _nameController,
                          validator: (value) =>
                              value.isEmpty ? 'Name required' : null,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                            labelText: 'Name',
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) =>
                              value.isEmpty ? 'Email required' : null,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                            ),
                            labelText: 'Email',
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) =>
                              value.isEmpty ? 'Password required' : null,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            labelText: 'Password',
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          controller: _rePasswordController,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Confirm Password must be same with password';
                            } else if (value.isEmpty) {
                              return 'Confirm password required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            labelText: 'Confirm Password',
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
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () {
                                    register();
                                  },
                                  icon: Icon(Icons.app_registration),
                                  label: Text('Sign Up'),
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
                  Text("Already have an account ? "),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Sign In",
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
