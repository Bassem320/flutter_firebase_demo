import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  static final String home_route = '/home';

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  final dbReference = FirebaseDatabase.instance.reference();
  var noteList = [];
  var newNote;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon:Icon(Icons.sync),
            onPressed: (){
              //getNotes();
              getNoteStream();
            },
          ),
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
                  deleteNote();
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
        await _firestore.collection('Notes').getDocuments();
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

  getNoteStream() async{
    await for (var snapshot in _firestore.collection('Notes').snapshots()){
      snapshot.documents.forEach((element) {
        print(element.data);
      });
    }
  }

  setNote(note){
    dbReference.child('Notes').set({'note':note});
  }
  
  readNotes(){
    dbReference.once().then((dataSnapShot){
      print(dataSnapShot.value);
    });
  }

  updateNotes(note){
    dbReference.child('Notes').update({'note':note});
  }

  deleteNote(){
    dbReference.child('Notes').remove();
  }
}
