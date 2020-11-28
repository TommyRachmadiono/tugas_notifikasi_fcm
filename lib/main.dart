import 'package:flutter/material.dart';
import 'package:tugas_notifikasi_fcm/pages/home_screen.dart';
import 'package:tugas_notifikasi_fcm/pages/login_screen.dart';
import 'package:tugas_notifikasi_fcm/pages/register_screen.dart';
import 'package:tugas_notifikasi_fcm/pages/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas FCM',
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
      },
    );
  }
}
