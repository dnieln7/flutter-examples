import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_chat/ui/chat/private_chat.dart';
import 'package:f_chat/widget/no_items_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String myId;

  Stream<QuerySnapshot> snapshot;

  @override
  void initState() {
    getUserInfo();
    fetchChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My chats')),
      body: snapshot == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: snapshot,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final chats = (snapshot.data as QuerySnapshot).docs;

                if (chats.isEmpty) {
                  return NoItemsMessage(
                    title: 'Your chats will be here',
                    subtitle:
                        'You have no chats go to your friends list and start talking!',
                    icon: Icons.chat_sharp,
                  );
                }

                return ListView.separated(
                  itemCount: chats.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (ctx, index) => ChatListTile(
                    myId,
                    chats[index].id,
                    chats[index]['participants'][0],
                    chats[index]['participants'][1],
                  ),
                );
              },
            ),
    );
  }

  Future<void> fetchChats() async {
    setState(() {
      snapshot = FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContainsAny: [myId]).snapshots();
    });
  }

  Future<void> getUserInfo() async {
    myId = FirebaseAuth.instance.currentUser.uid;

    final collection = FirebaseFirestore.instance.collection('users');
    final options = GetOptions(source: Source.cache);
    final snapshotUser = await collection.doc(myId).get(options);
    final snapshotFriend = await collection.doc(myId).get(options);
  }
}

class ChatListTile extends StatefulWidget {
  ChatListTile(this.myId, this.chatId, this.participantId, this.participantId2);

  final String myId;
  final String chatId;
  final String participantId;
  final String participantId2;

  @override
  _ChatListTileState createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  Map<String, dynamic> friend = {};

  @override
  void initState() {
    if (widget.participantId != widget.myId) {
      getUserInfo(widget.participantId)
          .then((result) => setState(() => friend = result));
    }
    else {
      getUserInfo(widget.participantId2)
          .then((result) => setState(() => friend = result));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: friend.containsKey('username') ? toChat : null,
      contentPadding: EdgeInsets.all(10),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColorLight,
        radius: 25,
        child: Icon(
          Icons.chat_sharp,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: friend.containsKey('username')
          ? Text('My private chat with ${friend['username']}')
          : Container(
              width: 100,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
    );
  }

  Future<Map<String, dynamic>> getUserInfo(id) async {
    final collection = FirebaseFirestore.instance.collection('users');
    final options = GetOptions(source: Source.cache);
    final snapshotFriend = await collection.doc(id).get(options);

    return snapshotFriend.data();
  }

  void toChat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ct) => PrivateChat(
            widget.participantId,
            widget.participantId2,
            widget.chatId,
            'My private chat with ${friend['username']}'),
      ),
    );
  }
}
