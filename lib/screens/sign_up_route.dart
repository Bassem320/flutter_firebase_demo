import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_app/screens/home_route.dart';
import 'package:flutter/material.dart';

class SignUpRoute extends StatefulWidget {
  static final String sign_up_route =  '/sign_up';

  @override
  _SignUpRouteState createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
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
            RaisedButton(
              child: Text('Sign Up'),
              onPressed: () async{
               try{
                 final authResult = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
                 if(authResult != null){
                   Navigator.pushNamed(context, HomeRoute.home_route);
                 }
               }catch(e){
                 print(e);
               }
              },
            ),
          ],
        ),
      ),
    );
  }
}
