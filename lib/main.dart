import 'package:double_check/frontend/home_page.dart';
import 'package:double_check/models/double_check_info.dart';
import 'package:double_check/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print("CONNECTED FIREBASE");
          } else {
            print("NOT CONNECTED FIREBASE");

          }
          return MaterialApp(
            title: Constants.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.purple,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (context) => DoubleCheckInfo()),
                ],
                child: MyHome()),
          );
        });
  }

  MyApp();
}
