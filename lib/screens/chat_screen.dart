import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _fireStore = FirebaseFirestore.instance;
var loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = "/ChatScreen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<Text> textWidgets = [];

  final _auth = FirebaseAuth.instance;
  var messageText;
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {

    try {
      final user = await _auth.currentUser;
      if ( user != null ) {
        loggedInUser = user;
      }
    }
    catch (e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
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

            messageStreams(),
            
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () {
                      textEditingController.clear();
                      _fireStore.collection('messages').add({ 'message' : messageText, 'sender' : loggedInUser.email });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class messageStreams extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          Center( child: CircularProgressIndicator( color: Colors.lightBlueAccent, ), );
        }
        final messages = snapshot.data!.docs.reversed;
        List<messageBubble> messageBubbles = [];
        for( var message in messages ) {
          final messageText = message["message"];
          final messageSender = message["sender"];
          var messagebubble = messageBubble(messageText: messageText, messageSender: messageSender, isMe: loggedInUser.email == messageSender ? true : false,);
          messageBubbles.add(messagebubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class messageBubble extends StatelessWidget {

  final messageText;
  final messageSender;
  final bool isMe;

  messageBubble({required this.messageText, required this.messageSender, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text("${messageSender}", style: TextStyle(fontSize: 12.0, color: Colors.black54),),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.zero, bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0) ),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text("${messageText}", style: TextStyle(fontSize: 15.0, color: isMe ? Colors.white : Colors.black),),
            ),
          ),
        ],
      ),
    );
  }
}
