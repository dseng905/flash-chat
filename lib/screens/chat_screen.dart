import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_input_field.dart';
import 'package:flash_chat/components/message_stream.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String messageText;

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    try {
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
        print(loggedInUser.email);
      }
    }
    catch(e) {
      print(e);
    }
  }

  void getMessages() async {
    final messages = await _firestore
        .collection('messages')
        .getDocuments();

    for(var message in messages.documents) {
      print(message.data);
    }
  }

  void messagesStream() async{
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for(var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    messagesStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                //Implement logout functionality
                await _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(
              firestore: _firestore,
              currentUserEmail: loggedInUser.email,
            ),
            MessageInputField(
              controller: messageTextController,
              onChanged: (value) {
                //Do something with the user input.
                messageText = value;
              },
              onSubmit: () {
                //Implement send functionality.
                messageTextController.clear();
                _firestore.collection('messages').add({
                  'text' : messageText,
                  'sender' : loggedInUser.email,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}







