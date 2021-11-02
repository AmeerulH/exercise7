import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(handleMessage);

  runApp(const MyApp());
}

String messageTitle = "Empty";
String notificationAlert = "alert";
List messages = [];

Future<void> handleMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  messages.add(message);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Notifications'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();

    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) {
      print('token is : $value');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        messages.add(message);
        // messageTitle = message.notification!.title.toString();
        // notificationAlert = message.notification!.body.toString();
      });

      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //           title: Text('Notification:'),
      //           content: Text(message.notification!.body.toString()),
      //           actions: [
      //             TextButton(
      //               child: Text('OK'),
      //               onPressed: () {
      //                 Navigator.of(context).pop();
      //               },
      //             )
      //           ]);
      //     });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        messages.add(event);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  color: Colors.amberAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        messages[index].notification!.title.toString(),
                      ),
                      Text(
                        messages[index].notification!.body.toString(),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
