import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_bubble.dart';

class MessageStream extends StatelessWidget {
  final Firestore firestore;
  final String currentUserEmail;
  MessageStream({this.firestore, this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          List<MessageBubble> messageWidgets = [];
          if(snapshot.hasData) {
            final messages = snapshot.data.documents.reversed;
            for(var message in messages) {
              final messageText = message.data['text'];
              final messageSender = message.data['sender'];

              final messageWidget = MessageBubble(
                text: messageText,
                sender: messageSender,
                currentUserEmail: currentUserEmail,
              );

              messageWidgets.add(messageWidget);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                children: messageWidgets,
              ),
            );
          }
          else {
            return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                )
            );
          }
        }
    );
  }
}