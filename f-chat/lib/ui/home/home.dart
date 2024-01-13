import 'package:f_chat/ui/chat/chat.dart';
import 'package:f_chat/ui/chat/chats.dart';
import 'package:f_chat/ui/friends/friends.dart';
import 'package:f_chat/ui/profile/profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> pages;

  int selectedPage = 0;

  @override
  void initState() {
    pages = [
      Chat(),
      Friends(),
      Chats(),
      Profile(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Theme.of(context).primaryColorLight,
        type: BottomNavigationBarType.shifting,
        showUnselectedLabels: true,
        onTap: (index) => setState(() => selectedPage = index),
        currentIndex: selectedPage,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.emoji_people_sharp),
            label: 'Meeting',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.people_sharp),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.chat_sharp),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.person_sharp),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
