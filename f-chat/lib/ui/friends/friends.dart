import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_chat/ui/chat/private_chat.dart';
import 'package:f_chat/ui/friends/add_friends.dart';
import 'package:f_chat/widget/no_items_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  String myId;
  String myUsername;

  @override
  void initState() {
    myId = FirebaseAuth.instance.currentUser.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My friends')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add_sharp),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (ctx) => AddFriends(),
            ))
            .then((_) => setState(() {})),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .get(GetOptions(source: Source.serverAndCache)),
        builder: (ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data.data();

          final friends = data.containsKey('friends') ? data['friends'] : [];

          if (friends.isEmpty) {
            return NoItemsMessage(
              title: 'Your friends will be here',
              subtitle: 'You have no friends :( start adding some!',
              icon: Icons.people_sharp,
            );
          }

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (ctx, index) => FriendListTile(friends[index], myId),
          );
        },
      ),
    );
  }
}

class FriendListTile extends StatefulWidget {
  FriendListTile(this.friendId, this.myId);

  final String friendId;
  final String myId;

  @override
  _FriendListTileState createState() => _FriendListTileState();
}

class _FriendListTileState extends State<FriendListTile> {
  Map<String, dynamic> friend = {};

  @override
  void initState() {
    searchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      onTap: friend.containsKey('username') ? attemptToOpenChat : null,
      leading: friend.containsKey('profile-picture')
          ? CircleAvatar(
              backgroundColor: Theme.of(context).primaryColorLight,
              backgroundImage: NetworkImage(friend['profile-picture']),
            )
          : CircleAvatar(
              backgroundColor: Theme.of(context).primaryColorLight,
              child: Icon(
                Icons.person_sharp,
                color: Theme.of(context).primaryColor,
              ),
            ),
      title: friend.containsKey('username')
          ? Text(friend['username'])
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

  Future<void> searchUser() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.friendId)
        .get(GetOptions(source: Source.serverAndCache));

    final user = snapshot.data();

    setState(() => this.friend = user);
  }

  Future<void> attemptToOpenChat() async {
    final chat = {};
    final idMy = '${widget.myId}_+_${widget.friendId}';
    final idOther = '${widget.friendId}_+_${widget.myId}';
    final collection = FirebaseFirestore.instance.collection('chats');
    var snapshot = await collection
        .where(FieldPath.documentId, isEqualTo: idMy)
        .get(GetOptions(source: Source.server));

    if (snapshot.docs.isEmpty) {
      snapshot = await collection
          .where(FieldPath.documentId, isEqualTo: idOther)
          .get(GetOptions(source: Source.server));
    }

    if (snapshot.docs.isEmpty) {
      await collection.doc(idMy).set({
        'owner': widget.myId,
        'participants': [widget.myId, widget.friendId],
      });

      chat.addAll({
        'chat-id': idMy,
        'user1': widget.myId,
        'user2': widget.friendId,
      });
    } else {
      chat.addAll({
        'chat-id': snapshot.docs.first.id,
        'user1': snapshot.docs.first['participants'][0],
        'user2': snapshot.docs.first['participants'][1],
      });
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PrivateChat(
          chat['user1'],
          chat['user2'],
          chat['chat-id'],
          "My private chat with ${friend['username']}",
        ),
      ),
    );
  }
}
