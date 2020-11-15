import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  static final String home_route = '/home';

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  var noteList = [];
  var newNote;
  @override
  Widget build(BuildContext context) {
    getNotes();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.message),
                  title: Text('${noteList[index]}'),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: 'Enter Note'),
                  onChanged: (text) {
                    newNote = text;
                  },
                ),
              ),
              RaisedButton(
                child: Text('Send'),
                onPressed: () async {
                  var user = await _auth.currentUser();
                  var userId = user.uid;
                  var timeStamp = DateTime.now().millisecondsSinceEpoch;
                  _firestore.collection('Notes').add({
                    'userId': '$userId',
                    'note': newNote,
                    'time': timeStamp
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }

  getNotes() async {
    var noteSnapShot =
        await _firestore.collection('Notes').orderBy('time').getDocuments();
    noteList = [];
    var user = await _auth.currentUser();
    var userId = user.uid;
    noteSnapShot.documents.forEach((element) {
      setState(() {

        if(element.data['userId'] == userId){
          noteList.add(element.data['note']);
        }

      });
      print(element.data);
    });
  }
}