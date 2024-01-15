import 'package:flutter/material.dart';
import 'package:demande_app/LoginScreen.dart';
import 'package:demande_app/SignupScreen.dart';
import 'package:demande_app/demand_list.dart';
import 'package:demande_app/demand_list_usernormal.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demande App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
         '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/demandeu': (context) => DemandListu(),
        '/demandea': (context) => DemandList(),
      },
    );
  }
}
