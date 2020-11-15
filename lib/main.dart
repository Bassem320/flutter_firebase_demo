import 'package:firebase_flutter_app/screens/home_route.dart';
import 'package:firebase_flutter_app/screens/sign_in_route.dart';
import 'package:firebase_flutter_app/screens/sign_up_route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: SignInRoute.sign_in_route,
      routes: {
        SignInRoute.sign_in_route:(context)=>SignInRoute(),
        SignUpRoute.sign_up_route:(context)=>SignUpRoute(),
        HomeRoute.home_route:(context)=>HomeRoute(),
      },
    );
  }
}


