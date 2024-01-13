import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_chat/widget/picture_selector_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageInput extends StatefulWidget {
  MessageInput(this.autoScroll, this.chatId);

  final String chatId;
  final Function autoScroll;

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  TextEditingController controller = TextEditingController();
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  hintText: 'Type something',
                  alignLabelWithHint: true,
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 16),
                onChanged: (text) => setState(() => message = text),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).primaryColor,
            ),
            margin: EdgeInsets.only(bottom: 10, right: 10),
            child: IconButton(
              icon: Icon(Icons.add_photo_alternate_sharp, color: Colors.white),
              onPressed: openPictureSelector,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).primaryColor,
            ),
            margin: EdgeInsets.only(bottom: 10, right: 10),
            child: IconButton(
              icon: Icon(Icons.send_sharp, color: Colors.white),
              onPressed: message.trim().isEmpty ? null : sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    final id = FirebaseAuth.instance.currentUser.uid;
    final result =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    final username = result['username'];
    final profilePicture = result['profile-picture'];

    final documentReference = await FirebaseFirestore.instance
        .collection('chats/${widget.chatId}/messages')
        .add({
      'type': 'text',
      'text': message,
      'createdAt': Timestamp.now(),
      'userId': id,
      'username': username,
      'profile-picture': profilePicture,
    });

    controller.clear();
    widget.autoScroll();
    setState(() => message = '');
  }

  void sendPicture(String url) async {
    FocusScope.of(context).unfocus();
    final id = FirebaseAuth.instance.currentUser.uid;
    final result =
    await FirebaseFirestore.instance.collection('users').doc(id).get();
    final username = result['username'];
    final profilePicture = result['profile-picture'];

    final documentReference = await FirebaseFirestore.instance
        .collection('chats/${widget.chatId}/messages')
        .add({
      'type': 'picture',
      'picture': url,
      'createdAt': Timestamp.now(),
      'userId': id,
      'username': username,
      'profile-picture': profilePicture,
    });

    controller.clear();
    widget.autoScroll();
  }

  void openPictureSelector() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => PictureSelectorBottomSheet(),
    ).then((result) {
      if (result.toString().isNotEmpty) {
        sendPicture(result);
      }
    });
  }
}
