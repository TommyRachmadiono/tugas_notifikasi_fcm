import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tugas_notifikasi_fcm/constant.dart';
import 'package:tugas_notifikasi_fcm/pages/login_screen.dart';
import 'package:tugas_notifikasi_fcm/service/shared_preference_service.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref;
  FirebaseMessaging fm = FirebaseMessaging();

  TextEditingController _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref = database.reference().child('todos');
    getNotif();
  }

  void sendNotif() async {
    final fcmBody = jsonEncode({
      'to': '/topics/topicsMentoring',
      'topic': 'topicsMentoring',
      'notification': {
        'title': 'FCM message',
        'body': 'Tes fcm flutter mentoring udacoding',
        'sound': 'default',
      },
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'body': 'Ada data todo baru, ${_todoController.text}',
        'myData': ['data 1', 'data 2', 'data 3'],
      }
    });

    await http.post(
      fcmEndPoint,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: fcmKey,
      },
      body: fcmBody,
    );
  }

  getNotif() async {
    fm.subscribeToTopic("topicsMentoring");
    fm.configure(
      // ketika berada di aplikasi, sedang dibuka, muncul di layar
      onMessage: (message) async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Notifikasi FCM onMessage'),
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(message['data']['body']),
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    var arrData = jsonDecode(message['data']['myData']);
                    print(arrData);
                  },
                  child: Text('ok'),
                ),
              ],
            );
          },
        );
        _todoController.clear();
      },
      // ketika apps ditutup tapi berada di backgroud / buka aplikasi -> tekan tombol home -> tidak di clear di background
      onLaunch: (message) async {
        var arrData = jsonDecode(message['data']['myData']);
        print(arrData);
        print('FCM data onLaunch : $message');
      },
      // ketika apps tidak sedang berjalan, tidak ada di background, belum di run
      onResume: (message) async {
        var arrData = jsonDecode(message['data']['myData']);
        print(arrData);
        print('FCM data onResume : $message');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await SharedPreferenceService.clearLoginData();
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginScreen.routeName,
                (route) => false,
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextField(
                      controller: _todoController,
                    ),
                  ),
                  Flexible(
                    child: RaisedButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        ref.push().set({'title': _todoController.text});

                        sendNotif();
                      },
                      child: Text('Add Todo'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                child: FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: ref,
                  itemBuilder: (context, snapshot, animation, index) {
                    return ListTile(
                      leading: Icon(Icons.format_list_bulleted),
                      title: Text(snapshot.value['title']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          ref.child(snapshot.key).remove();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
