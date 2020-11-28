import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tugas_notifikasi_fcm/pages/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseMessaging fm = FirebaseMessaging();

  Future<void> initTimer() async {
    var duration = Duration(seconds: 5);

    Timer(duration, () {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    });
  }

  @override
  void initState() {
    super.initState();
    fm.subscribeToTopic("topicsMentoring");
    initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: Center(
        child: SpinKitFoldingCube(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
