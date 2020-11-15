import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_app/screens/sign_up_route.dart';
import 'package:flutter/material.dart';

import 'home_route.dart';

class SignInRoute extends StatefulWidget {
  static final String sign_in_route =  '/sign_in';

  @override
  _SignInRouteState createState() => _SignInRouteState();
}

class _SignInRouteState extends State<SignInRoute> {
  var email;
  final _auth = FirebaseAuth.instance;
  var password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email'
              ),
              onChanged: (text){
                email = text;
              },
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password'
              ),
              onChanged: (text){
                password = text;
              },
            ),
            SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  child: Text('Sign In'),
                  onPressed: () async{
                    try{
                      final authResult = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
                      if(authResult != null){
                        Navigator.pushNamed(context, HomeRoute.home_route);
                      }
                    }catch(e){
                      print(e);
                    }
                  },
                ),
                RaisedButton(
                  child: Text('Sign Up'),
                  onPressed: (){
                    Navigator.pushNamed(context, SignUpRoute.sign_up_route);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
