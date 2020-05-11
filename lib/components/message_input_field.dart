import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class MessageInputField extends StatelessWidget {
  final Function onSubmit;
  final Function onChanged;
  final TextEditingController controller;
  MessageInputField({this.onSubmit,this.onChanged, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kMessageContainerDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: kMessageTextFieldDecoration,
            ),
          ),
          FlatButton(
            onPressed: onSubmit,
            child: Text(
              'Send',
              style: kSendButtonTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}