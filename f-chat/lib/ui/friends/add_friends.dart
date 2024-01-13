import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_chat/widget/no_items_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class AddFriends extends StatefulWidget {
  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  SearchBar searchBar;

  bool working = false;
  String username = '';

  String myId;
  List<QueryDocumentSnapshot> users;

  @override
  void initState() {
    searchBar = SearchBar(
      hintText: 'Search by username',
      setState: setState,
      onSubmitted: (value) => searchUser(value),
      buildDefaultAppBar: (ctx) => AppBar(
        title: Text('Search friends'),
        actions: [searchBar.getSearchAction(ctx)],
      ),
    );

    myId = FirebaseAuth.instance.currentUser.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: working
          ? Center(
              child: CircularProgressIndicator(),
            )
          : users == null
              ? NoItemsMessage(
                  title: 'Make new friends',
                  subtitle: 'Find them by their username',
                  icon: Icons.person_search_sharp,
                )
              : users.isEmpty || users.first.id == myId
                  ? NoItemsMessage(
                      title: 'No users found',
                      subtitle:
                          'It seems that $username is not a registered user :(',
                      icon: Icons.search_off_sharp,
                    )
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (ctx, index) => ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColorLight,
                          backgroundImage:
                              NetworkImage(users[index]['profile-picture']),
                        ),
                        title: Text(users[index]['username']),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.person_add_sharp,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () => addFriend(ctx, users[index].id),
                        ),
                      ),
                    ),
    );
  }

  Future<void> searchUser(String username) async {
    setState(() {
      this.username = username;
      this.working = true;
    });

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get(GetOptions(source: Source.serverAndCache));

    final users = snapshot.docs;

    setState(() {
      this.working = false;
      this.users = users;
    });
  }

  Future<void> addFriend(BuildContext context, String userId) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(myId);
    final oldFriendsSnapshot = await doc.get(GetOptions(source: Source.server));
    final oldFriendsSnapshotData = oldFriendsSnapshot.data();
    final oldFriends = oldFriendsSnapshotData.containsKey('friends')
        ? oldFriendsSnapshotData['friends']
        : [];

    await doc.update({
      'friends': [...oldFriends, userId]
    });

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('You have a new friend!')));

    setState(() => this.users = null);
  }
}
