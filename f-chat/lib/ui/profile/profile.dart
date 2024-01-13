import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_chat/widget/password_dialog.dart';
import 'package:f_chat/widget/profile_info_dialog.dart';
import 'package:f_chat/widget/profile_picture_dialog.dart';
import 'package:f_chat/widget/text_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Stream<DocumentSnapshot> snapshot;
  String id;

  @override
  void initState() {
    id = FirebaseAuth.instance.currentUser.uid;
    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: snapshot == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<DocumentSnapshot>(
              stream: snapshot,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final username = snapshot.data['username'];
                final email = snapshot.data['email'];
                final profilePicture = snapshot.data['profile-picture'];

                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          username ?? 'My profile',
                          style: TextStyle(
                            fontSize: 20,
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      expandedHeight: 500,
                      pinned: true,
                      actions: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: FloatingActionButton(
                            elevation: 0,
                            backgroundColor: Theme.of(context).primaryColor,
                            tooltip: 'Edit profile picture',
                            onPressed: showEditProfilePictureDialog,
                            child: Icon(
                              Icons.add_photo_alternate_sharp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: profilePicture != null
                            ? Image.network(
                                profilePicture,
                                fit: BoxFit.fill,
                              )
                            : CircleAvatar(
                                radius: 100,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Icon(
                                  Icons.person_sharp,
                                  size: 250,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Card(
                          margin: EdgeInsets.all(20),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              children: [
                                TextIcon(
                                  text: email ?? '',
                                  label: 'Email',
                                  icon: Icons.email_sharp,
                                ),
                                SizedBox(height: 20),
                                TextIcon(
                                  text: username ?? '',
                                  label: 'Username',
                                  icon: Icons.person_sharp,
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton.icon(
                                icon: Icon(Icons.edit_sharp),
                                label: Text('EDIT PROFILE INFO'),
                                onPressed: () => showEditDialog(
                                  username,
                                  email,
                                ),
                              ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.lock_sharp),
                                label: Text('CHANGE PASSWORD'),
                                onPressed: showEditPasswordDialog,
                              ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.exit_to_app_sharp),
                                label: Text('SIGN OUT'),
                                onPressed: showSignOutDialog,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.50),
                      ]),
                    ),
                  ],
                );
              }),
    );
  }

  void fetchUserData() async {
    setState(() {
      snapshot =
          FirebaseFirestore.instance.collection('users').doc(id).snapshots();
    });
  }

  void showEditDialog(String username, String email) {
    showDialog(
      context: context,
      builder: (ctx) => ProfileInfoDialog(username, email),
    );
  }

  void showEditPasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => PasswordDialog(),
    );
  }

  void showEditProfilePictureDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ProfilePictureDialog(),
    );
  }

  void showSignOutDialog() {
    FirebaseAuth.instance.signOut();
  }
}
