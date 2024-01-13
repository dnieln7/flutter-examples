import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_chat/widget/message_bubble.dart';
import 'package:f_chat/widget/message_image_bubble.dart';
import 'package:f_chat/widget/message_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  int itemCount = 0;

  CollectionReference usersCollection;
  Stream<QuerySnapshot> snapshot;

  @override
  void initState() {
    fetchMessages();
    super.initState();
  }

  void autoScroll() {
    if (itemScrollController.isAttached) {
      itemScrollController.scrollTo(
          index: itemCount, duration: Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meeting new people')),
      body: snapshot == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: snapshot,
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final docs = (snapshot.data as QuerySnapshot).docs;
                        final id = FirebaseAuth.instance.currentUser.uid;

                        itemCount = docs.length;

                        autoScroll();

                        return ScrollablePositionedList.builder(
                          initialScrollIndex: docs.length,
                          itemScrollController: itemScrollController,
                          itemPositionsListener: itemPositionsListener,
                          itemCount: docs.length,
                          itemBuilder: (ct, index) =>
                              docs[index]['type'] == 'text'
                                  ? MessageBubble(
                                      message: docs[index]['text'],
                                      username: docs[index]['username'],
                                      profilePicture: docs[index]
                                          ['profile-picture'],
                                      id: docs[index]['userId'],
                                      isMe: docs[index]['userId'] == id,
                                      collection: usersCollection,
                                      key: ValueKey(docs[index].id),
                                    )
                                  : MessageImageBubble(
                                      picture: docs[index]['picture'],
                                      username: docs[index]['username'],
                                      profilePicture: docs[index]
                                          ['profile-picture'],
                                      id: docs[index]['userId'],
                                      isMe: docs[index]['userId'] == id,
                                      collection: usersCollection,
                                      key: ValueKey(docs[index].id),
                                    ),
                        );
                      },
                    ),
                  ),
                  MessageInput(autoScroll, 'general'),
                ],
              ),
            ),
    );
  }

  Future<void> fetchMessages() async {
    setState(() {
      usersCollection = FirebaseFirestore.instance.collection('users');
      snapshot = FirebaseFirestore.instance
          .collection('chats/general/messages')
          .orderBy('createdAt', descending: false)
          .snapshots();
    });
  }
}
