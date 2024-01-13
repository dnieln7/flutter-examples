import 'package:f_chat/utils/validation_utils.dart';
import 'package:f_chat/widget/password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordDialog extends StatefulWidget {
  @override
  _PasswordDialogState createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool working = false;
  String password;

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
                child: PasswordField(
                  hint: 'Password',
                  theme: Theme.of(context).primaryColor,
                  changeListener: (text) => password = text,
                  validator: (text) => ValidationUtils.validatePassword(text),
                  hideText: true,
                  inputAction: TextInputAction.done,
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
                      child: Text('CHANGE PASSWORD'),
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
                  'Updating your password...',
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

      await auth.currentUser.updatePassword(password);
    }

    setState(() => working = false);

    Navigator.of(context).pop();
  }
}
