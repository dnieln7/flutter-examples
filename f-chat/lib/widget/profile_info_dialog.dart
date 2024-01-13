import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_chat/utils/validation_utils.dart';
import 'package:f_chat/widget/email_field.dart';
import 'package:f_chat/widget/text_field_colored.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileInfoDialog extends StatefulWidget {
  ProfileInfoDialog(this.username, this.email);

  final String username;
  final String email;

  @override
  _ProfileInfoDialogState createState() => _ProfileInfoDialogState();
}

class _ProfileInfoDialogState extends State<ProfileInfoDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool working = false;

  String username;
  String email;

  @override
  void initState() {
    username = widget.username;
    email = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.only(top: 15, bottom: 10),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Change my password',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: EmailField(
                  hint: 'Email',
                  value: email,
                  theme: Theme.of(context).primaryColor,
                  changeListener: (text) => email = text,
                  validator: (text) => ValidationUtils.validateEmail(text),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFieldColored(
                  hint: 'Username',
                  value: username,
                  theme: Theme.of(context).primaryColor,
                  changeListener: (text) => username = text,
                  validator: (text) => ValidationUtils.validateUsername(text),
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              if (!working)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text('CANCEL'),
                      onPressed: Navigator.of(context).pop,
                    ),
                    TextButton(
                      child: Text('UPDATE INFO'),
                      onPressed: update,
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              if (working)
                Container(
                  margin: EdgeInsets.only(
                    right: 20,
                    left: 20,
                    top: 5,
                    bottom: 10,
                  ),
                  child: LinearProgressIndicator(),
                ),
              if (working)
                Text(
                  'Updating your info...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void update() async {
    if (formKey.currentState.validate()) {
      setState(() => working = true);

      final auth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;

      await auth.currentUser.updateEmail(email);
      fireStore.collection('users').doc(auth.currentUser.uid).update({
        'username': username,
        'email': email,
      });
    }

    setState(() => working = false);

    Navigator.of(context).pop();
  }
}
